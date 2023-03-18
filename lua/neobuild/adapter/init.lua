local adapter = {
  modules = {
    require("neobuild.adapter.cmake"),
  }
}

function adapter.ls(path, fn)
  -- Borrowed from https://github.com/folke/lazy.nvim
  local handle = vim.loop.fs_scandir(path)
  while handle do
    local name, t = vim.loop.fs_scandir_next(handle)

    if not name then
      break
    end

    local fname = path .. "/" .. name

    -- HACK: type is not always returned due to a bug in luv,
    -- so fecth it with fs_stat instead when needed.
    -- see https://github.com/folke/lazy.nvim/issues/306
    if fn(fname, name, t or vim.loop.fs_stat(fname).type) == false then
      break
    end
  end
end

function adapter.match()
  local match = {}
  local ls = {}

  adapter.ls(vim.loop.cwd(), function(_, name, _)
      ls[#ls + 1] = name
  end)

  for _, mod in pairs(adapter.modules) do
    for _, entry in pairs(mod.root()) do
      if vim.tbl_contains(ls, entry) then
        match[#match+1] = mod
      end
    end
  end

  return match
end

return adapter
