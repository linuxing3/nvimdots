--- @diagnostic disable:unused-local
--- @diagnostic disable:undefined-global
--- @diagnostic disable:missing-parameter
--- @diagnostic disable:undefined-field

local lsp = require("vim.lsp")
local jdtls = require("jdtls")
local util = require("lspconfig.util")
local handlers = require("vim.lsp.handlers")

local env = {
    HOME = vim.loop.os_homedir(),
    XDG_CACHE_HOME = os.getenv("XDG_CACHE_HOME"),
    JDTLS_JVM_ARGS = os.getenv("JDTLS_JVM_ARGS"),
}

local function get_cache_dir()
    return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, ".cache")
end

local function get_jdtls_cache_dir()
    return util.path.join(get_cache_dir(), "jdtls")
end

local function get_jdtls_config_dir()
    return util.path.join(env.HOME, "/Downloads/java/jdtls/config_linux")
end

local function get_jdtls_workspace_dir()
    return util.path.join(get_jdtls_cache_dir(), "workspace", vim.fn.fnamemodify(root_dir, ":p:h:t"))
end

local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((env.JDTLS_JVM_ARGS or ""), "%S+") do
        local arg = string.format("--jvm-arg=%s", a)
        table.insert(args, arg)
    end
    return unpack(args)
end

-- Bundles Setup
-- FIXME java-debug installation
--
--     Clone java-debug
--     Navigate into the cloned repository (cd java-debug)
--     Run ./mvnw clean install
--     Set or extend the initializationOptions (= init_options of the config from configuration) as follows:
-- Enable main class detect
-- To discover the main classes you have to call require('jdtls.dap').setup_dap_main_class_configs()
-- or use the JdtRefreshDebugConfigs command. It will only discover classes once eclipse.jdt.ls fully
-- FIXME vscode-java-test installation
-- To be able to debug junit tests, it is necessary to install the bundles from vscode-java-test:
--     Clone the repository
--     Navigate into the folder (cd vscode-java-test)
--     Run npm install
--     Run npm run build-plugin
--     Extend the bundles in the nvim-jdtls config:
-- FIXME
-- care about the vs extension update version, better to use widecard

local function get_bundles()
    local jar_patterns = {
        vim.fn.glob(
            env.HOME -- ~/.vscode/extensions/vscjava.vscode-java-debug-0.52.0/
                .. "/.vscode/extensions/vscjava.vscode-java-debug-0.52.0/com.microsoft.java.debug.plugin-*.jar"
        ),
    }
    vim.list_extend(
        jar_patterns,
        vim.split(
            -- ~/.vscode/extensions/vscjava.vscode-java-test-0.39.0
            vim.fn.glob(env.HOME .. "/.vscode/extensions/vscjava.vscode-java-test-0.39/server/*.jar"),
            "\n"
        )
    )
    return jar_patterns
end

-- FIXME
local function get_jar_patterns()
    local jar_patterns = {}
    local plugin_path = path.join(env.HOME, "/.vscode/extensions/vscjava.vscode-java-test-0.39/server")
    local bundle_list = vim.tbl_map(function(x)
        return path.join(plugin_path, x)
    end, {
        "com.microsoft.java.test.plugin*.jar",
        -- 'com.microsoft.java.test.runner-jar-with-dependencies.jar',
        "org.apiguardian*.jar",
        "org.eclipse.jdt.junit4.runtime_*.jar",
        "org.eclipse.jdt.junit5.runtime_*.jar",
        "org.junit.jupiter.api*.jar",
        "org.junit.jupiter.engine*.jar",
        "org.junit.jupiter.migrationsupport*.jar",
        "org.junit.jupiter.params*.jar",
        "org.junit.platform.commons*.jar",
        "org.junit.platform.engine*.jar",
        "org.junit.platform.launcher*.jar",
        "org.junit.platform.runner*.jar",
        "org.junit.platform.suite.api*.jar",
        "org.junit.vintage.engine*.jar",
        "org.opentest4j*.jar",
    })
    vim.list_extend(jar_patterns, bundle_list)
    return jar_patterns
end

local root_files = {
    -- Single-module projects
    {
        "build.xml", -- Ant
        "pom.xml", -- Maven
        "settings.gradle", -- Gradle
        "settings.gradle.kts", -- Gradle
    },
    -- Multi-module projects
    { "build.gradle", "build.gradle.kts" },
}

