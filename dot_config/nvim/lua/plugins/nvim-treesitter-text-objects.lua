-- nvim-treesitter-textobjects `main` branch (must match nvim-treesitter's branch).
-- The config-table keymaps from `master` are gone; bind each mapping manually.
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local map = vim.keymap.set

    -- Select ---------------------------------------------------------------
    local select_maps = {
      { "a=", "@assignment.outer", "Select outer part of an assignment" },
      { "i=", "@assignment.inner", "Select inner part of an assignment" },
      { "l=", "@assignment.lhs", "Select left hand side of an assignment" },
      { "r=", "@assignment.rhs", "Select right hand side of an assignment" },

      { "a:", "@property.outer", "Select outer part of an object property" },
      { "i:", "@property.inner", "Select inner part of an object property" },
      { "l:", "@property.lhs", "Select left part of an object property" },
      { "r:", "@property.rhs", "Select right part of an object property" },

      { "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
      { "ia", "@parameter.inner", "Select inner part of a parameter/argument" },

      { "ai", "@conditional.outer", "Select outer part of a conditional" },
      { "ii", "@conditional.inner", "Select inner part of a conditional" },

      { "al", "@loop.outer", "Select outer part of a loop" },
      { "il", "@loop.inner", "Select inner part of a loop" },

      { "af", "@call.outer", "Select outer part of a function call" },
      { "if", "@call.inner", "Select inner part of a function call" },

      { "am", "@function.outer", "Select outer part of a method/function definition" },
      { "im", "@function.inner", "Select inner part of a method/function definition" },

      { "ac", "@class.outer", "Select outer part of a class" },
      { "ic", "@class.inner", "Select inner part of a class" },
    }
    for _, m in ipairs(select_maps) do
      map({ "x", "o" }, m[1], function()
        require("nvim-treesitter-textobjects.select").select_textobject(m[2], "textobjects")
      end, { desc = m[3] })
    end

    -- Swap -----------------------------------------------------------------
    local swap_maps = {
      next = {
        { "<leader>na", "@parameter.inner" },
        { "<leader>n:", "@property.outer" },
        { "<leader>nm", "@function.outer" },
      },
      previous = {
        { "<leader>pa", "@parameter.inner" },
        { "<leader>p:", "@property.outer" },
        { "<leader>pm", "@function.outer" },
      },
    }
    for dir, maps in pairs(swap_maps) do
      for _, m in ipairs(maps) do
        map("n", m[1], function()
          require("nvim-treesitter-textobjects.swap")["swap_" .. dir](m[2])
        end, { desc = "Swap " .. dir .. " " .. m[2] })
      end
    end

    -- Move -----------------------------------------------------------------
    -- { lhs, query, desc [, query_group] } per move function
    local move_maps = {
      goto_next_start = {
        { "]f", "@call.outer", "Next function call start" },
        { "]m", "@function.outer", "Next method/function def start" },
        { "]c", "@class.outer", "Next class start" },
        { "]i", "@conditional.outer", "Next conditional start" },
        { "]l", "@loop.outer", "Next loop start" },
        { "]s", "@scope", "Next scope", "locals" },
        { "]z", "@fold", "Next fold", "folds" },
      },
      goto_next_end = {
        { "]F", "@call.outer", "Next function call end" },
        { "]M", "@function.outer", "Next method/function def end" },
        { "]C", "@class.outer", "Next class end" },
        { "]I", "@conditional.outer", "Next conditional end" },
        { "]L", "@loop.outer", "Next loop end" },
      },
      goto_previous_start = {
        { "[f", "@call.outer", "Prev function call start" },
        { "[m", "@function.outer", "Prev method/function def start" },
        { "[c", "@class.outer", "Prev class start" },
        { "[i", "@conditional.outer", "Prev conditional start" },
        { "[l", "@loop.outer", "Prev loop start" },
      },
      goto_previous_end = {
        { "[F", "@call.outer", "Prev function call end" },
        { "[M", "@function.outer", "Prev method/function def end" },
        { "[C", "@class.outer", "Prev class end" },
        { "[I", "@conditional.outer", "Prev conditional end" },
        { "[L", "@loop.outer", "Prev loop end" },
      },
    }
    for fn, maps in pairs(move_maps) do
      for _, m in ipairs(maps) do
        map({ "n", "x", "o" }, m[1], function()
          require("nvim-treesitter-textobjects.move")[fn](m[2], m[4] or "textobjects")
        end, { desc = m[3] })
      end
    end
  end,
}
