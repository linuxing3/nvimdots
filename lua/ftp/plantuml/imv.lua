local utils = require("ftp.plantuml.utils")

local M = {}

M.Renderer = {}

function M.Renderer:new()
    self.__index = self
    return setmetatable({ tmp_file = vim.fn.tempname() .. ".png", pid = 0 }, self)
end

function M.Renderer:render(file)
    -- self:_start_server()
    -- self:_refresh_image(file)
    self:_gen_image(file)
end

function M.Renderer:_start_server()
    -- Use imv server's PID to check if it already has started:
    -- Set the PID the first time imv starts and only clear it when it exits.
    if self.pid == 0 then
        self.pid = utils.Command:new("imv"):start(function(_)
            self.pid = 0
        end)
    end
end

function M.Renderer:_refresh_image(file)
    -- 1. Run PlantUML to generate an image file from the current file.
    self.tmp_file = string.gsub(file, "^(%w+)\\.(%w+)$", "%1") .. ".png"
    utils.Command:new(string.format("plantuml -pipe < %s > %s", file, self.tmp_file)):start(function(_)
        -- 2. Tell imv to close all previously opened files.
        if self.pid ~= 0 then
            -- utils.Command:new(string.format("imv-msg %d close all open %s", self.pid, self.tmp_file)):start()
            vim.system({ "imv-msg", self.pid, "close", "all", "open", self.tmp_file })
        else
            vim.system({ "imv", self.tmp_file })
        end
    end)
end

function M.Renderer:_gen_image(file)
    local image_file = string.gsub(file, "^(%w+)\\.(%w+)$", "%1") .. ".png"
    vim.system({ "pkill", "imv" })
    utils.Command:new(string.format("plantuml -pipe < %s > %s", file, image_file)):start(function(_)
        vim.system({ "imv", image_file })
        -- vim.system({ "imv-msg", self.pid, "close", "all", "open", image_file })
        -- utils.Command:new(string.format("imv-msg %d close all", self.pid)):start(function(_)
        --     utils.Command:new(string.format("imv-msg %d open %s", self.pid, image_file)):start()
        -- end)
    end)
end
return M
