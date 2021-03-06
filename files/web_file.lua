local a = {
    txt = "text/plain",
    js = "application/javascript",
    json = "application/json",
    ico = "image/x-icon",
    lua = "text/html",
    css = "text/css",
    html = "text/html",
    jpeg = "image/jpeg",
    jpg = "image/jpeg"
}
local function b(c)
    local d, e
    if type(c) == "table" then
        d, e = pcall(sjson.encode, c)
    else
        e = tostring(c)
    end
    return e
end
local f = "web_control.luastyle.css.gzlogin.html"
local function g(h, i)
    for j in h:gmatch(i) do
        local d, k = pcall(loadstring(j))
        h = h:gsub(i, tostring(k == nil and "" or k), 1)
    end
    return h
end
local function l(m, n, o)
    local b = "HTTP/1.0 " .. m .. "\r\nServer: web-server\r\nContent-Type: " .. n .. "\r\n"
    if o then
        b = b .. "Cache-Control: private, max-age=2592000\r\nContent-Encoding: gzip\r\n"
    end
    b = b .. "Connection: close\r\n\r\n"
    return b
end
return function(p, q)
    local r, s, t = q.file, q.args, q.cookie
    local u, v, w = r:match(".gz"), r:gsub(".gz", ""):match("%.([%a%d]+)$")
    if not _s.auth then
        if not t or t.id ~= _s.token then r = f:match(v == "html" and "login.html" or r) or "" end
    end
    local x = file.open(r, "r")
    if x then
        p:send(l("200 OK", a[v] or "text/plain", u))
    else
        p:send(l("404 Not Found", "text/html"))
        p:send("<h1>Page not found</h1>")
        return
    end
    if v == "html" and not s.fget then
        local buffer = ""
        repeat
            w = x:readline()
            if w then
                if w:find("<%?lua(.-)%?>") then
                    buffer = buffer .. g(w, "<%?lua(.-)%?>")
                else
                    buffer = buffer .. w
                end
            end
            if buffer:len() > 1024 or not w then
                p:send(buffer)
                if w then coroutine.yield() end
                buffer = ""
            end
        until not w
        x:close()
        x = nil
    elseif v == "lua" and not s.fget then
        local d, e = pcall(dofile(r), s)
        p:send(b(e))
    else
        local y = 0
        local all = file.open(r, "r")
        repeat
            all:seek("set", y)
            w = all:read(1024)
            if w then
                p:send(w)
                y = y + 1024
                if w:len() == 1024 then coroutine.yield() end
            end
        until not w
        all:close()
    end
    all, w, u, v, buffer = nil
end
