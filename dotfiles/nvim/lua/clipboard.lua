-- OSC52 clipboard configuration for seamless remote/local clipboard access
-- This enables neovim clipboard operations to work transparently over SSH and web terminals

-- Three different clipboard strategies are needed due to tmux and remote access limitations:
--
-- 1. OUTSIDE TMUX: Pure OSC52 works perfectly
--    - Copy: OSC52 sequence sent directly to terminal → system clipboard
--    - Paste: OSC52 query sent to terminal → terminal responds → neovim receives content
--
-- 2. REMOTE TMUX: Pure OSC52 (bypass tmux)
--    - Copy: OSC52 sequence sent directly to terminal → local system clipboard
--    - Paste: OSC52 query sent to terminal → local system clipboard content
--    - Reason: tmux refresh-client only works with local system clipboard, not remote
--
-- 3. LOCAL TMUX: Hybrid strategy
--    - Copy: tmux saves to buffer AND forwards OSC52 to terminal (works)
--    - Paste: tmux intercepts OSC52 queries, only reads from tmux buffer (broken)
--    - Solution: Use tmux's refresh-client -l to sync system clipboard → tmux buffer
--

if vim.env.TMUX == nil then
  -- Outside tmux: Pure OSC52 strategy
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
elseif vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil then
  -- Remote tmux: Pure OSC52 strategy (bypass tmux for remote sessions)
  vim.g.clipboard = {
    name = 'OSC 52 Remote',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
else
  -- Local tmux: Hybrid strategy
  -- Copy: tmux load-buffer with -w flag forwards to terminal via OSC52
  -- Paste: refresh-client -l syncs system clipboard to tmux buffer, then read buffer
  local copy = {'tmux', 'load-buffer', '-w', '-'}
  local paste = {'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -'}
  vim.g.clipboard = {
    name = 'tmux',
    copy = { ['+'] = copy, ['*'] = copy },
    paste = { ['+'] = paste, ['*'] = paste },
    cache_enabled = 0,
  }
end

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})