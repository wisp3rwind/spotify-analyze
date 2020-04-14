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

	pinfo.cols.info = "event-service: Track played " .. track_uri:string()
end

---------------------------------------------------------------------------
-- Report session ID (557)

es_report_session_id = Proto("es_report_session_id", "Report session ID")
es_report_session_id.fields.session_id = ProtoField.new("Session ID", "es_report_session_id.session_id", ftypes.STRING)
es_report_session_id.fields.uri_1 = ProtoField.new("Context URI 1", "es_report_session_id.uri_1", ftypes.STRING)
es_report_session_id.fields.uri_2 = ProtoField.new("Context URI 2", "es_report_session_id.uri_2", ftypes.STRING)
es_report_session_id.fields.timestamp = ProtoField.new("Timestamp", "es_report_session_id.timestamp", ftypes.STRING)
es_report_session_id.fields.length = ProtoField.new("Length", "es_report_session_id.length", ftypes.STRING)
es_report_session_id.fields.url = ProtoField.new("Context URL", "es_report_session_id.url", ftypes.STRING)

function es_report_session_id.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_report_session_id, buffer(), "Report session ID")

	offset, session_id = readUntilTab(buffer, 0)
	subtree:add(es_report_session_id.fields.session_id, session_id)

	offset, uri_1 = readUntilTab(buffer, offset)
	subtree:add(es_report_session_id.fields.uri_1, uri_1)

	offset, uri_2 = readUntilTab(buffer, offset)
	subtree:add(es_report_session_id.fields.uri_2, uri_2)

	offset, ts = readUntilTab(buffer, offset)
	subtree:add(es_report_session_id.fields.timestamp, ts)

	offset, scrap = readUntilTab(buffer, offset)

	offset, length = readUntilTab(buffer, offset)
	subtree:add(es_report_session_id.fields.length, length)

	offset, url = readUntilTab(buffer, offset)
	subtree:add(es_report_session_id.fields.url, url)


	pinfo.cols.info = "event-service: Session ID (" .. session_id:string() .. ")"
end

---------------------------------------------------------------------------
-- Report playback ID (558)

es_report_playback_id = Proto("es_report_playback_id", "Report playback ID")
es_report_playback_id.fields.playback_id = ProtoField.new("Playback ID", "es_report_playback_id.playback_id", ftypes.STRING)
es_report_playback_id.fields.session_id = ProtoField.new("Session ID", "es_report_playback_id.session_id", ftypes.STRING)
es_report_playback_id.fields.timestamp = ProtoField.new("Timestamp", "es_report_playback_id.timestamp", ftypes.STRING)

function es_report_playback_id.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_report_playback_id, buffer(), "Report playback ID")

	offset, playback_id = readUntilTab(buffer, 0)
	subtree:add(es_report_playback_id.fields.playback_id, playback_id)

	offset, session_id = readUntilTab(buffer, offset)
	subtree:add(es_report_playback_id.fields.session_id, session_id)

	offset, ts = readUntilTab(buffer, offset)
	subtree:add(es_report_playback_id.fields.timestamp, ts)

	pinfo.cols.info = "event-service: Playback ID (" .. playback_id:string() .. ")"
end

---------------------------------------------------------------------------
-- Fetched file ID (274)

es_fetched_file_id = Proto("es_fetched_file_id", "Fetched file ID")
es_fetched_file_id.fields.two_1 = ProtoField.new("This says 2", "es_fetched_file_id.two_1", ftypes.STRING)
es_fetched_file_id.fields.two_2 = ProtoField.new("This says 2", "es_fetched_file_id.two_2", ftypes.STRING)
es_fetched_file_id.fields.file_id = ProtoField.new("File ID", "es_fetched_file_id.file_id", ftypes.STRING)
es_fetched_file_id.fields.track_uri = ProtoField.new("Track URI", "es_fetched_file_id.track_uri", ftypes.STRING)
es_fetched_file_id.fields.number_1 = ProtoField.new("Number 1", "es_fetched_file_id.number_1", ftypes.STRING)
es_fetched_file_id.fields.number_2 = ProtoField.new("Number 2", "es_fetched_file_id.number_2", ftypes.STRING)
es_fetched_file_id.fields.number_3 = ProtoField.new("Number 3", "es_fetched_file_id.number_3", ftypes.STRING)

function es_fetched_file_id.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_fetched_file_id, buffer(), "Fetched file ID")

	offset, two_1 = readUntilTab(buffer, 0)
	subtree:add(es_fetched_file_id.fields.two_1, two_1)

	offset, two_2 = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.two_2, two_2)

	offset, file_id = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.file_id, file_id)

	offset, track_uri = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.track_uri, track_uri)

	offset, number_1 = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.number_1, number_1)

	offset, number_2 = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.number_2, number_2)

	offset, number_3 = readUntilTab(buffer, offset)
	subtree:add(es_fetched_file_id.fields.number_3, number_3)

	pinfo.cols.info = "event-service: Fetched file ID (" .. track_uri:string() .. " => " .. file_id:string() .. ")"
