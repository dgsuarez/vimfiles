local select = require('nvim-treesitter-textobjects.select')
local swap = require('nvim-treesitter-textobjects.swap')
local move = require('nvim-treesitter-textobjects.move')

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

-- Textobject keymaps
local textobjects = {
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['aa'] = '@parameter.outer',
  ['ia'] = '@parameter.inner',
}

for key, query in pairs(textobjects) do
  vim.keymap.set({ 'x', 'o' }, key, function()
    select.select_textobject(query, 'textobjects')
  end, { silent = true })
end

-- Custom "ir"/"ar" textobject: selects the nearest enclosing scope
-- (method, class, block, if, while, for, case, lambda, etc.)
-- Works across all languages by walking up the treesitter tree.
local scope_nodes = {
  -- Ruby
  method = true, singleton_method = true, class = true, module = true,
  singleton_class = true, do_block = true, block = true,
  ['if'] = true, unless = true, ['while'] = true, until_ = true,
  ['for'] = true, case = true, begin = true, lambda = true,
  -- JS/TS
  function_declaration = true, function_expression = true,
  arrow_function = true, method_definition = true,
  class_declaration = true, class_body = true,
  if_statement = true, while_statement = true, for_statement = true,
  for_in_statement = true, switch_statement = true, try_statement = true,
  -- Python
  function_definition = true, class_definition = true,
  if_statement_py = true, while_statement_py = true,
  for_statement_py = true, try_statement_py = true,
  with_statement = true,
  -- Go
  func_literal = true, function_declaration_go = true,
  method_declaration = true, if_statement_go = true,
  for_statement_go = true, select_statement = true,
  -- Lua
  function_call = false, -- too broad
  -- Generic fallback: any named node spanning multiple lines
}

local function find_scope(inner)
  local node = vim.treesitter.get_node()
  if not node then return end

  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

  while node do
    local sr, _, er, _ = node:range()
    local is_scope = scope_nodes[node:type()]
    -- Fallback: any named multi-line node that contains (not starts/ends at) cursor
    if is_scope == nil and node:named() and sr < cursor_row and er > cursor_row and (er - sr) >= 2 then
      is_scope = true
    end

    if is_scope and sr < er then
      if inner and (er - sr) >= 2 then
        -- Select lines between first and last line of the node
        vim.api.nvim_win_set_cursor(0, { sr + 2, 0 })
        vim.cmd('normal! 0V')
        vim.api.nvim_win_set_cursor(0, { er, 0 })
      else
        vim.api.nvim_win_set_cursor(0, { sr + 1, 0 })
        vim.cmd('normal! 0V')
        vim.api.nvim_win_set_cursor(0, { er + 1, 0 })
      end
      return
    end
    node = node:parent()
  end
end

vim.keymap.set({ 'x', 'o' }, 'ir', function() find_scope(true) end, { silent = true })
vim.keymap.set({ 'x', 'o' }, 'ar', function() find_scope(false) end, { silent = true })

-- Swap parameters
vim.keymap.set('n', '<leader>s', function()
  swap.swap_next('@parameter.inner', 'textobjects')
end, { silent = true })
vim.keymap.set('n', '<leader>S', function()
  swap.swap_previous('@parameter.inner', 'textobjects')
end, { silent = true })

-- Move between functions/classes
local move_maps = {
  [']m'] = { '@function.outer', 'next_start' },
  ['[m'] = { '@function.outer', 'previous_start' },
  [']c'] = { '@class.outer', 'next_start' },
  ['[c'] = { '@class.outer', 'previous_start' },
}

for key, opts in pairs(move_maps) do
  vim.keymap.set({ 'n', 'x', 'o' }, key, function()
    move['goto_' .. opts[2]](opts[1], 'textobjects')
  end, { silent = true })
end
