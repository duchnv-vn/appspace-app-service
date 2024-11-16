---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
-- Load all relevant APIs for this module
-- **************************************************************************
local availableAPIs = {}

local function loadAPIs()
    Calendar = require 'API.Calendar'
    DateTime = require 'API.DateTime'
end
availableAPIs.default = xpcall(loadAPIs, debug.traceback) -- TRUE if all default APIs were loaded correctly

return availableAPIs
-- **************************************************************************
