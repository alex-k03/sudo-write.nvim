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