end

---------------------------------------------------------------------------
-- Set variable (268)

es_set_variable = Proto("es_set_variable", "Set variable")
es_set_variable.fields.key = ProtoField.new("Key", "es_set_variable.key", ftypes.STRING)
es_set_variable.fields.value = ProtoField.new("Value", "es_set_variable.value", ftypes.STRING)

function es_set_variable.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_set_variable, buffer(), "Set variable")

	offset, key = readUntilTab(buffer, 0)
	subtree:add(es_set_variable.fields.key, key)

	offset, value = readUntilTab(buffer, offset)
	subtree:add(es_set_variable.fields.value, value)

	pinfo.cols.info = "event-service: Set " .. key:string() .. " => " .. value:string()
end

---------------------------------------------------------------------------
-- Network request (237)

es_network_request = Proto("es_network_request", "Netowrk request")
es_network_request.fields.url = ProtoField.new("URL", "es_network_request.url", ftypes.STRING)
es_network_request.fields.payload_size = ProtoField.new("Payload size", "es_network_request.payload_size", ftypes.STRING)

function es_network_request.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_network_request, buffer(), "Netowrk request")

	offset, url = readUntilTab(buffer, 0)
	subtree:add(es_network_request.fields.url, url)

	offset, payload_size = readUntilTab(buffer, offset)
	subtree:add(es_network_request.fields.payload_size, payload_size)

	pinfo.cols.info = "event-service: Network request (" .. url:string() .. ")"

	-- Not complete --
end

---------------------------------------------------------------------------
-- Track transition event (12)

es_track_trans = Proto("es_track_trans", "Track transition")
es_track_trans.fields.incremental = ProtoField.new("An incremental value", "es_track_trans.incremental", ftypes.STRING)
es_track_trans.fields.device_id = ProtoField.new("Device ID", "es_track_trans.device_id", ftypes.STRING)
es_track_trans.fields.playback_id = ProtoField.new("Playback ID", "es_track_trans.playback_id", ftypes.STRING)
es_track_trans.fields.parent_playback_id = ProtoField.new("Parent playback ID", "es_track_trans.parent_playback_id", ftypes.STRING)
es_track_trans.fields.where_1 = ProtoField.new("Where 1", "es_track_trans.where_1", ftypes.STRING)
es_track_trans.fields.how_1 = ProtoField.new("How 1", "es_track_trans.how_1", ftypes.STRING)
es_track_trans.fields.where_2 = ProtoField.new("Where 2", "es_track_trans.where_2", ftypes.STRING)
es_track_trans.fields.how_2 = ProtoField.new("How 2", "es_track_trans.how_2", ftypes.STRING)
es_track_trans.fields.context_1 = ProtoField.new("This says context", "es_track_trans.context_1", ftypes.STRING)
es_track_trans.fields.one_hundred_sixty_thousand = ProtoField.new("This says 160000", "es_track_trans.one_hundred_sixty_thousand", ftypes.STRING)
es_track_trans.fields.context_uri = ProtoField.new("Context URI", "es_track_trans.context_uri", ftypes.STRING)
es_track_trans.fields.encoding = ProtoField.new("Audio encoding", "es_track_trans.encoding", ftypes.STRING)
es_track_trans.fields.track_id = ProtoField.new("Track ID", "es_track_trans.track_id", ftypes.STRING)
es_track_trans.fields.parent_track_id = ProtoField.new("Parent track ID", "es_track_trans.parent_track_id", ftypes.STRING)
es_track_trans.fields.timestamp = ProtoField.new("Timestamp", "es_track_trans.timestamp", ftypes.STRING)
es_track_trans.fields.context_2 = ProtoField.new("This says context", "es_track_trans.context_2", ftypes.STRING)
es_track_trans.fields.origin = ProtoField.new("Playback origin ??", "es_track_trans.origin", ftypes.STRING)
es_track_trans.fields.version = ProtoField.new("Client version", "es_track_trans.version", ftypes.STRING)
es_track_trans.fields.com_dot_spotify = ProtoField.new("This says com.spotify", "es_track_trans.com_dot_spotify", ftypes.STRING)
es_track_trans.fields.duration = ProtoField.new("Track duration", "es_track_trans.duration", ftypes.STRING)
es_track_trans.fields.when_1 = ProtoField.new("When 1", "es_track_trans.when_1", ftypes.STRING)
es_track_trans.fields.when_2 = ProtoField.new("When 2", "es_track_trans.when_2", ftypes.STRING)
es_track_trans.fields.when_3 = ProtoField.new("When 3", "es_track_trans.when_3", ftypes.STRING)
es_track_trans.fields.when_4 = ProtoField.new("When 4", "es_track_trans.when_4", ftypes.STRING)
es_track_trans.fields.started_at = ProtoField.new("Started at", "es_track_trans.started_at", ftypes.STRING)
es_track_trans.fields.bit_flag_1 = ProtoField.new("Bit flag 1", "es_track_trans.bit_flag_1", ftypes.STRING)
es_track_trans.fields.bit_flag_2 = ProtoField.new("Bit flag 2", "es_track_trans.bit_flag_2", ftypes.STRING)
es_track_trans.fields.bit_flag_3 = ProtoField.new("Bit flag 3", "es_track_trans.bit_flag_3", ftypes.STRING)
es_track_trans.fields.bit_flag_4 = ProtoField.new("Bit flag 4", "es_track_trans.bit_flag_4", ftypes.STRING)


