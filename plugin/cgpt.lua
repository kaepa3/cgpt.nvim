package.loaded["cgpt"] = nil
package.loaded["cgpt.module"] = nil

vim.api.nvim_create_user_command("Cgpt", function(args)
  require("cgpt").ask(args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("CodeReview", require("cgpt").code_review, {})
