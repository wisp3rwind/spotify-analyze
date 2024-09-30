spotify = Proto("spotify", "Spotify")

local spotify_dt = DissectorTable.new ("spotify.cmd", "Spotify")

local f = spotify.fields
f.direction = ProtoField.uint8("spotify.direction", "Direction")
f.cmd = ProtoField.uint8("spotify.cmd", "Command", base.HEX)
f.length = ProtoField.uint32("spotify.length", "Length")

function spotify.dissector(buffer, pinfo, tree)
    local subtree = tree:add (spotify, buffer(), "Spotify")
    pinfo.cols.protocol = "Spotify"

    local direction = buffer(0, 1)
    local cmd = buffer(1, 1)
    local length = buffer(2, 2)
    local payload = buffer(4):tvb()

    if direction:uint() == 0 then
        pinfo.cols.src = "Client"
        pinfo.cols.dst = "Server"
    else
        pinfo.cols.src = "Server"
        pinfo.cols.dst = "Client"
    end

    subtree:add(f.direction, direction)
    subtree:add(f.cmd, cmd)
    subtree:add(f.length, length)

    if false then
    elseif cmd:uint() == 0x02 then
        pinfo.cols.info = "SecretBlock"
    elseif cmd:uint() == 0x04 then
        pinfo.cols.info = "Ping: " .. payload(0, 4):uint()
    elseif cmd:uint() == 0x08 then
        pinfo.cols.info = "StreamChunk"
    elseif cmd:uint() == 0x09 then
        pinfo.cols.info = "StreamChunkRes"
    elseif cmd:uint() == 0x0a then
        pinfo.cols.info = "ChannelError"
    elseif cmd:uint() == 0x0b then
        pinfo.cols.info = "ChannelAbort"
    elseif cmd:uint() == 0x0c then
        pinfo.cols.info = "RequestKey: " .. payload()
    elseif cmd:uint() == 0x0d then
        pinfo.cols.info = "AesKey: " .. payload()
    elseif cmd:uint() == 0x0e then
        pinfo.cols.info = "AesKeyError"
    elseif cmd:uint() == 0x19 then
        pinfo.cols.info = "Image"
    elseif cmd:uint() == 0x1b then
        pinfo.cols.info = "CountryCode: " .. payload()
    elseif cmd:uint() == 0x49 then
        pinfo.cols.info = "Pong"
    elseif cmd:uint() == 0x4a then
        pinfo.cols.info = "PongAck"
    elseif cmd:uint() == 0x4b then
        pinfo.cols.info = "Pause"
    -- elseif cmd:uint() == 0x50 then
    --     pinfo.cols.info = "ProductInfo"
    elseif cmd:uint() == 0x69 then
        pinfo.cols.info = "LegacyWelcome"
    elseif cmd:uint() == 0x76 then
        pinfo.cols.info = "LicenseVersion"
    elseif cmd:uint() == 0xab then
        DissectorTable.get("protobuf"):try("ClientResponseEncrypted", payload, pinfo, tree)
        pinfo.cols.info = "Login"
    elseif cmd:uint() == 0xac then
        DissectorTable.get("protobuf"):try("APWelcome", payload, pinfo, tree)
        pinfo.cols.info = "APWelcome"
    elseif cmd:uint() == 0xad then
        DissectorTable.get("protobuf"):try("APLoginFailed", payload, pinfo, tree)
        pinfo.cols.info = "APLoginFailed"
    else
        DissectorTable.get("spotify.cmd"):try(cmd:uint(), payload, pinfo, tree)
    end
end

DissectorTable.get("wtap_encap"):add(wtap.USER0, spotify)

spotify_dt:add(0x50, Dissector.get("xml"))
