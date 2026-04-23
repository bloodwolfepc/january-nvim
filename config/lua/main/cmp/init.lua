local function faster_get_path(name)
  local path = vim.tbl_get(package.loaded, "nixCats", "pawsible", "allPlugins", "opt", name)
  if path then
    vim.cmd.packadd(name)
    return path
  end
  return nil
end

---@type fun(names: string[]|string)
local load_w_after_plugin = require('lzextras').make_load_with_afters({ "plugin" }, faster_get_path)

vim.api.nvim_set_hl( 0, "CmpNormal", { bg = "#000000" })
require('lze').load {
  {
    "cmp-buffer",
    for_cat = "cmp",
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp-cmdline",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp-cmdline-history",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp-nvim-lsp",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    dep_of = { "nvim-lspconfig" },
    load = load_w_after_plugin,
  },
  {
    "cmp-nvim-lsp-signature-help",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp-nvim-lua",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp-path",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "cmp_luasnip",
    for_cat = 'cmp',
    on_plugin = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "friendly-snippets",
    for_cat = 'cmp',
    dep_of = { "nvim-cmp" },
  },
  {
    "lspkind.nvim",
    for_cat = 'cmp',
    dep_of = { "nvim-cmp" },
    load = load_w_after_plugin,
  },
  {
    "luasnip",
    for_cat = "cmp",
    dep_of = { "nvim-cmp" },
    after = function()
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local ls = require('luasnip')

      vim.keymap.set({ "i", "s" }, "<M-n>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  {
    "nvim-cmp",
    for_cat = 'cmp',
    event = { "DeferredUIEnter" },
    on_require = { "cmp" },
    after = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local default_sources = {
        { name = "dictionary", keyword_length = 2 },
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "nvim_lsp_signature_help", keyword_length = 3 },
        { name = "calc" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "zsh" },
        { name = "git" },
        { name = "emoji" },
        { name = "cmp-ctags" },
      }
      cmp.setup {
        formatting = {
          format = lspkind.cmp_format {
            mode = 'text',
            with_text = true,
            maxwidth = 50,
            ellipsis_char = '...',
            menu = {
              dictionary = '[DICT]',
              buffer = '[BUF]',
              nvim_lsp = '[LSP]',
              nvim_lsp_signature_help = '[LSP]',
              nvim_lsp_document_symbol = '[LSP]',
              nvim_lua = '[API]',
              path = '[PATH]',
              luasnip = '[SNIP]',
            },
          },
        },
        window = {
          completion = {
            winhighlight = "Normal:CmpNormal",
            border = "single",
            side_padding = 0,
          },
          documentation = {
            winhighlight = "Normal:CmpNormal"
          }
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-S-p>'] = cmp.mapping.scroll_docs(-4),
          ['<C-S-n>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-a>'] = cmp.mapping(
            cmp.mapping.complete({
              config = {
                sources = cmp.config.sources({
                  { name = 'cmp_ai' },
                }),
              },
            }),
            { 'i' }
          ),
        },
        enabled = function()
          return
            vim.bo[0].buftype ~= 'prompt'
          or
            require("cmp_dap").is_dap_buffer()
        end,
        experimental = {
          native_menu = false,
          ghost_text = false,
        },
        sources = default_sources,
      }
      --buffer src for / and ?
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'nvim_lsp_document_symbol' , keyword_length = 3 },
          { name = 'buffer' },
          { name = 'cmdline_history' },
        },
        view = {
          entries = { name = 'wildmenu', separator = '|' },
        },
      })
      --cmp for :
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'cmdline' },
          { name = 'cmdline_history' },
          { name = 'path' },
        },
      })
      cmp.setup.filetype('lua', {
        sources = vim.list_extend(
          default_sources,
          {
            { name = "nvim_lua" },
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' },
              }
            }
          }
        )
      })
      cmp.setup.filetype('markdown', {
        sources = vim.list_extend(
          {
            { name = "vimwiki-tags" },
          },
          default_sources
        )
      })
      cmp.setup.filetype("latex", {
        sources = vim.list_extend(
          {
            { name = "latex_symbols" },
          },
          default_sources
        )
      })
      cmp.setup.filetype("lilypad", {
        sources = vim.list_extend(
          {
            { name = "dictionary", keyword_length = 2 },
          },
          default_sources
        )
      })
      cmp.setup.filetype(
        {"dap-repl", "dapui_wattches", "dapui_hover"}, {
        sources = vim.list_extend(
          default_sources,
          {
            { name = "dap" },
          }
        )
      })
    end,
  },
  {
    "cmp-dictionary",
    for_cat = 'cmp',
    load = load_w_after_plugin,
    after = function()
      local lilydictpath = os.getenv("LILYDICTPATH")
      require("cmp_dictionary").setup({
        paths = {
          lilydictpath .. "/grobs",
          lilydictpath .. "/keywords",
          lilydictpath .. "/musicFunctions",
          lilydictpath .. "/articulations",
          lilydictpath .. "/grobProperties",
          lilydictpath .. "/paperVariables",
          lilydictpath .. "/headerVariables",
          lilydictpath .. "/contextProperties",
          lilydictpath .. "/clefs",
          lilydictpath .. "/repeatTypes",
          lilydictpath .. "/languageNames",
          lilydictpath .. "/accidentalsStyles",
          lilydictpath .. "/scales",
          lilydictpath .. "/musicCommands",
          lilydictpath .. "/markupCommands",
          lilydictpath .. "/contextsCmd",
          lilydictpath .. "/dynamics",
          lilydictpath .. "/contexts",
          lilydictpath .. "/translators",
        },
        exact_length = 2
       })
    end,
  },
  {
    "cmp-zsh",
    for_cat = 'cmp',
    load = load_w_after_plugin,
    after = function()
      require("cmp_zsh").setup {
        zshrc = true
      }
    end
  },
  {
    "cmp-vimwiki-tags",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-latex-symbols",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "luasnip-latex-snippets.nvim",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-ai",
    for_cat = 'cmp',
    load = load_w_after_plugin,
    after = function()
      local cmp_ai = require("cmp_ai.config")
        cmp_ai:setup({
          max_lines = 1000,
          provider = "OpenAI",
          provider_options = {
            model = "gpt-4",
          },
          notify = true,
          notify_callback = function(msg)
            vim.notify(msg)
          end,
        })
    end,
  },
  {
    "cmp-dap",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-git",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-calc",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-emoji",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
  {
    "cmp-ctags",
    for_cat = 'cmp',
    load = load_w_after_plugin,
  },
}
