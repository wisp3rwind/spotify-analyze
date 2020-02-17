function readUntilTab(buffer, offset)
	local initial_offset = offset
	local bytes = buffer:bytes()
	while true do
		if bytes:get_index(offset) == 0x09 then
			break
		end

		offset = offset + 1
	end

	return offset + 1, buffer:range(initial_offset, offset - initial_offset)
end


---------------------------------------------------------------------------
-- Track played (372)

es_track_played = Proto("es_track_played", "Track played event")
es_track_played.fields.playback_id = ProtoField.new("Playback ID", "es_track_played.playback_id", ftypes.STRING)
es_track_played.fields.track_uri = ProtoField.new("Track URI", "es_track_played.track_uri", ftypes.STRING)

function es_track_played.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_track_played, buffer(), "Track played event")

	offset, playback_id = readUntilTab(buffer, 0)
	subtree:add(es_track_played.fields.playback_id, playback_id)

	offset, track_uri = readUntilTab(buffer, offset)
	subtree:add(es_track_played.fields.track_uri, track_uri)
end

---------------------------------------------------------------------------

local event_service_dt = DissectorTable.new ("event_service.op", "Operation", ftypes.STRING)
event_service_dt:add("372", es_track_played)


event_service = Proto("event_service", "Event service")
local esf = event_service.fields
esf.op = ProtoField.new("Operation", "event_service.op", ftypes.STRING)
esf.post_op = ProtoField.new("Post operation (??)", "event_service.post_op", ftypes.STRING)

function event_service.dissector(buffer, pinfo, tree)
	local subtree = tree:add (event_service, buffer(), "Event service")

	offset, op = readUntilTab(buffer, 0)
	subtree:add(esf.op, op)

	offset, post_op = readUntilTab(buffer, offset)
	subtree:add(esf.post_op, post_op)

	event_service_dt:try(op:string(), buffer:range(offset):tvb(), pinfo, subtree)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------


mercury = Proto("mercury", "Mercury")

local mercury_dt = DissectorTable.new ("mercury.content_type", "Mercury", ftypes.STRING)

local f = mercury.fields
f.seq_length = ProtoField.uint16("mercury.seq_length", "Sequence number size")
f.seq = ProtoField.bytes("mercury.seq", "Sequence number")
f.flags = ProtoField.uint8("mercury.flags", "Flags")
f.part_count = ProtoField.uint16("mercury.part_count", "Part count")

local header_method = Field.new("header.method")
local header_uri = Field.new("header.uri")
local header_status_code = Field.new("header.status_code")
local header_content_type = Field.new("header.content_type")

function parse_payload(buffer, offset)
    local size = buffer(offset, 2)
    offset = offset + 2
    local data = buffer(offset, size:uint()):tvb()
    offset = offset + size:uint()

    return data, offset
end

function starts_with(str, start)
   return str:sub(1, #start) == start
end

function mercury.dissector(buffer, pinfo, tree)
    local subtree = tree:add (mercury, buffer(), "Mercury")
    pinfo.cols.protocol = "Mercury"

    local offset = 0;
    local seq_length = buffer(offset, 2)
    offset = offset + 2
    local seq = buffer(offset, seq_length:uint())
    offset = offset + seq_length:uint()
    local flags = buffer(offset, 1)
    offset = offset + 1
    local part_count = buffer(offset, 2)
    offset = offset + 2

    subtree:add(f.seq_length, seq_length)
    subtree:add(f.seq, seq)
    subtree:add(f.flags, flags)
    subtree:add(f.part_count, part_count)

    local header_data
    header_data, offset = parse_payload(buffer, offset)

    DissectorTable.get("protobuf"):try("Header", header_data, pinfo, subtree)

    local uri = header_uri()
    if uri ~= nil then
        pinfo.cols.info = (header_method() or header_status_code()).value .. " " .. uri.value
    else
        pinfo.cols.info = (header_method() or header_status_code()).value
    end

    local part_count = part_count:uint()

    local content_type = header_content_type()
    if part_count > 1 then
        local payload_data, offset2
        payload_data, offset2 = parse_payload(buffer, offset)
        if content_type ~= nil then
            mercury_dt:try(content_type.value, payload_data, pinfo, subtree)
        elseif string.match(uri.value, "hm://remote/") then
            DissectorTable.get("protobuf"):try("SpircFrame", payload_data, pinfo, tree)
        elseif header_method().value == "POST" and starts_with(uri.value, "hm://event-service/v1/") then
        	event_service.dissector:call(payload_data, pinfo, tree)
        end
        part_count = part_count - 1
    end

    for i=1, part_count-1 do
        local payload_data
        payload_data, offset = parse_payload(buffer, offset)
        DissectorTable.get("protobuf"):try("Generic", payload_data, pinfo, subtree)
    end
end

DissectorTable.get("spotify.cmd"):add(0xb2, mercury)
DissectorTable.get("spotify.cmd"):add(0xb3, mercury)
DissectorTable.get("spotify.cmd"):add(0xb4, mercury)
DissectorTable.get("spotify.cmd"):add(0xb5, mercury)

function add_payload_type(content_type, proto)
    local dissector = DissectorTable.get("protobuf"):get_dissector(proto)
    if dissector ~= nil then
        mercury_dt:add(content_type, dissector)
    end
end

add_payload_type("vnd.spotify/mercury-mget-request", "MercuryMultiGetRequest")
add_payload_type("vnd.spotify/mercury-mget-reply", "MercuryMultiGetReply")
add_payload_type("application/x-protobuf", "Generic")
mercury_dt:add("vnd.spotify/abba-feature-flags+json", Dissector.get("json"))
