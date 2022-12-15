function conky_rjust(n, s)
    local s = conky_parse(s)
    return string.format('%' .. n .. 's', s)
end
function conky_ljust(n, s)
    local s = conky_parse(s)
    return string.format('%-' .. n .. 's' , s)
end
function conky_power_draw()
    local f = io.open("/sys/class/power_supply/BAT0/power_now", "r")
    local v = tonumber(f:read())
    f:close()
    return string.format("%.2f W", v * 10^-6)
end
