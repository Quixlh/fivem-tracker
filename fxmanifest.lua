shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"
game "gta5"
lua54 "yes"

shared_scripts {
    "@es_extended/imports.lua",
    "clientloader.lua",
    "config.lua"
}

server_script "server/server.lua"