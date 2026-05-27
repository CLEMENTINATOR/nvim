local M = {}
local H = {}

M.session_file = 'Session.vim'

M.delete_all = function()
  for _, session in pairs(MiniSessions.detected) do
    if string.find(vim.v.this_session, session.name) == nil then
      MiniSessions.delete(session.name)
    end
  end
end

M.close_ephemeral_buffers = function()
  local patterns = { 'fugitive://.*', 'term://.*', 'octo://.*', 'OctoChangedFile.*', 'diffview://.*' }

  for _, pattern in ipairs(patterns) do
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.bufname(buffer):match(pattern) then
        vim.api.nvim_buf_delete(buffer, { force = true })
      end
    end
  end
end

H.is_something_shown = function()
  if vim.fn.argc() > 0 then
    return true
  end

  local listed_buffers = vim.tbl_filter(function(buf_id)
    return vim.fn.buflisted(buf_id) == 1
  end, vim.api.nvim_list_bufs())
  if #listed_buffers > 1 then
    return true
  end

  if vim.bo.filetype ~= '' then
    return true
  end

  local n_lines = vim.api.nvim_buf_line_count(0)
  if n_lines > 1 then
    return true
  end
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
  if string.len(first_line) > 0 then
    return true
  end

  return false
end

M.ensure_session = function()
  if H.is_something_shown() then
    return
  end

  local f = io.open(M.session_file, 'r')
  if f == nil then
    vim.cmd('silent! mksession ' .. M.session_file)
  else
    f:close()
  end
end

return M
