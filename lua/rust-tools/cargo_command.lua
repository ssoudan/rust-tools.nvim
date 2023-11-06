local M = {}

local manifest_path_argument = '--manifest-path'

function M.register_ex_command()
  vim.api.nvim_create_user_command('CargoWrapper', function(args)
    local command = args.fargs
    assert(command[1] == "cargo", "command was not cargo")
    table.remove(command, 1)
    M.cargo(command)
  end, { nargs = '*' })
end

local opts = require("rust-tools.config").options

function M.cargo(args)
  if vim.tbl_contains(args, manifest_path_argument) then
    -- vim.api.nvim_command('terminal ' .. table.concat(command, ' '))
    opts.tools.executor.execute_command('cargo', args)
  else
    require 'rust-tools.open_cargo_toml'.open_cargo_toml(function(_, result, _)
      if result == nil then
        vim.notify("Cargo.toml not found")
      end
      local location = vim.uri_to_fname(result.uri)
      args = vim.tbl_flatten { args, '--manifest-path', '"'..location..'"' }
      opts.tools.executor.execute_command('cargo', args)
    end)
  end
end

return M
