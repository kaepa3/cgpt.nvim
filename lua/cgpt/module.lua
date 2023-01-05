-- module represents a lua module for the plugin
local M = {}

local jobid = -1
local bufName = "__ChatCpt__"

local function create_buffer()
  local bufId = vim.fn.bufnr(bufName)
  local windows = vim.fn.win_findbuf(bufId)
  if #windows <= 0 then
    if bufId == -1 then
      vim.cmd("b " .. bufId)
    else
      local buf = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_buf_set_name(buf, bufName)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.cmd("vsplit")
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, buf)
    end
  else
    vim.fn.win_gotoid(windows[1])
  end
end

local function focus_buffer() end

local function print_stdout(chan_id, data, name)
  local bufId = vim.fn.bufnr(bufName)
  local windows = vim.fn.win_findbuf(bufId)
  if #windows <= 0 then
    create_buffer()
  else
    vim.fn.win_gotoid(windows[1])
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, data)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  end
end

local function get_channel()
  if jobid == -1 then
    jobid = vim.fn.jobstart("ls", { on_stdout = print_stdout })
  end
  return jobid
end

M.my_first_function = function()
  create_buffer()
  local id = get_channel()
end

return M
