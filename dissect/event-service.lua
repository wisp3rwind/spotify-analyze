function readUntilTab(buffer, offset)
	local initial_offset = offset
	local bytes = buffer:bytes()
	while offset < buffer:len() do
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
es_track_played.fields.unknown = ProtoField.new("Unknown", "es_track_played.unknown", ftypes.STRING)

function es_track_played.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_track_played, buffer(), "Track played event")

	offset, playback_id = readUntilTab(buffer, 0)
	subtree:add(es_track_played.fields.playback_id, playback_id)

	offset, track_uri = readUntilTab(buffer, offset)
	subtree:add(es_track_played.fields.track_uri, track_uri)

	offset, unknown = readUntilTab(buffer, offset)
	subtree:add(es_track_played.fields.unknown, unknown)

    offset, interval = readUntilTab(buffer, offset)
	Dissector.get("json"):call(interval:tvb(), pinfo, subtree)
end

---------------------------------------------------------------------------

local event_service_dt = DissectorTable.new ("event_service.op", "Operation", ftypes.STRING)
event_service_dt:add("372", es_track_played)


event_service = Proto("event_service", "Event service")
local esf = event_service.fields
esf.op = ProtoField.new("Operation", "event_service.op", ftypes.STRING)
esf.unknown = ProtoField.new("Unknown", "event_service.unknown", ftypes.STRING)

function event_service.dissector(buffer, pinfo, tree)
	local subtree = tree:add (event_service, buffer(), "Event service")

	offset, op = readUntilTab(buffer, 0)
	subtree:add(esf.op, op)

	offset, unknown = readUntilTab(buffer, offset)
	subtree:add(esf.unknown, unknown)

	event_service_dt:try(op:string(), buffer:range(offset):tvb(), pinfo, subtree)
end
