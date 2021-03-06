-- Add this file to <cmder_root>/config/tilde.lua
-- or to clink profile, where settings file is

local function tilde_match (text, f, l)
    home = clink.get_env('home')
    if not home then
        home = clink.get_env('USERPROFILE')
    end
    if text == '~' then
        clink.add_match(home)
        clink.matches_are_files()
        return true
    end
    if text:sub(1, 1) == '~' then
        clink.add_match(string.gsub(text, "~", home, 1))
        -- second match prevents adding a space so we can look for more matches
        clink.add_match(string.gsub(text, "~", home, 1) .. '+')
        clink.matches_are_files()
        return true
    end
end

clink.register_match_generator(tilde_match, 1)
