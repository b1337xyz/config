function toUpper(str)
    return (str:gsub("^%l", string.upper))
end

function conky_get_user()
    return toUpper(conky_parse('${uid_name 1000}'))
end

function conky_get_host()
    return toUpper(conky_parse('${nodename}'))
end

function conky_top(n)
    proc = conky_parse('${top name ' .. n .. '}') 
    usage = conky_parse('${top cpu ' .. n .. '}') 
    return string.format("%14s%%|${alignr}%s", usage, proc:gsub(" ", ""))
end

function conky_top_ram(n)
    proc = conky_parse('${top_mem name ' .. n .. '}') 
    usage = conky_parse('${top mem_res ' .. n .. '}') 
    return string.format("%15s| ${alignr}%s", usage, proc:gsub(" ", ""))
end

function conky_speed(dev)
    dlspeed = conky_parse('${downspeed ' .. dev .. '}')
    upspeed = conky_parse('${upspeed ' .. dev .. '}')
    return string.format("DL %10s | UP %10s", dlspeed, upspeed)
end

function conky_total_speed(dev)
    totaldown = conky_parse('${totaldown ' .. dev .. '}')
    totalup = conky_parse('${totalup ' .. dev .. '}')
    return string.format("DL %10s | UP %10s", totaldown, totalup)
end

function draw_bar(n, c)
    output = ""
    max = 23
    p = max * usage // 100
    for i=0, max do
        if i <= p then
            output = output .. "${color #ff00ff}/${color}"
        else
            output = output .. "${color #ffff00}/${color}"
        end
    end
    return output .. " " .. string.format("%6." .. c .. "f%%", usage)
end

function conky_get_cpu_usage(n) 
    total = 0
    for i=0, n do
        total = total + tonumber(conky_parse('${cpu cpu' .. n .. '}'))
    end
    usage = total / n
    return draw_bar(usage, 3)
end

function conky_get_ram_usage()
    usage = tonumber(conky_parse('${memperc}'))
    return draw_bar(usage, 3)
end

function conky_get_fs_usage(fs)
    usage = tonumber(conky_parse('${fs_used_perc ' .. fs ..'}'))
    return string.format("%-6s %s", fs, draw_bar(usage, 1))
end
