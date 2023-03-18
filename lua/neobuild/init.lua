local neobuild = {}

local adapter = require("neobuild.adapter")
local config = require("neobuild.config")
local runner = require("neobuild.runner")

function neobuild.setup(user_config)
  setmetatable(config, {
    __index = vim.tbl_deep_extend("force", config.defaults, user_config),
  })
end

function neobuild.build()
  -- TODO
  --if runner.is_running() then
  --  vim.notify(string.format('Build already running: "%s"', runner.name()), vim.log.levels.ERROR)
  --  return
  --end

  if config.save_before_run then
    vim.api.nvim_command("silent! wall")
  end

  local builders = adapter.match()

  if vim.tbl_isempty(builders) then
    vim.notify(string.format('Unable to find compatible builder'), vim.log.levels.ERROR, { title = "Neobuild" })
    return
  end

  -- Use first 'best' match
  local builder = builders[1]
  -- TODO Should run sequentially
  runner.run(builder.configure_spec())
  runner.run(builder.build_spec())
end

--function neobuild.configure(builder)
--end

--function neobuild.cancel()
--  if not runner.cancel() then
--    vim.notify("No running process")
--  end
--end

return neobuild
