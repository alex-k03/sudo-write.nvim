vim.api.nvim_create_user_command("SudoWrite", function()
    require("sudo-write").write()
end, { desc = "Write buffer with sudo" })
