return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- Configure mason for managing LSP servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Programming languages
          "lua_ls",        -- Lua
          "ts_ls",         -- TypeScript (using the new name instead of tsserver)
          "pyright",       -- Python
          "ruff_lsp",      -- Python linter and formatter
          "bashls",        -- Bash
          "fish",          -- Fish shell
          
          -- Web development
          "html",          -- HTML
          "cssls",         -- CSS
          "jsonls",        -- JSON
          
          -- Unix configuration files
          "yamlls",        -- YAML
          "taplo",         -- TOML
          "marksman",      -- Markdown
          "dockerls",      -- Dockerfile
          "docker_compose_language_service", -- Docker Compose
          "nixd",          -- Nix
        },
        automatic_installation = true,
      })

      -- Configure LSP servers
      local lspconfig = require("lspconfig")
      
      -- Setup lua_ls for Neovim Lua development
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { 
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      
      -- Setup TypeScript language server (using ts_ls instead of tsserver)
      lspconfig.ts_ls.setup({
        -- You can add custom settings here if needed
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
      })
      
      -- Setup Python language servers
      lspconfig.pyright.setup({})
      lspconfig.ruff_lsp.setup({
        init_options = {
          settings = {
            -- Configure ruff settings here
            lint = {
              run = "onSave",
            },
          },
        },
      })
      
      -- Setup shell language servers
      lspconfig.bashls.setup({})
      lspconfig.fish.setup({})
      
      -- Setup web development language servers
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
      lspconfig.jsonls.setup({})
      
      -- Setup configuration file language servers
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
              ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
              ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
            },
          },
        },
      })
      lspconfig.taplo.setup({}) -- TOML
      lspconfig.marksman.setup({}) -- Markdown
      lspconfig.dockerls.setup({})
      lspconfig.docker_compose_language_service.setup({})
      lspconfig.nixd.setup({})
      
      -- Global mappings
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end,
  },
  
  -- Mason for managing external tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  },
}
