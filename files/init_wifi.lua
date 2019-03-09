return function(a)
    local b = {}
    b.ssid = a.ssid
    _mode = a.mode
    b.pwd = string.len(a.pwd) >= 8 and a.pwd or nil
    if a.mode ~= 0 then
        wifi.setmode(a.mode)
        wifi.nullmodesleep(false)
        if a.mode == 1 then
            wifi.sta.config(b)
        else
            wifi.ap.config(b)
        end
        wifi.eventmon.register(
            a.mode == 1 and 0 or 5,
            function(c)
                dofile('web.lua')
                local d = tmr.create()
                d:register(
                    5000,
                    tmr.ALARM_SINGLE,
                    function(a)
                        dofile("init_settings.lua")({run = {ext = "net"}})
                        print(_s.mode == 1 and wifi.sta.getip() or wifi.ap.getip())
                        a:unregister()
                    end
                )
                d:start()
            end
        )
    else
        print("Wireless err")
    end
end
