local Popup = require("nui.popup")
local Event = require("nui.utils.autocmd").event
local Text = require("nui.text")
local Line = require("nui.line")

-- TODO: Use nui object to create an object?

---@class NeobuildViewState
---@field mode string
local default_state = {
  mode = "info", -- "build", "log"
}

local M = {}
M.popup = nil
M._lines = {}

local commands = {
  quit = {
    key = "q",
    desc = "Close view",
    action = function()
      M.popup:unmount()
      M.is_mounted = false
    end,
  },
  home = {
    key = "H",
    desc = "Show build client view",
    action = function()
      M.show("home")
    end,
  },
  info = {
    key = "I",
    desc = "Show build info view",
    action = function()
      M.show("home")
    end,
  },
  build = {
    key = "B",
    desc = "Build current target",
    action = function()
      M.show("info")
      -- Manage.build()
    end,
  },
  configure = {
    key = "C",
    desc = "Configure build system",
    action = function()
      M.show("info")
      -- Manage.configure()
    end,
  },
  help = {
    key = "?",
    desc = "Show help view",
    action = function()
      M.show("help")
    end,
  },
}

function M.new()
  M.popup = Popup({
    position = "50%",
    size = "80%",
    enter = true,
    focusable = true,
    zindex = 50,
    relative = "editor",
    ns_id = "neobuild",
    border = {
      padding = {
        top = 1,
        bottom = 1,
        left = 2,
        right = 2,
      },
      style = "rounded",
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  })

  M.popup:on({ Event.BufWinLeave }, function()
    vim.schedule(function()
      M.popup:unmount()
      M.is_mounted = false
    end)
  end, { once = true })

  for _, cmd in pairs(commands) do
    M.popup:map("n", cmd.key, function()
      cmd.action()
    end, { noremap = true })
  end

  M.is_visible = false
  M.is_mounted = false
end

function M._append(content, highlight)
  if #M._lines == 0 then
    table.insert(M._lines, Line())
  end
  return M._lines[#M._lines]:append(content, highlight)
end

function M.title()
  M._append("Home [H]\tInfo [I]\tBuild [B]\tConfigure [C]\tLogs [L]\tHelp [?]", "Special")
  M.newline()
  M.newline()
end

function M.newline()
  table.insert(M._lines, Line())
end

function M.update()
  local function render(bufnr, ns_id, linenr_start, linenr_end)
    linenr_start = linenr_start or 1
    for _, line in ipairs(M._lines) do
      line:render(bufnr, ns_id, linenr_start, linenr_end)
      linenr_start = linenr_start + 1
      if linenr_end then
        linenr_end = linenr_end + 1
      end
    end
  end

  M._lines = {}
  M.title()
  M.help()
  render(M.popup.bufnr, -1)
end

function M.help()
  M._append("Help", "Title")
  M.newline()
  M.newline()
  M._append("Key bindings", "Special")
  M.newline()

  for _, cmd in pairs(commands) do
    M._append("<" .. cmd.key .. "> " .. cmd.desc)
    M.newline()
  end
end

function M.show(mode)
  if M.is_mounted then
    M.popup:show()
  else
    M.popup:mount()
    M.is_mounted = true
    M.is_visible = true
  end
end

function M.toggle()
  if M.is_visible then
    M.popup.hide()
    M.is_visible = false
  else
    M.show()
  end
end

M.new()
M.show()
M.update()

--return M
