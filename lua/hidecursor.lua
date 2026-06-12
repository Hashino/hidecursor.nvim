-- hidecursor.nvim
-- Toggle cursor visibility for distraction-free reading.
-- Provides the :ToggleCursor command and a configurable keymap.

local HideCursor = {}

local saved_guicursor = nil

local function is_hidden()
  return saved_guicursor ~= nil
end

-- Terminal escape sequences to hide/show cursor (DEC private mode 25)
local HIDE_SEQ = '\027[?25l'
local SHOW_SEQ = '\027[?25h'

-- DEC private mode 25 (DCS) is supported by most xterm-compatible terminals.
-- Skip in GUI mode (nvim --gui) where these escape sequences don't apply.
local function in_terminal()
  return vim.fn.has('gui_running') == 0
end

function HideCursor.hide()
  if is_hidden() then
    return
  end
  saved_guicursor = vim.o.guicursor

  -- 1) Clear guicursor so Neovim stops controlling cursor shape.
  --    In GUI mode the cursor becomes invisible; in terminal mode it
  --    falls back to the terminal's default.
  vim.o.guicursor = ''

  -- 2) Additional terminal escape to hide the cursor (reliable in xterm, kitty, etc.)
  if in_terminal() then
    io.write(HIDE_SEQ)
    io.flush()
  end
end

function HideCursor.restore()
  if not is_hidden() then
    return
  end
  vim.o.guicursor = saved_guicursor
  saved_guicursor = nil

  -- Restore cursor visibility in terminal
  if in_terminal() then
    io.write(SHOW_SEQ)
    io.flush()
  end
end

function HideCursor.toggle()
  if is_hidden() then
    HideCursor.restore()
  else
    HideCursor.hide()
  end
end

vim.api.nvim_create_user_command('ToggleCursor', HideCursor.toggle, {
  desc = 'Toggle cursor visibility',
})

--- Configure the plugin.
---@param opts? { keymap?: string|false }
---  - keymap: key binding for Normal mode (default: '<leader>tc').
---    Set to false to disable the default keymap.
--- Configure the plugin and register a keymap.
--- Call this in your config after requiring the plugin.
---@param opts? { keymap?: string|false }
---  - keymap: key binding for Normal mode (default: '<leader>tc').
---    Set to false to disable the keymap.
---@usage
---  require('hidecursor').setup()                  -- uses '<leader>tc'
---  require('hidecursor').setup({ keymap = '<A-c>' })  -- custom key
---  require('hidecursor').setup({ keymap = false })     -- no keymap, use :ToggleCursor
function HideCursor.setup(opts)
  opts = opts or {}
  local keymap = vim.F.if_nil(opts.keymap, '<leader>tc')

  if keymap then
    vim.keymap.set('n', keymap, function()
      HideCursor.toggle()
    end, { desc = '[T]oggle [C]ursor' })
  end
end

return HideCursor
