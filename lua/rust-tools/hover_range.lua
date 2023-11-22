local rt = require("rust-tools")

local M = {}

local function pos_to_lsp_pos(vim_pos)
  return {
    line = vim_pos[2] - 1,
    character = vim_pos[3]
  }
end

local function get_opts()
  local range = vim.lsp.util.make_range_params()

  local start_pos
  local end_pos
  local mode = vim.api.nvim_get_mode().mode
  start_pos = pos_to_lsp_pos(vim.fn.getpos("v"))
  end_pos = pos_to_lsp_pos(vim.fn.getpos("."))
  if start_pos.line > end_pos.line or start_pos.line == end_pos.line and start_pos.character > end_pos.character then
    start_pos, end_pos = end_pos, start_pos
  end
  -- print(vim.inspect(start_pos) .. ".." .. vim.inspect(end_pos))
  if mode == "V" then
    start_pos.character = 0
    end_pos.character = vim.fn.getline(end_pos.line + 1):len()
  end
  -- vim.notify("start_pos: " .. vim.inspect(start_pos), vim.log.levels.INFO)
  -- vim.notify("end_pos: " .. vim.inspect(end_pos), vim.log.levels.INFO)

  local params = {}
  params.textDocument = range.textDocument
  if start_pos == end_pos then
    params.position = start_pos
  else
    params.position = {
      start = start_pos,
      ["end"] = end_pos,
    }
  end

  return params
end

function M.hover_range()
  rt.utils.request(0, "textDocument/hover", get_opts(), require("rust-tools.hover_actions").handler
  )
end

return M
