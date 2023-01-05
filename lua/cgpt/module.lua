-- module represents a lua module for the plugin
local M = {}

local jobid = -1
local bufName = "__ChatCpt__"

local function print_stdout(chan_id, data, name)
  if data == nil then
    print("null data")
    return
  end
  print("----------------------------------------")
  print(chan_id, data, name)
  print("----------------------------------------")
  ids = vim.fn.win_findbuf(bufName)
  if #ids <= 0 then
    print("not find!!!!!!!!!!!")
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, bufName)
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
  else
    print("find!!!!!!!!!!!")
    vim.api.win_gotoid(ids[0])
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
  end

  --  if vim.fn.win_gotoid(id) == 0 then
  --    vim.fn.chansend(id, "fas")
  --
  --  end
end

local function get_channel()
  print("call get_channel")
  if jobid == -1 then
    jobid = vim.fn.jobstart("ls", { on_stdout = print_stdout })
  end
  return jobid
end

M.my_first_function = function()
  --  get_channel()

  local bufId = vim.fn.bufnr(bufName)
  local windows = vim.fn.win_findbuf(bufId)
  if #windows <= 0 then
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, bufName)
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "hoge", "noge" })
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  else
    vim.fn.win_gotoid(windows[1])
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "add", "noge" })
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  end
end

return M
