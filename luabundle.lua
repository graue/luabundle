#!/usr/bin/env lua

local scripts = {}

local function mungeFilename(name)
    -- Convert something like "effects/wrap.lua" to "effects.wrap"
    name = string.gsub(name, "%.[Ll][Uu][Aa][Xx]?$", "")
    name = string.gsub(name, "/", ".")
    return name
end

for _,filename in ipairs(arg) do
    file, err = io.open(filename, "r")
    if not file then
        io.stderr:write("Couldn't open " .. filename .. ": " .. err .. "\n")
        os.exit(1)
    end

    -- Skip the first line if it's a hashbang
    local firstline = file:read("*l") .. "\n"
    if string.sub(firstline, 1, 2) == "#!" then firstline = "" end

    scripts[mungeFilename(filename)] = firstline .. file:read("*a")
    file:close()
end

print("local __modules = {\n")

for k,v in pairs(scripts) do
    print("['" .. k .. "'] = function(require)\n")
    print(v)
    print("\nend,\n")
end

print("}\n")

print([[
function __require(moduleName)
    local module = __modules[moduleName]
    if module then
        return module(__require)
    end

    -- Not found in the bundle; try the original require.
    return require(moduleName)
end
]])

if #arg >= 1 then
    print("__modules['" .. mungeFilename(arg[1]) .. "'](__require)")
end
