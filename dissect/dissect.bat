@echo off
:: Run Wireshark on windows
"C:\Program Files\Wireshark\wireshark.exe" ^
    %1 ^
    -X lua_script:protobuf_dissector/protobuf.lua ^
    -X lua_script:spotify.lua ^
    -X lua_script:mercury.lua ^
    -X lua_script:gaia.lua ^
    -X lua_script1:proto/keyexchange.proto ^
    -X lua_script1:proto/authentication.proto ^
    -X lua_script1:proto/mercury.proto
