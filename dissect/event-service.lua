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
-- Report playback ID (558)

es_report_playback_id = Proto("es_report_playback_id", "Report playback ID")
es_report_playback_id.fields.playback_id = ProtoField.new("Playback ID", "es_report_playback_id.playback_id", ftypes.STRING)
es_report_playback_id.fields.session_id = ProtoField.new("Session ID", "es_report_playback_id.track_uri", ftypes.STRING)
es_report_playback_id.fields.timestamp = ProtoField.new("Timestamp", "es_report_playback_id.timestamp", ftypes.STRING)

function es_report_playback_id.dissector(buffer, pinfo, tree) 
	local subtree = tree:add (es_report_playback_id, buffer(), "Report playback ID")

	offset, playback_id = readUntilTab(buffer, 0)
	subtree:add(es_report_playback_id.fields.playback_id, playback_id)

	offset, session_id = readUntilTab(buffer, offset)
	subtree:add(es_report_playback_id.fields.session_id, session_id)

	offset, ts = readUntilTab(buffer, offset)
	subtree:add(es_report_playback_id.fields.timestamp, ts)

	pinfo.cols.info = "event-service: Playback ID"
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
event_service_dt:add("372", es_track_played)
event_service_dt:add("558", es_report_playback_id)
event_service_dt:add("268", es_set_variable)
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
