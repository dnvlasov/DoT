local a = ""
local function b(c, d)
    local e, f
    local g = net.createConnection(net.TCP, 0)
    g:on(
        "receive",
        function(g, h)
            if not e then
                f = h:match("HTTP/%d%.%d (.-) .*\r\n") == "200"
                h = h:match("\r\n\r\n(.*)")
                e = true
                if c.save and f then file.open(c.file, "w+") end
            end
            if not f then
                d("Not found " .. c.file)
                return
            end
            if c.save then
                file.write(h)
                d("load... " .. c.file)
            else
                d(h)
            end
            payload = nil
            collectgarbage()
        end
    )
    g:on(
        "disconnection",
        function(g)
            file.close()
            d(false)
        end
    )
    g:on(
        "connection",
        function(g)
            g:send("GET /" .. c.path .. c.file .. " HTTP/1.0\r\n" .. "Host: " .. c.host .. "\r\n" .. "Connection: close\r\n" .. "Accept-Charset: utf-8\r\n" .. "Accept-Encoding: \r\n" .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" .. "Accept: */*\r\n\r\n")
        end
    )
    g:connect(c.port, c.host)
end
local function i(j)
    if j then
        if file.open("temp_get.txt", "a+") then
            file.write(j)
            file.close()
        end
    end
end
local function k(c, d)
    local l = c.file
    local m
    local function n(c)
        b(c, function(j)
            if j then
                a = a .. j .. '\n'
            else
                m()
            end
        end)
    end
    m = function()
        c.save = true
        if #l ~= 0 then
            c.file = l[#l]
            n(c)
            l[#l] = nil
        else
            d(a .. "close ")
            d(false)
        end
    end
    m()
end
return function(c, d)
    local o
    local function p(j)
        if d then
            d(j)
        else
            i(j)
            print(j)
        end
    end
    file.remove("temp_get.txt")
    if c.init == "upload" then
        b(
            c,
            function(q)
                if q then
                    local r, s = pcall(sjson.decode, q)
                    if r then
                        c.file = s
                        k(c, p)
                    else
                        p(false)
                    end
                end
            end
        )
        o = true
    else
        b(c, p)
        o = true
    end
    return o
end
