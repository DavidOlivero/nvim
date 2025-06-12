-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      angularls = {
        on_new_config = function(new_config, new_root_dir)
          -- Función para registrar información en variables globales sin mostrar mensajes
          local function silent_log(name, value)
            vim.api.nvim_set_var("angular_lsp_" .. name, value)
          end
          
          local function get_probe_dir(root_dir)
            local project_root = require("lspconfig.util").find_node_modules_ancestor(root_dir)
            return project_root and (project_root .. "/node_modules") or ""
          end

          -- Intentamos encontrar el directorio global de npm
          local function get_npm_global_dir()
            local handle = io.popen("npm config get prefix")
            if not handle then return nil end
            
            local result = handle:read("*a")
            handle:close()
            
            if not result then return nil end
            
            -- Limpiar cualquier espacio en blanco o nueva línea
            result = result:gsub("%s+$", "")
            
            -- Para sistemas Unix/Linux/Mac
            local lib_path = result .. "/lib/node_modules"
            if vim.loop.fs_stat(lib_path) then
              return lib_path
            end
            
            -- Para Windows
            local win_path = result .. "/node_modules"
            if vim.loop.fs_stat(win_path) then
              return win_path
            end
            
            return nil
          end

          -- Obtener versión de Angular sin depender de JQ
          local function get_angular_core_version(root_dir)
            -- IMPORTANTE: Establecer esto a la versión EXACTA de tu proyecto
            -- Ver el resultado de `npm list @angular/core` para saber la versión exacta
            local fallback_version = "17.2.0" -- Ajusta esto a tu versión de Angular
            
            local project_root = require("lspconfig.util").find_node_modules_ancestor(root_dir)
            if not project_root then
              silent_log("error_root", "No se pudo encontrar la raíz del proyecto Angular")
              return fallback_version
            end

            local package_json = project_root .. "/package.json"
            if not vim.loop.fs_stat(package_json) then
              silent_log("error_pkg", "No se encontró package.json en " .. project_root)
              return fallback_version
            end

            -- Intentar leer el archivo package.json directamente
            local success, content = pcall(function()
              local file = io.open(package_json, "r")
              if not file then return nil end
              local content = file:read("*all")
              file:close()
              return content
            end)

            if not success or not content then
              silent_log("error_read", "No se pudo leer package.json")
              return fallback_version
            end

            -- Buscar la versión de Angular
            local angular_version = content:match('"@angular/core"%s*:%s*"([^"]+)"')
            if angular_version then
              -- Limpiar la versión (eliminar ^, ~, etc.)
              angular_version = angular_version:gsub("^%^", ""):gsub("^~", "")
              return angular_version
            end

            return fallback_version
          end

          local probe_dir = get_probe_dir(new_root_dir)
          local angular_core_version = get_angular_core_version(new_root_dir)
          
          -- Registrar información silenciosamente sin mostrar nada al usuario
          silent_log("core_version", angular_core_version)
          silent_log("probe_dir", probe_dir)
          
          -- Preparar lista de directorios de sondeo
          local probe_locations = {probe_dir}
          
          -- Añadir directorio npm global
          local npm_global_dir = get_npm_global_dir()
          if npm_global_dir then
            table.insert(probe_locations, npm_global_dir)
            silent_log("npm_global", npm_global_dir)
          end
          
          -- Añadir la instalación directa de Mason
          local mason_dir = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules"
          if vim.loop.fs_stat(mason_dir) then
            table.insert(probe_locations, mason_dir)
            silent_log("mason_dir", mason_dir)
          end
          
          -- Inicializar el comando base
          new_config.cmd = {"ngserver", "--stdio"}
          
          -- Añadir los directorios de sondeo como cadenas individuales
          table.insert(new_config.cmd, "--tsProbeLocations")
          table.insert(new_config.cmd, table.concat(probe_locations, ","))
          
          table.insert(new_config.cmd, "--ngProbeLocations")
          table.insert(new_config.cmd, table.concat(probe_locations, ","))
          
          -- Sólo añadir --angularCoreVersion si tenemos una versión válida
          if angular_core_version and angular_core_version ~= "" then
            table.insert(new_config.cmd, "--angularCoreVersion")
            table.insert(new_config.cmd, angular_core_version)
          end
          
          -- Guardar el comando para depuración (accesible vía :lua print(vim.g.angular_lsp_cmd))
          silent_log("cmd", table.concat(new_config.cmd, " "))
        end,
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
