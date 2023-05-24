local Job = require("plenary.job")
local Popup = require("plenary.popup")
local runner = {}

-- TODO: Make class?

-- Default runner options
-- @type Config
--runner.opts = {
--  ignore_stdout = false,
--  ignore_stderr = false,
--  quickfix = {
--    output = true,
--    position = "bottom",
--    height = 12,
--  },
--}

-- Create and register a new runner job
-- TODO: Make class runner -- .run schedules jobs if one already running
function runner.run(builder)
  local default_opts = {
    cwd = vim.loop.cwd(),
    on_start = vim.schedule_wrap(function()
      -- vim.fn.setqflist({}, " ", { title = builder.name })
      -- vim.api.nvim_command(string.format("%s copen %d", "botright", 15))
      -- vim.api.nvim_command("wincmd p")
    end),
    on_stdout = vim.schedule_wrap(function(_, data, _)
      -- vim.fn.setqflist({}, "a", { lines = { data } })
    end),
    on_stderr = vim.schedule_wrap(function(_, data, _)
      -- vim.fn.setqflist({}, "a", { lines = { data } })
    end),
    on_exit = function(me, code, signal)
      vim.notify(
        string.format("Command `%s %s` exited with code %s", me.command, table.concat(me.args, " "), (signal == 0 and code or 128 + signal)),
        code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR,
        {
          title = builder.name,
        }
      )
    end,
  }

  local opts = vim.tbl_deep_extend("force", {}, default_opts, builder.commands[1])
  local job = Job:new(opts)

  if #builder.commands ~= 1 then
    builder.commands = vim.list_slice(builder.commands, 2, 2)
    job:after_success(vim.schedule_wrap(function()
      runner.run(builder)
    end))
  end

  job:start()
  vim.notify(vim.inspect(job))
end


return runner
