-- diagram.nvim renderer for mermaid fences backed by mmdr, a native renderer;
-- mermaid-cli spends ~1s starting a browser for every changed diagram
local M = { id = 'mermaid' }

local cache_dir = vim.fn.stdpath('cache') .. '/diagram-cache/mmdr'
vim.fn.mkdir(cache_dir, 'p')

function M.render(source)
  local path = cache_dir .. '/' .. vim.fn.sha256(source) .. '.png'
  if vim.fn.filereadable(path) == 1 then return { file_path = path } end

  local input = vim.fn.tempname()
  vim.fn.writefile(vim.split(source, '\n'), input)

  local job_id = vim.fn.jobstart({ 'mmdr', '-e', 'png', '-i', input, '-o', path }, {
    on_exit = function(_, code)
      if code ~= 0 then vim.notify('mmdr failed to render a mermaid diagram', vim.log.levels.WARN) end
    end,
  })
  return { file_path = path, job_id = job_id }
end

return M
