local scan = require("plenary.scandir")

local adapter = {
  modules = {
    require("neobuild.adapter.cmake"),
    require("neobuild.adapter.bitbake"),
  },
}

-- TODO: Move to library
function adapter.ls(path)
  local results = {}

  scan.scan_dir(path, {
    hidden = true,
    depth = 1,
    add_dirs = true,
    on_insert = function(entry)
      results[#results+1] = vim.fs.basename(entry)
    end,
  })

  return results
end

function adapter.discover()
  local match = {}
  local root_patterns = adapter.ls(vim.loop.cwd())

  for _, mod in pairs(adapter.modules) do
    local contains_pattern = false

    for _, entry in pairs(mod.root()) do
      if vim.tbl_contains(root_patterns, entry) then
        contains_pattern = true
        break
      end
    end

    if contains_pattern then
      match[#match + 1] = mod
    end
  end

  return match
end

return adapter
