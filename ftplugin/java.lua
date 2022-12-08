--- @diagnostic disable:unused-local
--- @diagnostic disable:undefined-global
--- @diagnostic disable:missing-parameter
--- @diagnostic disable:undefined-field

-- local util = require('lspconfig.util')
local path = require "utils.api.path"
local lsp = require "vim.lsp"
local jdtls = require "jdtls"

local api = vim.api

local root_markers = { "mvnw", "gradlew", ".git", "pom.xml" }
local root_dir = require("jdtls.setup").find_root(root_markers)

local env = {
    HOME = vim.loop.os_homedir(),
    XDG_CACHE_HOME = os.getenv "XDG_CACHE_HOME",
    JDTLS_JVM_ARGS = os.getenv "JDTLS_JVM_ARGS",
}

-- Using vim.loop.os_uname() to get os information
-- machine = aarch64
-- sysname = linux

function _G.is_aarch64_linux()
    -- body
    return vim.loop.os_uname().machine == "aarch64" and vim.loop.os_uname().sysname == "Linux"
end

function _G.is_windows_x64()
    -- body
    return vim.loop.os_uname().machine == "x86_64" and vim.loop.os_uname().sysname == "Windows_NT"
end

function _G.is_windows_mingw64()
    -- body
    return vim.loop.os_uname().machine == "x86_64" and vim.loop.os_uname().sysname == "MINGW64"
end

function _G.get_tripet(format)
    local tripet1 = ""
    local tripet2 = ""
    if _G.is_aarch64_linux() then
        tripet1 = "linux-arm64"
        tripet2 = "linux-aarch64"
    elseif _G.is_windows_x64() then
        tripet1 = "win32-x64"
        tripet2 = "win32-x86_64"
    end

    return format == 1 and tripet1 or tripet2
end
local tripet = _G.get_tripet(1)
local tripet2 = _G.get_tripet(2)

local function get_runtime_dir()
    local runtime = {
        {
            name = "JavaSE-8",
            path = "/home/Downloads/jdk-8",
        },
        {
            name = "JavaSE-18",
            path = "/home/Downloads/jdk-18",
        },
    }
    if vim.fn.has "win32" == 1 then
        runtime = {
            {
                name = "JavaSE-1.8",
                path = "D:/lib/jdk-8",
            },
            {
                name = "JavaSE-18",
                path = "D:/lib/jdk-18",
            },
        }
    end
    return runtime
end

--- @diagnostic disable-next-line
local function get_cache_dir()
    -- FIXME Locate jdtls file in vscode-insiders extension directories
    local cache_dir = env.HOME .. "/.vscode-insiders/extensions/redhat.java-1.14.2022120603-" .. tripet
    return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or cache_dir
end

--- @diagnostic disable-next-line
local function get_java_cmd()
    -- FIXME Locate jdtls jre file in vscode-insiders extension directories
    local javacmd = path.join(get_cache_dir(), "jre/17.0.5-" .. tripet2, "bin/java")
    if vim.fn.executable(javacmd) then
        return javacmd
    elseif vim.fn.executable(javacmd .. ".exe") then
        return javacmd .. ".exe"
    end
end

--- @diagnostic disable-next-line
local function get_lombok_jar()
    -- FIXME Locate lombok file in proper directory if downloaded from official site
    local java_lombok_jar = path.join(get_cache_dir(), "lombok/lombok-1.18.24.jar")
    -- local java_lombok_jar = env.HOME .. '/.local/jars/lombok.jar'
    return java_lombok_jar
end

--- @diagnostic disable-next-line
local function get_jdtls_cache_dir()
    -- FIXME Locate jdtls file in proper subdirectory such as `jdtls` if dinstalled from official site
    -- local jdtls_cache_dir = path.join(get_cache_dir(), 'jdtls')
    local jdtls_cache_dir = path.join(get_cache_dir(), "server")
    return jdtls_cache_dir
end

--- @diagnostic disable-next-line
local function get_jdtls_config_dir()
    local jdtls_config_dir = path.join(get_jdtls_cache_dir(), "config_linux")
    if vim.fn.has "win32" == 1 then
        jdtls_config_dir = path.join(get_jdtls_cache_dir(), "config_win")
    end
    return jdtls_config_dir
end

--- @diagnostic disable-next-line
local function get_jdtls_workspace_dir()
    return path.join(get_jdtls_cache_dir(), "workspace")
