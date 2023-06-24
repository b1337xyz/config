function conky_rjust(n, s)
    local s = conky_parse(s)
    return string.format('%' .. n .. 's', s)
end
function conky_ljust(n, s)
    local s = conky_parse(s)
    return string.format('%-' .. n .. 's' , s)
end
-- function conky_power_draw()
--     local f = io.open("/sys/class/power_supply/BAT0/power_now", "r")
--     local v = tonumber(f:read())
--     f:close()
--     return string.format("%.2f W", v * 10^-6)
-- end
-- function file_exists(name)
--    local f=io.open(name, "r")
--    if f ~= nil then io.close(f) return true else return false end
-- end
-- function conky_cover_art()
--     because conky can't handle white spaces
--     local file = conky_parse("${mpd_file}")
--     local music_dir = os.getenv('HOME') .. "/Music"
--     local cache = os.getenv('HOME') .. '/.cache/thumbnails/mpc'
--     local image = cache .. music_dir .. "/" .. file .. ".jpg"
--     local dst = '/tmp/conky.mpd.jpg'
--     if file_exists(image) then
--         os.execute('cp "' .. image .. '" ' .. dst)
--     else
--         os.execute('rm ' .. dst)
--     end
--     return string.format("${image %s -p 0,0 -s 260x260 -n}", dst)
-- end
