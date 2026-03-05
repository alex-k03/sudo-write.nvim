# sudo-write.nvim

Save protected files with `sudo` from inside Neovim.

Use this when normal `:w` fails (for example editing `/etc/hosts`).

## Installation (lazy.nvim)

```lua
{
  "alex-k03/sudo-write.nvim",
  config = function()
    require("sudo-write").setup({
      keys = {
        { "<leader>bS", desc = "Sudo force save" },
      },
    })
  end,
}
```

## Usage

- Keymap: `<leader>bS` (sudo force save current file)
- Command: `:SudoWrite`

If sudo credentials aren't cached, you'll be prompted for your password inline. Leaving it blank cancels the write.

Multiple keymaps and custom `mode`/`desc`/`silent` per binding are supported.
