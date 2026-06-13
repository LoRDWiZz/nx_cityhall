fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'LoRD Cityhall System'

shared_scripts {
    '@ox_lib/init.lua',
    'sh_bridge.lua',
    'sh_config.lua',
}

client_scripts {
    'cl_main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_main.lua',
}

files {
    'web/dist/**',
}
ui_page 'web/dist/index.html'