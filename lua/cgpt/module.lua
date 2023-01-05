-- module represents a lua module for the plugin

local M = {}

local jobid = -1
local bufName = "__ChatCpt__"

local function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

local function isempty(s)
  return s == nil or s == ""
end

local function forcus_buffer()
  local bufId = vim.fn.bufnr(bufName)
  local windows = vim.fn.win_findbuf(bufId)
  if #windows <= 0 then
    if bufId ~= -1 then
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

local add_text = {}

local new_line = "\n"

local function add_table(text)
  if #add_text == 0 then
    if text == new_line then
      add_text = { "" }
    else
      add_text = { text }
    end
  else
    before_text = add_text[#add_text]
    if before_text == "" or text == new_line then
      if text == new_line then
        table.insert(add_text, "")
      else
        table.insert(add_text, text)
      end
    else
      updateText = before_text .. text
      add_text[#add_text] = updateText
    end
  end
end

local function print_stdout(chan_id, data, name)
  val = vim.fn.json_decode(data[1])
  add_table(val["text"])
  if val["eof"] == true then
    print(dump(add_text))
    local bufId = vim.fn.bufnr(bufName)
    local windows = vim.fn.win_findbuf(bufId)
    if #windows <= 0 then
      forcus_buffer()
    else
      vim.fn.win_gotoid(windows[1])
    end
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, add_text)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    add_text = {}
  elseif not isempty(val["error"]) then
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, { val["error"] })
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    add_text = {}
  end
end

local function get_channel()
  if jobid == -1 then
    --jobid = vim.fn.jobstart("ls", { on_stdout = print_stdout })
    jobid = vim.fn.jobstart({ "chatgpt", "-json" }, { on_stdout = print_stdout })
  end
  return jobid
end

M.my_first_function = function()
  forcus_buffer()
  local id = get_channel()
end

local function send(text)
  forcus_buffer()
  local ch = get_channel()
  local json = vim.fn.json_encode({ text = text })
  vim.fn.chansend(ch, json)
end

M.code_review = function()
  --local lang = M.config.lang
  local lang = "ja"
  local question = lang == "^ja" and "このプログラムをレビューして下さい。" or "please code review"
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local text = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  --/local lines = { question, "\n", text }
  send("今日の天気は？ ")
end

return M
