package.loaded["cgpt"] = nil
package.loaded["cgpt.module"] = nil
vim.api.nvim_create_user_command("Cgpt", require("cgpt").hello, {})