function es_track_trans.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_track_trans, buffer(), "Track transition")

	offset, incremental = readUntilTab(buffer, 0)
	subtree:add(es_track_trans.fields.incremental, incremental)

	offset, device_id = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.device_id, device_id)

	offset, playback_id = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.playback_id, playback_id)

	offset, parent_playback_id = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.parent_playback_id, parent_playback_id)

	offset, where_1 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.where_1, where_1)

	offset, how_1 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.how_1, how_1)

	offset, where_2 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.where_2, where_2)

	offset, how_2 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.how_2, how_2)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, when_1 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.when_1, when_1)

	offset, when_2 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.when_2, when_2)

	offset, duration = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.duration, duration)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, started_at = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.started_at, started_at)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, context_1 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.context_1, context_1)

	offset, scrap = readUntilTab(buffer, offset)

	offset, bit_flag_1 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.bit_flag_1, bit_flag_1)

	offset, bit_flag_2 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.bit_flag_2, bit_flag_2)

	offset, bit_flag_3 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.bit_flag_3, bit_flag_3)

	offset, scrap = readUntilTab(buffer, offset)

	offset, bit_flag_4 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.bit_flag_4, bit_flag_4)

	offset, when_3 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.when_3, when_3)

	offset, when_4 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.when_4, when_4)

	offset, scrap = readUntilTab(buffer, offset)

    offset, fixed_num = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.one_hundred_sixty_thousand, fixed_num)

 	offset, context_uri = readUntilTab(buffer, offset)
 	subtree:add(es_track_trans.fields.context_uri, context_uri)

 	offset, encoding = readUntilTab(buffer, offset)
 	subtree:add(es_track_trans.fields.encoding, encoding)

 	offset, track_id = readUntilTab(buffer, offset)
 	subtree:add(es_track_trans.fields.track_id, track_id)

 	offset, parent_track_id = readUntilTab(buffer, offset)
 	subtree:add(es_track_trans.fields.parent_track_id, parent_track_id)

 	offset, scrap = readUntilTab(buffer, offset)

 	offset, ts = readUntilTab(buffer, offset)
 	subtree:add(es_track_trans.fields.timestamp, ts)

 	offset, scrap = readUntilTab(buffer, offset)

 	offset, context_2 = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.context_2, context_2)

	offset, origin = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.origin, origin)

	offset, version = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.version, version)

	offset, com_dot_spotify = readUntilTab(buffer, offset)
	subtree:add(es_track_trans.fields.com_dot_spotify, com_dot_spotify)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	pinfo.cols.info = "event-service: Track transition"
end

---------------------------------------------------------------------------
-- CDN request (10)

es_cdn_request = Proto("es_cdn_request", "CDN request")
es_cdn_request.fields.file_id = ProtoField.new("File ID", "es_cdn_request.file_id", ftypes.STRING)
es_cdn_request.fields.playback_id = ProtoField.new("Playback ID", "es_cdn_request.playback_id", ftypes.STRING)
es_cdn_request.fields.music = ProtoField.new("This says music", "es_cdn_request.music", ftypes.STRING)
es_cdn_request.fields.scheme = ProtoField.new("Scheme", "es_cdn_request.scheme", ftypes.STRING)
es_cdn_request.fields.host = ProtoField.new("Host", "es_cdn_request.host", ftypes.STRING)
es_cdn_request.fields.unknown = ProtoField.new("This says unknown", "es_cdn_request.unknown", ftypes.STRING)
es_cdn_request.fields.storage_resolve = ProtoField.new("Storege resolve strategy", "es_cdn_request.storage_resolve", ftypes.STRING)
es_cdn_request.fields.one_hundred_sixty_thousand = ProtoField.new("This says 160000", "es_cdn_request.one_hundred_sixty_thousand", ftypes.STRING)
es_cdn_request.fields.total_length_1 = ProtoField.new("Total length 1", "es_cdn_request.total_length_1", ftypes.STRING)
es_cdn_request.fields.total_length_2 = ProtoField.new("Total length 2", "es_cdn_request.total_length_2", ftypes.STRING)
es_cdn_request.fields.total_length_3 = ProtoField.new("Total length 3", "es_cdn_request.total_length_3", ftypes.STRING)


