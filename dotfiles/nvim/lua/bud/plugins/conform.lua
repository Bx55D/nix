-- lua/plugins/conform.lua (or wherever you manage plugins)
return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" }, -- Run formatting only when writing the buffer (preferred)
  -- Or event = { "BufReadPre", "BufNewFile" }, -- Run on buffer load (can be slower)
  cmd = "ConformInfo",
  opts = {
    -- Define your formatters here
    formatters_by_ft = {
      javascript = { "prettier" },
      -- javascriptreact = { "prettier" }, -- If you use .jsx
      -- typescript = { "prettier" },     -- If you use TypeScript
      -- typescriptreact = { "prettier" }, -- If you use .tsx
      -- css = { "prettier" },
      -- html = { "prettier" },
      -- json = { "prettier" },
      -- yaml = { "prettier" },
      -- markdown = { "prettier" },
      -- lua = { "stylua" }, -- Example for another language
      -- python = { "isort", "black" }, -- Example with multiple formatters
    },

    -- Optional: Set up format-on-save
    format_on_save = {
      timeout_ms = 500, -- Timeout for formatting
      lsp_fallback = true, -- Fallback to LSP formatting if conform fails
    },

    -- Optional: Configure specific formatters
    formatters = {
      prettier = {
         -- By default, conform.nvim searches for prettier in $PATH,
         -- Mason installs binaries to a path that is usually added to $PATH automatically.
         -- You can also specify the command directly if needed,
         -- but it's often not necessary with Mason.
         -- cmd = "prettier",
         args = { "--stdin-filepath", "$FILENAME" }, -- Pass the filename to prettier
         stdin = true,
      },
      -- Optional: Use prettierd for faster formatting (requires installing prettierd via Mason: `:MasonInstall prettierd`)
      -- prettierd = {
      --   cmd = "prettierd",
      --   args = {"$FILENAME"},
      --   stdin = true,
      -- }
    },
  },
  init = function()
    -- Optional: Add a keymap for manual formatting
    vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Format<CR>', { noremap = true, silent = true, desc = "Format buffer" })
  end,
}
