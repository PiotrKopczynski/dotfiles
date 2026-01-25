local M = {}

function M:setup()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  -- OS agnostic way og creating a workspace directory for jdtls project files (Index, Classpath, Internal metadata, etc)
  local workspace_dir = vim.fn.stdpath 'data' .. package.config:sub(1, 1) .. 'jdtls-workspace' .. package.config:sub(1, 1) .. project_name

  -- 1. Correctly find the Mason installation path
  local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
  local lombok_path = mason_path .. '/jdtls/lombok.jar'
  local bundles = {}

  -- 2. Add java-debug-adapter jars (using glob to handle version numbers)
  local debug_bundle = vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true)
  if debug_bundle ~= '' then
    table.insert(bundles, debug_bundle)
  end

  -- 3. Add java-test jars (multiple jars often exist here)
  local test_bundles = vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar', true)
  if test_bundles ~= '' then
    vim.list_extend(bundles, vim.split(test_bundles, '\n'))
  end

  vim.opt_local.wrap = false

  local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  -- See `:help vim.lsp.start` for an overview of the supported `config` options.
  local config = {
    name = 'jdtls',

    -- `cmd` defines the executable to launch eclipse.jdt.ls.
    -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
    --
    -- As alternative you could also avoid the `jdtls` wrapper and launch
    -- eclipse.jdt.ls via the `java` executable
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
      'jdtls',
      -- Inject lombok as JVM agent
      '--jvm-arg=-javaagent:' .. lombok_path,
      '-data',
      workspace_dir,
    },

    -- `root_dir` must point to the root of your project.
    -- See `:help vim.fs.root`
    root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of optionsp
    settings = {
      java = {
        format = {
          enabled = true,
          settings = {
            url = vim.fn.expand '~/.config/nvim/intellij-java-style.xml',
            profile = 'HomeCookedIntellijStyle',
          },
        },
        debug = {
          settings = {
            stepping = {
              skipClasses = {
                'com.sun.*',
                'sun.*',
                'jdk.internal.*', -- This specifically targets the code you saw
                'org.springframework.*',
                'org.apache.tomcat.*',
                'java.lang.reflect.*',
              },
              skipSynthetics = true,
              skipStaticInitializers = true,
              skipConstructors = false,
            },
          },
        },
      },
    },

    -- This sets the `initializationOptions` sent to the language server
    -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
    -- you'll need to set the `bundles`
    --
    -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    on_attach = function(client, bufnr)
      require('jdtls').setup_dap { hotcodereplace = 'auto' }
      require('jdtls.dap').setup_dap_main_class_configs()

      local dap = require 'dap'
      if not dap.configurations.java then
        dap.configurations.java = {}
      end

      table.insert(dap.configurations.java, {
        type = 'java',
        request = 'attach',
        name = 'Attach Remotely',
        hostName = 'localhost',
        port = 5005,
        projectName = project_name,
      })
    end,
  }
  require('jdtls').start_or_attach(config)
end

return M