function es_cdn_request.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_cdn_request, buffer(), "CDN request")

	offset, file_id = readUntilTab(buffer, 0)
	subtree:add(es_cdn_request.fields.file_id, file_id)

	offset, playback_id = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.playback_id, playback_id)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, total_length_1 = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.total_length_1, total_length_1)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, total_length_2 = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.total_length_2, total_length_2)

	offset, music = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.music, music)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, scheme = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.scheme, scheme)

	offset, host = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.host, host)

	offset, unknown = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.unknown, unknown)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	offset, total_length_3 = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.total_length_3, total_length_3)

	offset, storage_resolve = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.storage_resolve, storage_resolve)

	offset, scrap = readUntilTab(buffer, offset)

	offset, fixed_num = readUntilTab(buffer, offset)
	subtree:add(es_cdn_request.fields.one_hundred_sixty_thousand, fixed_num)

	offset, scrap = readUntilTab(buffer, offset)
	offset, scrap = readUntilTab(buffer, offset)

	pinfo.cols.info = "event-service: CDN request (" .. file_id:string() .. " for " .. playback_id:string() .. ")"
end


---------------------------------------------------------------------------
-- AppFocusState

es_app_focus_state = Proto("es_app_focus_state", "AppFocusState")
es_app_focus_state.fields.state = ProtoField.new("State", "es_app_focus_state.state", ftypes.STRING)
es_app_focus_state.fields.when = ProtoField.new("When", "es_app_focus_state.when", ftypes.STRING)

function es_app_focus_state.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_app_focus_state, buffer(), "AppFocusState")

	offset, state = readUntilTab(buffer, 0)
	subtree:add(es_app_focus_state.fields.state, state)

	offset, when = readUntilTab(buffer, offset)
	subtree:add(es_app_focus_state.fields.when, when)

	pinfo.cols.info = "event-service: AppFocusState => " .. state:string()
end

---------------------------------------------------------------------------
-- Interaction

es_interaction = Proto("es_interaction", "Interaction")
es_interaction.fields.id = ProtoField.new("State", "es_interaction.id", ftypes.STRING)

function es_interaction.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_interaction, buffer(), "Interaction")

	offset, key = readUntilTab(buffer, 0)
	offset, id = readUntilTab(buffer, offset)
	subtree:add(es_interaction.fields.id, id)

	pinfo.cols.info = "event-service: Interaction => " .. id:string()

	-- Not complete --
end

---------------------------------------------------------------------------
-- UIInteraction

es_ui_interaction = Proto("es_ui_interaction", "UIInteraction")
function es_ui_interaction.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_ui_interaction, buffer(), "UIInteraction")
	pinfo.cols.info = "event-service: UIInteraction"

	-- Not complete --
end

---------------------------------------------------------------------------
-- UIImpression

es_ui_impression = Proto("es_ui_impression", "UIImpression")
function es_ui_impression.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_ui_impression, buffer(), "UIImpression")
	pinfo.cols.info = "event-service: UIImpression"

	-- Not complete --
end

---------------------------------------------------------------------------
-- AdControlEvent

es_ad_control_event = Proto("es_ad_control_event", "AdControlEvent")
function es_ad_control_event.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_ad_control_event, buffer(), "AdControlEvent")
	pinfo.cols.info = "event-service: AdControlEvent"

	-- Not complete --
end

---------------------------------------------------------------------------
-- PageView

es_page_view = Proto("es_page_view", "PageView")
function es_page_view.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_page_view, buffer(), "PageView")
	pinfo.cols.info = "event-service: PageView"

	-- Not complete --
end

---------------------------------------------------------------------------

local event_service_dt = DissectorTable.new ("event_service.op", "Operation", ftypes.STRING)
event_service_dt:add("10", es_cdn_request)
event_service_dt:add("12", es_track_trans)
event_service_dt:add("237", es_network_request)
event_service_dt:add("268", es_set_variable)
event_service_dt:add("274", es_fetched_file_id)
event_service_dt:add("372", es_track_played)
event_service_dt:add("557", es_report_session_id)
event_service_dt:add("558", es_report_playback_id)
event_service_dt:add("AppFocusState", es_app_focus_state)
event_service_dt:add("Interaction", es_interaction)
event_service_dt:add("UIInteraction", es_ui_interaction)
event_service_dt:add("UIImpression", es_ui_impression)
event_service_dt:add("AdControlEvent", es_ad_control_event)
event_service_dt:add("PageView", es_page_view)


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

	diss = event_service_dt:try(op:string(), buffer:range(offset):tvb(), pinfo, subtree)
end
