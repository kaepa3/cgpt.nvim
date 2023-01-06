-- module represents a lua module for the plugin
local M = {}

local jobid = -1
local chat_buffer_name = "__ChatCpt__"

local function get_current_buffer()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  return buf
end

local function isempty(s)
  return s == nil or s == ""
end

local function focus_buffer()
  local bufId = vim.fn.bufnr(chat_buffer_name)
  local windows = vim.fn.win_findbuf(bufId)
  if #windows <= 0 then
    if bufId ~= -1 then
      vim.cmd("b " .. bufId)
    else
      local buf = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_buf_set_name(buf, chat_buffer_name)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.cmd("vsplit")
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, buf)
    end
  else
    vim.fn.win_gotoid(windows[1])
  end
end

local add_text = {}
local new_line = "\n"

local function add_next_to_table(text)
  textVal = text == new_line and "" or text
  if #add_text == 0 then
    add_text = { textVal }
  else
    before_text = add_text[#add_text]
    if before_text == "" or text == new_line then
      table.insert(add_text, textVal)
    else
      add_text[#add_text] = before_text .. textVal
    end
  end
end

local function print_stdout(chan_id, data, name)
  val = vim.fn.json_decode(data[1])
  add_next_to_table(val["text"])
  if val["eof"] == true then
    focus_buffer()
    local buf = get_current_buffer()
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, add_text)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    add_text = {}
  elseif not isempty(val["error"]) then
    print(val["error"])
    add_text = {}
  end
end

local function get_channel()
  if jobid == -1 then
    jobid = vim.fn.jobstart({ "chatgpt", "-json" }, { on_stdout = print_stdout })
  end
  return jobid
end

local function send(text)
  focus_buffer()
  local ch = get_channel()
  local json = vim.fn.json_encode({ text = text })
  vim.fn.chansend(ch, json)
end

M.code_review = function(lang)
  local question = lang == "ja" and "このプログラムをレビューして下さい。" or "please code review"
  local buf = get_current_buffer()
  local text = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  local lines = { question, "", "" }
  for _, value in ipairs(text) do
    table.insert(lines, value)
  end
  table.insert(lines, new_line)
  send(table.concat(lines, "\n"))
end

M.ask = function(args)
  if #args == 0 then
    print("input error")
    return
  end
  send(args)
end

return M
