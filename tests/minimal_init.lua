local M = {}

function M.root(root)
    local f = debug.getinfo(1, "S").source:sub(2)
    return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (root or "")
end

function M.setup()
    -- vim.cmd([[set runtimepath=$VIMRUNTIME]])
    vim.opt.runtimepath:append(M.root())
    -- vim.env.XDG_CONFIG_HOME = M.root(".tests/config")
    -- vim.env.XDG_DATA_HOME = M.root(".tests/data")
    -- vim.env.XDG_STATE_HOME = M.root(".tests/state")
    -- vim.env.XDG_CACHE_HOME = M.root(".tests/cache")

    vim.opt.expandtab = true
    require("nvim-surround").setup()
end

M.setup()