local function on_init(client)
    lsp.util.text_document_completion_list_to_complete_items =
        require("lsp_compl").text_document_completion_list_to_complete_items
    if client.config.settings then
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
end

local function on_attach_extra(client, bufnr)
    -- FIXME Setting dap
    jdtls.setup_dap({ hotcodereplace = "auto" })

    -- commands and keys
    jdtls.setup.add_commands()
    local opts = { silent = true, buffer = bufnr }

    vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
    vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
    vim.keymap.set("n", "<leader>dm", [[<ESC><CMD>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>]], opts)

    vim.keymap.set("n", "<A-o>", jdtls.organize_imports, opts)
    vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
    vim.keymap.set("v", "crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
    vim.keymap.set("n", "crc", jdtls.extract_constant, opts)
end

local function on_attach(client, bufnr, attach_opts)
    require("lsp_compl").attach(client, bufnr, attach_opts)
    api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    api.nvim_buf_set_option(bufnr, "bufhidden", "hide")

    if client.resolved_capabilities.goto_definition then
        api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end
    local opts = { silent = true }
    for _, mappings in pairs(key_mappings) do
        local capability, mode, lhs, rhs = unpack(mappings)
        if client.resolved_capabilities[capability] then
            api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end
    end
    api.nvim_buf_set_keymap(bufnr, "n", "crr", "<Cmd>lua vim.lsp.buf.rename(vim.fn.input('New Name: '))<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "i", "<c-n>", "<Cmd>lua require('lsp_compl').trigger_completion()<CR>", opts)
    vim.cmd("augroup lsp_aucmds")
    vim.cmd(string.format("au! * <buffer=%d>", bufnr))
    if client.resolved_capabilities["document_highlight"] then
        vim.cmd(string.format("au CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()", bufnr))
        vim.cmd(string.format("au CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()", bufnr))
        vim.cmd(string.format("au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()", bufnr))
    end
    if vim.lsp.codelens and client.resolved_capabilities["code_lens"] then
        api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
        api.nvim_buf_set_keymap(bufnr, "n", "<leader>ce", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
    end
    vim.cmd("augroup end")

    on_attach_extra()
end

local function on_exit(client, bufnr)
    vim.cmd("augroup lsp_aucmds")
    vim.cmd(string.format("au! * <buffer=%d>", bufnr))
    vim.cmd("augroup end")
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.workspace.configuration = true
capabilities.textDocument.completion.completionItem.snippetSupport = true

local root_markers = { "mvnw", "gradlew", ".git", "pom.xml" }
local root_dir = require("jdtls.setup").find_root(root_markers)

local settings = {
    -- ['java.format.settings.url'] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
    -- ['java.format.settings.profile'] = "GoogleStyle",
    java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
        },
        -- configuration = {
        --     runtimes = {
        --         {
        --             name = "JavaSE-17",
        --             path = env.HOME ..
        --             "/.vscode-insiders/extensions/redhat.java-1.18.2023041704-linux-x64/jre/17.0.6-linux-x86_64",
        --         },
        --         {
        --             name = "JavaSE-8",
        --             path = env.HOME .. "/lib/jdk/8/",
        --         },
        --     }
        -- },
    },
}

-- UI
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
    local opts = {}
    pickers
        .new(opts, {
            prompt_title = prompt,
            finder = finders.new_table({
                results = items,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = label_fn(entry),
                        ordinal = label_fn(entry),
                    }
                end,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            attach_mappings = function(prompt_bufnr)
                actions.goto_file_selection_edit:replace(function()
                    local selection = actions.get_selected_entry(prompt_bufnr)
                    actions.close(prompt_bufnr)

                    cb(selection.value)
                end)

                return true
            end,
        })
        :find()
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
    cmd = {
        "jdtls",
        "-configuration",
        get_jdtls_config_dir(),
        "-data",
        get_jdtls_workspace_dir(),
        get_jdtls_jvm_args(),
    },
    capabilities = capabilities,
    filetypes = { "java" },
    root_dir = root_dir,
    single_file_support = true,
    on_init = on_init,
    on_attach = on_attach,
    on_exit = on_exit,
    settings = settings,
    init_options = {
        extendedClientCapabilities = extendedClientCapabilities,
    },
}

jdtls.start_or_attach(config)
