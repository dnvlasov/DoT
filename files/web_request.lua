local function a(b) return string.char(tonumber(b, 16)) end
local function c(d) return d:gsub("%+", " "):gsub("%%(%x%x)", a) end
local function e(string, f, g)
    local h = {}
    if string and string ~= "" then
        for i in string:gmatch(f) do
            local j, k = i:match("(.*)=(.*)")
            h[j] = not g and c(k) or k
        end
    end
    return h
end
local function l(m)
    local n = {}
    local o = m:match("Content%-Type: ([%w/-]+)")
    local p = m:sub(m:find("\r\n\r\n", 1, true), #m)
    print(p)
    m = nil
    collectgarbage()
    if o == "application/json" then
        local q, r = pcall(sjson.decode, p)
        n = r or {}
    elseif o == "application/x-www-form-urlencoded" then
        n = e(p, "%s*&?([^=]+=[^&]*)")
    end
    return n
end
return function(s)
    local t = {}
    t.method, t.req = s:match("(.-)\r\n"):match("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
    if t.method and t.req then
        t.cookie = e(
            s:match("%cCookie: (%C*)"),
            ";?%s?([^=]+=[^;]*)",
            true
        )
        t.file = t.req:match("?") and t.req:match("/(.*)%?") or t.req:match("/(.*)")
        t.file = t.file == "" and "index.html" or t.file
        t.args = t.method == "GET" and e(t.req:match("%?([^=]+=[^;]*)"), "([^&]+)") or l(s)
    else
        t = nil
    end
    return t
end
