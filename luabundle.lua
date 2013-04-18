#!/usr/bin/env lua

local scripts = {}

for _,filename in ipairs(arg) do
    file, err = io.open(filename, "r")
    if not file then
        io.stderr:write("Couldn't open " .. filename .. ": " .. err .. "\n")
        os.exit(1)
    end

    -- Skip the first line if it's a hashbang
    local firstline = file:read("*l") .. "\n"
    if string.sub(firstline, 1, 2) == "#!" then firstline = "" end

    scripts[filename] = firstline .. file:read("*a")
    file:close()
end

print([[
function __require(moduleName)
    return __modules[moduleName](__require)
end

local __modules = {
]])

for k,v in pairs(scripts) do
    print("['" .. k .. "'] = function(require)\n")
    print(v)
    print("\nend,\n")
end

print("}\n")
if #arg >= 1 then
    print("__modules['" .. arg[1] .. "'](__require)")
end
