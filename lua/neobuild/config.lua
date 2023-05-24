local config = {}

config.defaults = {
  adapters = {},
  notifications = {
    enabled = true,
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
  },
}

config.ns = vim.api.nvim_create_namespace("neobuild")

setmetatable(config, { __index = config.defaults })

return config
