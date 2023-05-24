local Config = require("neobuild.config")

---@class NeobuildFloat
local M = {}

setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})

function M.new(opts)
  local self = setmetatable({}, { __index = M })
  return self:init(opts)
end

function M:init(opts)
  self.opts = vim.tbl_deep_extend("force", {
    size = { width = 0.9, height = 0.8 },
    style = "minimal",
    border = "rounded",
    zindex = 50,
  }, opts or {})

  self.win_opts = {
    relative = "editor",
    style = self.opts.style ~= "" and self.opts.style or nil,
    border = self.opts.border,
    zindex = self.opts.zindex,
    noautocmd = true,
  }

  -- TODO: add margins?
  self.win_opts.width = math.floor(vim.o.columns * self.opts.size.width)
  self.win_opts.height = math.floor(vim.o.lines * self.opts.size.height)
  self.win_opts.row = math.floor((vim.o.lines - self.win_opts.height) / 2) - 1
  self.win_opts.col = math.floor((vim.o.columns - self.win_opts.width) / 2)

  self.buf = vim.api.nvim_create_buf(false, false)
  self.win = vim.api.nvim_open_win(self.buf, true, self.win_opts)
  vim.api.nvim_set_current_win(self.win)

  vim.bo[self.buf].buftype = "nofile"
  if vim.bo[self.buf].filetype == "" then
    vim.bo[self.buf].filetype = "neobuild"
  end
  vim.bo[self.buf].bufhidden = "wipe"
  vim.wo[self.win].conceallevel = 3
  vim.wo[self.win].foldenable = false
  vim.wo[self.win].spell = false
  vim.wo[self.win].wrap = true
  vim.wo[self.win].winhighlight = "Normal:NormalFloat"
  vim.wo[self.win].colorcolumn = ""

  vim.api.nvim_buf_set_keymap(self.buf, "n", "q", "<cmd>q!<cr>", { silent = true, noremap = true })
  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    buffer = self.buf,
    once = true,
    callback = function()
      return self.close(self)
    end,
  })
end

function M:close()
  local buf = self.buf
  local win = self.win
  self.win = nil
  self.buf = nil
  vim.schedule(function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.diagnostic.reset(Config.ns, buf)
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)
end

return M
