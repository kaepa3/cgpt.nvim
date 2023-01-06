-- main module file
local module = require("cgpt.module")

local M = {}
M.config = {
  -- default config
  opt = "Hello!",
  lang = "ja",
}

-- setup is the public method to setup your plugin
M.setup = function(args)
  -- you can define your setup function here. Usually configurations can be merged, accepting outside params and
  -- you can also put some validation here for those.
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

-- "hello" is a public method for the plugin
M.ask = function(opt)
  if #opt.args == 0 then
    print("input error")
    return
  end
  module.send(opt.args)
end

M.code_review = function()
  query = module.create_codereview_query(M.config.lang)
  module.send(query)
end

return M
