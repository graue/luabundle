# Luabundle

This program bundles together a series of Lua files for use in the
browser with an Emscripten-compiled Lua interpreter. A custom
`require` function is provided that loads the appropriate content from
the bundle, rather than trying to call out to the filesystem.

Example usage: `luabundle main.lua {src,lib}/*.lua`

This creates a bundle.lua file; running it causes similar results to
running main.lua.
