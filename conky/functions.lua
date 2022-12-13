function conky_rjust(n, s)
    s = conky_parse(s)
    return string.format('%' .. n .. 's', s)
end
function conky_ljust(n, s)
    s = conky_parse(s)
    return string.format('%-' .. n .. 's' , s)
end
