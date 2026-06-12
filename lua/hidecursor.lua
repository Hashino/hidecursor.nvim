-- hidecursor.nvim
-- Toggle cursor visibility for distraction-free reading.
-- Provides the :ToggleCursor command.

local M = {}

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

function M.hide()
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

function M.restore()
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

function M.toggle()
  if is_hidden() then
    M.restore()
  else
    M.hide()
  end
end

vim.api.nvim_create_user_command('ToggleCursor', M.toggle, {
  desc = 'Toggle cursor visibility',
})

return M
