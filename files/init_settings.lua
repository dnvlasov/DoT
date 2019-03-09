local a = {
    ssid = "DoT-" .. string.format("%x", node.chipid() * 256):sub(0, 6):upper(),
    pwd = "",
    auth = false,
    mode = 3,
    login = "admin",
    pass = "0000"
}
local function b(c, d)
    local e, f = pcall(sjson.encode, d)
    if f and file.open(c, "w") then
        file.write(f)
        file.close()
    end
end
local function g(h)
    local i, f
    if file.open(h, "r") then
        i, f = pcall(sjson.decode, file.read())
        file.close()
    end
    return f
end
local function j(k)
    local l, m = k == 1 and g("setting.json")
    m = l or a
    if not settings then b("setting.json", m) end
    m.token = tostring(node.random(100000))
    return m
end
local function n(o)
    local h, p
    for q, r in pairs(file.list()) do
        if q:match(o.ext and "(.*)%." .. o.ext or o.name .. "%.[rn][ue][nt]$") then
            h = g(q:match("(.*)%.") .. ".init")
            if q and h then
                h.run = o.name and true or h.run
                h, p = pcall(dofile(q), h)
            end
        end
    end
    return p
end
local function s(o)
    if type(o) == "table" then
        for t, r in pairs(o) do file.remove(r) end
    else
        file.remove(o)
    end
    return o
end
local function u(o)
    local v = g(o.Fname)
    if v then
        for w, k in pairs(v) do v[w] = o[w] == nil and k or o[w] end
        b(o.Fname, v)
        return true
    end
    return false
end
return function(o)
    local x
    if type(o) == "table" then
        if o.run then x = n(o.run) end
        if o.list then x = file.list() end
        if o.init then x = g(o.init) end
        if o.save then x = u(o.save) end
        if o.del then x = s(o.del) end
        if o.def then x = j(o.def) end
    end
    return x
end
