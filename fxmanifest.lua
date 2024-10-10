fx_version 'adamant'
game 'gta5'

lua54 'yes'
shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}
server_script {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
}
client_script {
	'config.lua',
    'client/*.lua'
}
				

