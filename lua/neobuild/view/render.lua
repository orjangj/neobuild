local Config = require("neobuild.config")
local ViewConfig = require("neobuild.view.config")
local Text = require("neobuild.view.text")

---@class NeobuildRender:Text
---@field view NeobuildView
local M = {}

---@return NeobuildRender
---@param view NeobuildView
function M.new(view)
  ---@type NeobuildRender
  local self = setmetatable({}, { __index = setmetatable(M, { __index = Text }) })
  self.view = view
  self.wrap = view.win_opts.width
  return self
end

function M:update()
  self._lines = {}
  self._diagnostics = {}
  self.locations = {}

  self:title()

  local mode = self.view.state.mode
  if mode == "help" then
    self:help()
  else
    for _, section in ipairs(Sections) do
      self:section(section)
    end
  end

  self:trim()
  self:render(self.view.buf)
end

function M:title()
  self:newline()

  for _, mode in ipairs(ViewConfig.get_commands()) do
    if mode.button then
      local title = " " .. mode.name:sub(1, 1):upper() .. mode.name:sub(2) .. " (" .. mode.key .. ") "
      if mode.name == "home" then
        if self.view.state.mode == "home" then
          title = " lazy.nvim  " .. Config.options.ui.icons.lazy
        else
          title = " lazy.nvim (H) "
        end
      end

      if self.view.state.mode == mode.name then
        if mode.name == "home" then
          self:append(title, "NeobuildH1", { wrap = true })
        else
          self:append(title, "NeobuildButtonActive", { wrap = true })
          self:highlight({ ["%(.%)"] = "NeobuildSpecial" })
        end
      else
        self:append(title, "NeobuildButton", { wrap = true })
        self:highlight({ ["%(.%)"] = "NeobuildSpecial" })
      end
      self:append(" ")
    end
  end

  self:newline()
end

function M:help()
  self:append("Help", "NeobuildH2"):newline():newline()
  self
    :append("Use ")
    :append(ViewConfig.keys.abort, "NeobuildSpecial")
    :append(" to abort all running tasks.")
    :newline()
    :newline()
  self
    :append("You can press ")
    :append("<CR>", "NeobuildSpecial")
    :append(" on a plugin to show its details.")
    :newline()
    :newline()
  self:append("Most properties can be hovered with ")
  self:append("<K>", "NeobuildSpecial")
  self:append(" to open links, help files, readmes and git commits."):newline()
  self
    :append("When hovering with ")
    :append("<K>", "NeobuildSpecial")
    :append(" on a plugin anywhere else, a diff will be opened if there are updates")
    :newline()
  self:append("or the plugin was just updated. Otherwise the plugin webpage will open."):newline():newline()
  self:append("Use "):append("<d>", "NeobuildSpecial"):append(" on a commit or plugin to open the diff view"):newline()
  self:newline()
  self:append("Keyboard Shortcuts", "NeobuildH2"):newline()
  for _, mode in ipairs(ViewConfig.get_commands()) do
    if mode.key then
      local title = mode.name:sub(1, 1):upper() .. mode.name:sub(2)
      self:append("- ", "NeobuildSpecial", { indent = 2 })
      self:append(title, "Title")
      if mode.key then
        self:append(" <" .. mode.key .. ">", "NeobuildProp")
      end
      self:append(" " .. (mode.desc or "")):newline()
    end
  end
  self:newline():append("Keyboard Shortcuts for Plugins", "NeobuildH2"):newline()
  for _, mode in ipairs(ViewConfig.get_commands()) do
    if mode.key_plugin then
      local title = mode.name:sub(1, 1):upper() .. mode.name:sub(2)
      self:append("- ", "NeobuildSpecial", { indent = 2 })
      self:append(title, "Title")
      if mode.key_plugin then
        self:append(" <" .. mode.key_plugin .. ">", "NeobuildProp")
      end
      self:append(" " .. (mode.desc_plugin or mode.desc)):newline()
    end
  end
end

return M
