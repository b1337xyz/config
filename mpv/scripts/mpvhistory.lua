local HISTFILE = os.getenv('HOME')..'/.cache/mpv/mpvhistory.log';

mp.register_event('file-loaded', function()
    local logfile;

    logfile = io.open(HISTFILE, 'a+');
    logfile:write(('[%s] %s\n'):format(os.date('%y.%m.%d %H:%M'), mp.get_property('path')));    
    logfile:close();
end)