end

--- @diagnostic disable-next-line
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
            env.HOME
                .. "/.vscode-insiders/extensions/vscjava.vscode-java-debug-0.4*.*/server/com.microsoft.java.debug.plugin-*.jar"
        ),
    }
    vim.list_extend(
        jar_patterns,
        vim.split(
            vim.fn.glob(env.HOME .. "/.vscode-insiders/extensions/vscjava.vscode-java-test-0.3*.*/server/*.jar"),
            "\n"
        )
    )
    return jar_patterns
end

-- FIXME
local function get_jar_patterns()
    local jar_patterns = {}
    local plugin_path = path.join(env.HOME, "/.vscode-insiders/extensions/vscjava.vscode-java-test-0.3*.0/server")
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

-- Configure properties

local javacmd = get_java_cmd()
local workspace_folder = path.join(get_jdtls_workspace_dir(), vim.fn.fnamemodify(root_dir, ":p:h:t"))
local equinoxjar = path.join(get_jdtls_cache_dir(), "plugins", "org.eclipse.equinox.launcher_*.jar")
local jdtlsconfig_folder = get_jdtls_config_dir()
local lombok_jar = get_lombok_jar()

-- array of mappings to setup; {<capability_name>, <mode>, <lhs>, <rhs>}
local key_mappings = {
    { "document_formatting", "n", "gq", "<Cmd>lua vim.lsp.buf.formatting()<CR>" },
    { "document_range_formatting", "v", "gq", "<Esc><Cmd>lua vim.lsp.buf.range_formatting()<CR>" },
    { "hover", "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>" },
    { "definition", "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>" },
    { "find_references", "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>" },
    { "implementation", "n", "gD", "<Cmd>lua vim.lsp.buf.implementation()<CR>" },
    { "signature_help", "i", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>" },
    { "workspace_symbol", "n", "gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>" },
    { "code_action", "n", "<a-CR>", "<Cmd>lua vim.lsp.buf.code_action()<CR>" },
    { "code_action", "n", "<leader>r", "<Cmd>lua vim.lsp.buf.code_action { only = 'refactor' }<CR>" },
    { "code_action", "v", "<a-CR>", "<Esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>" },
    { "code_action", "v", "<leader>r", "<Esc><Cmd>lua vim.lsp.buf.range_code_action { only = 'refactor'}<CR>" },
}

local function on_init(client)
    lsp.util.text_document_completion_list_to_complete_items =
        require("lsp_compl").text_document_completion_list_to_complete_items
    if client.config.settings then
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
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
    vim.cmd "augroup lsp_aucmds"
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
    vim.cmd "augroup end"
end

local function on_exit(client, bufnr)
    vim.cmd "augroup lsp_aucmds"
    vim.cmd(string.format("au! * <buffer=%d>", bufnr))
    vim.cmd "augroup end"
end

local function mk_config()
    local capabilities = lsp.protocol.make_client_capabilities()
    capabilities.workspace.configuration = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        flags = {
            debounce_text_changes = 80,
            allow_incremental_sync = true,
        },
        handlers = {},
        capabilities = capabilities,
        on_init = on_init,
        on_attach = on_attach,
        on_exit = on_exit,
        init_options = {},
        settings = {},
    }
end

local config = mk_config()
config.settings = {
    java = {
        configuration = {
            runtimes = get_runtime_dir(),
        },
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
            filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
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
            hashCodeEquals = {
                useJava7Objects = true,
            },
            useBlocks = true,
        },
    },
}
-- FIXME some options like --add-modules=ALL-SYSTEM needs java 17
-- FIXME lombok enabled, with : between -javaagen:lombok.jar
config.cmd = {
    javacmd,
    "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044",
    "-javaagent:" .. lombok_jar,
    "-Xbootclasspath/a:" .. lombok_jar,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(equinoxjar),
    "-configuration",
    jdtlsconfig_folder,
    "-data",
    workspace_folder,
}

config.on_attach = function(client, bufnr)
    -- FIXME Setting dap
    jdtls.setup_dap { hotcodereplace = "auto" }

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

-- Capability setup
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

config.init_options = {
    bundles = get_bundles(),
    extendedClientCapabilities = extendedClientCapabilities,
}

-- -- mute; having progress reports is enough
-- config.handlers["language/status"] = function()
-- end
jdtls.start_or_attach(config)
