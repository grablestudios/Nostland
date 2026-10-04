-- Plugin sandbox: compiles a plugin's code inside a restricted environment
-- (whitelist). os, io, require, load, dofile, debug, etc. do not exist.
--
-- Receives (code, chunkname, api, log). Returns (function, environment) on success
-- or (nil, error_message) if the code has a syntax error.
return function(code, chunkname, api, log)
    local function safe_print(...)
        local parts = {}
        for i = 1, select('#', ...) do
            parts[#parts + 1] = tostring((select(i, ...)))
        end
        log(table.concat(parts, '\t'))
    end

    local env = {
        assert = assert, error = error, ipairs = ipairs, next = next,
        pairs = pairs, pcall = pcall, select = select, tonumber = tonumber,
        tostring = tostring, type = type, unpack = table.unpack, xpcall = xpcall,
        math = math, string = string, table = table,
        print = safe_print,
        Game = api,
        Player = api.Player,
    }
    env._G = env

    local fn, err = load(code, chunkname, 't', env)
    if not fn then return nil, err end
    return fn, env
end
