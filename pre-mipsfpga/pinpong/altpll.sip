set_global_assignment -entity "altpll" -library "lib_altpll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "altpll" -library "lib_altpll" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "altpll" -library "lib_altpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_altpll" -name SPD_FILE [file join $::quartus(sip_path) "altpll.spd"]
