local function a(b, c)
    local d = file.open(b, "w") and c
    if d then
        file.write(c)
        file.close()
    end
    return d
end
local function e(f)
    local g = f.login == _s.login and f.pass == _s.pass
    return g and _s.token
end
local function h(i)
    status, result = pcall(sjson.encode, i)
    a("get_network.json", result)
end
local function j()
    tmr.create():alarm(
        2000,
        tmr.ALARM_SINGLE,
        function()
            print("reboot")
            node.restart()
        end
    )
    return true
end
return function(k)
    local d
    if k.scan then
        d = true
        wifi.sta.getap(h)
    end
    if k.auth then d = e(k.auth) end
    if k.reboot then d = j() end
    return d
end
