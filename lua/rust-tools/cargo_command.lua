local M = {}

function M.cargo(args)
  require 'rust-tools.open_cargo_toml'.open_cargo_toml(function(_, result, ctx)
    if result == nil then
      vim.notify("Cargo.toml not found")
    end
    local location = vim.uri_to_fname(result.uri)
    local command = vim.tbl_flatten{ 'cargo', args, '--manifest-path', location }
    local val = vim.system(command):wait()
    vim.print(val)
  end)
end

return M
