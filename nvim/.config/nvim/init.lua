-- Leader = Space.
-- Never use <leader>i — plain "i" is Insert mode if the map did not register.

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.timeoutlen = 2000

-- Built-in LSP diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "▲", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "●", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "⚑", texthl = "DiagnosticSignHint" })

-- Shorter update time for faster LSP response
vim.opt.updatetime = 300

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- ── Syntax highlighting (colours variables, functions, etc. differently) ──
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "cpp", "lua", "python", "rust", "tsx", "javascript", "typescript", "html", "css", "json", "yaml", "markdown" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ── LSP: code intelligence (go-to-definition, errors, hover, rename) ──────
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "ts_ls", "clangd" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format() end, opts)
        end
      end

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local servers = { "lua_ls", "rust_analyzer", "pyright", "ts_ls", "clangd" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
      vim.lsp.enable(servers)
    end,
  },

  -- ── Autocompletion popup ──────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- buffer words
      "hrsh7th/cmp-path",        -- file paths
      "hrsh7th/cmp-cmdline",     -- cmdline completions
      "L3MON4D3/LuaSnip",        -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- snippet source
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- ── Fidget: subtle LSP status indicator ───────────────────────────────────
  { "j-hui/fidget.nvim", opts = {} },

  -- ── Status line (VS Code-like bottom bar) ────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "auto", component_separators = { left = "", right = "" }, section_separators = { left = "", right = "" } },
    },
  },

  -- ── Tabs at top (like VS Code's tab bar) ─────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- ── Git signs in the gutter (+, ~, -) ────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = { add = { text = "+" }, change = { text = "~" }, delete = { text = "-" }, topdelete = { text = "‾" }, changedelete = { text = "~" } },
    },
  },

  -- ── Keybinding popup (press <space> and wait) ────────────────────────────
  {
    "folke/which-key.nvim",
    opts = {},
  },

  -- ── File explorer as a regular buffer (:Oil) ────────────────────────────
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = { default_file_explorer = true },
    keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" } },
  },

  -- ── Toggle comments with gc ──────────────────────────────────────────────
  { "numToStr/Comment.nvim", opts = {} },

  -- ── Auto-close brackets and quotes ───────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    opts = {},
  },

  -- ── Highlight TODO, FIXME, HACK, etc. ───────────────────────────────────
  {
    "folke/todo-comments.nvim",
    opts = {},
    keys = { { "<leader>t", "<cmd>TodoTelescope<cr>", desc = "Search TODO/FIXME" } },
  },

  -- ── Surround: cs' → ds( → ysiw) ────────────────────────────────────────
  { "kylechui/nvim-surround", opts = {} },

  -- ── Telescope: fuzzy finder ──────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local builtin = require("telescope.builtin")
      require("telescope").setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      })
      require("telescope").load_extension("ui-select")
      local find_files_opts = { hidden = true, no_ignore = false, file_ignore_patterns = { "^%.git/" } }
      vim.keymap.set("n", "<leader>f", function()
        builtin.find_files(find_files_opts)
      end, { desc = "Find files" })
      vim.keymap.set("n", "<leader>r", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Live grep (repo)" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep (repo)" })
      vim.keymap.set("n", "<leader>1", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy in this buffer" })
      vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>0", builtin.resume, { desc = "Telescope resume last picker" })
      vim.keymap.set("n", "<C-p>", function()
        builtin.find_files(find_files_opts)
      end, { desc = "Find files" })
      vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Live grep" })
    end,
  },

  -- ── Markdown preview (browser) ────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown preview (browser)" },
    },
    config = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 1
      vim.g.mkdp_preview_options = {
        sync_scroll_type = "middle",
        disable_filename = 0,
      }
    end,
  },
})

vim.keymap.set("n", "<leader>9", "<cmd>Lazy<cr>", { desc = "Lazy plugin UI" })
vim.keymap.set("n", "<leader>8", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>7", "<cmd>checkhealth<cr>", { desc = "Checkhealth" })

vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Jump list: <C-o> back, <C-i> forward (already built-in, no config needed)

-- Glow: terminal Markdown preview (brew install glow). Space + p in .md only.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd("split | terminal glow -p " .. vim.fn.shellescape(vim.fn.expand("%:p")))
    end, { buffer = ev.buf, desc = "Glow preview (terminal)" })
  end,
})

-- Auto-save on focus lost or pause in insert mode
vim.api.nvim_create_autocmd({ "FocusLost", "CursorHoldI" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! w")
    end
  end,
})

-- Machine-local overrides (not tracked in git)
local local_config = vim.fn.stdpath("config") .. "/init.local.lua"
if vim.uv.fs_stat(local_config) then
  vim.cmd("source " .. local_config)
end
