local config = {
  defaults = {
    default_params = {
      cmake = {
        cmd = 'cmake',
        build_dir = 'build',
        build_type = 'Debug',
        args = {
          configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
        },
      },
    },
    quickfix = {
      pos = 'botright',
      height = 12,
      only_on_error = false,
    },
  },
}

setmetatable(config, { __index = config.defaults })

return config
