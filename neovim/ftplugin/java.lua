-- vim.cmd(':Minimap')
vim.cmd(':hi minimapCursor guibg=#403d52')
vim.cmd(':hi minimapRange guibg=#30313e')

--vim.api.nvim_create_autocmd(
--	"CursorHold", 
--	{ pattern = "*", command = "lua vim.diagnostic.open_float({ border = 'single', focusable = false })" }
--)
--vim.api.nvim_create_autocmd(
--	"CursorHoldI", 
--	{ pattern = "*", command = "silent! lua vim.lsp.buf.signature_help()" }
--)	

vim.o.updatetime = 4000

local directory = '/home/hjgarrett/.local/share/nvimJdtlsWorkspaces/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
-- print('Project name: ' .. directory)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local config = {
  cmd = {
    'java', 

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', '/home/hjgarrett/.local/lib/eclipse.jdt.ls/latest/plugins/org.eclipse.equinox.launcher_1.6.800.v20240304-1850.jar',
    '-configuration', '/home/hjgarrett/.local/lib/eclipse.jdt.ls/latest/config_linux/',

    -- See `data directory configuration` section in the README
    '-data', directory
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.xml', '.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },

  capabilities = capabilities,
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
vim.keymap.set({'i', 'n'}, '<S-A-o>', function() return require('jdtls').organize_imports() end)

-- vim.cmd(':OutlineOpen!')
