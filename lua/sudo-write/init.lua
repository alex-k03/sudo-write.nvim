local M = {}

M.config = {
    keys = nil,
}

local function buffer_text()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local text = table.concat(lines, "\n")

    if vim.bo.endofline then
        text = text .. "\n"
    end

    if vim.bo.fileformat == "dos" then
        text = text:gsub("\n", "\r\n")
    elseif vim.bo.fileformat == "mac" then
        text = text:gsub("\n", "\r")
    end

    return text
end

local function run_sudo(args, input)
    local out = vim.fn.system(args, input)
    return vim.v.shell_error == 0, out
end

local function clean_err(out)
    local msg = vim.trim(out or "")
    if msg == "" then
        return "unknown sudo error"
    end
    return msg
end

function M.write()
    local file = vim.fn.expand("%")
    if file == "" then
        vim.notify("sudo-write: no file name", vim.log.levels.ERROR)
        return
    end

    local text = buffer_text()

    local ok = run_sudo({ "sudo", "-n", "tee", file }, text)
    if ok then
        vim.bo.modified = false
        return
    end

    local password = vim.fn.inputsecret("sudo password: ")
    vim.cmd("redraw")
    if password == nil or password == "" then
        vim.notify("sudo-write: authentication cancelled", vim.log.levels.WARN)
        return
    end

    local ok2, out = run_sudo({ "sudo", "-S", "-p", "", "tee", file }, password .. "\n" .. text)
    if not ok2 then
        vim.notify("sudo-write: write failed: " .. clean_err(out), vim.log.levels.ERROR)
        return
    end

    vim.bo.modified = false
end

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})

    if M.config.keys then
        for _, key in ipairs(M.config.keys) do
            vim.keymap.set(key.mode or "n", key[1], M.write, {
                desc = key.desc or "Sudo write",
                silent = key.silent ~= false,
            })
        end
    end
end

return M
