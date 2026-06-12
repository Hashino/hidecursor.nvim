<div align="right">
  <a href="https://www.buymeacoffee.com/Hashino" target="_blank">
    <img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" 
    alt="Buy Me A Coffee" style="height: 24px !important;width: 104px !important;" >
  </a>
</div>

# hidecursor.nvim

<a href="https://dotfyle.com/plugins/Hashino/hidecursor.nvim">
	<img src="https://dotfyle.com/plugins/Hashino/hidecursor.nvim/shield?style=flat" />
</a>

Toggle cursor visibility for distraction-free reading.

Hides the cursor while reading documents and restores it when you need to edit.

## commands

- `:ToggleCursor` toggles cursor visibility on and off

## installation

lazy.nvim:
```lua
{
  "Hashino/hidecursor.nvim",
  cmd = "ToggleCursor",
  keys = {
    { "<leader>tc", function() require("hidecursor").toggle() end, desc = "[T]oggle [C]ursor", },
  },
}
```

vim.pack:
```lua
vim.pack.add({ "https://github.com/Hashino/hidecursor.nvim", })

vim.keymap.set("n", "<leader>tc", function()
  require("hidecursor").toggle()
end, { desc = "[T]oggle [C]ursor" })
```

## how it works

When hiding, the plugin clears `guicursor` (making the cursor invisible in GUI mode) and sends the DEC private mode 25 escape sequence (`\027[?25l`) to the terminal — supported by xterm, kitty, alacritty, gnome-terminal, and most modern terminal emulators. Restoring the cursor sends the show sequence (`\027[?25h`) and reapplies the saved `guicursor` value.
