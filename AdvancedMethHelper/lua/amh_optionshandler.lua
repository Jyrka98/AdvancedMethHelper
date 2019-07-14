_G.AdvancedMethHelper = _G.AdvancedMethHelper or {}
AdvancedMethHelper._mod_path = ModPath
AdvancedMethHelper._save_path = SavePath .. "amh.json"
AdvancedMethHelper._config_changed = false
AdvancedMethHelper.Settings = {}

function AdvancedMethHelper:ResetToDefaultValues()
    self.Settings = {
        enabled = true,
        notification_type = 1
    }
end

function AdvancedMethHelper:Load()
    self:ResetToDefaultValues()
    local file = io.open(self._save_path, "r")
    if file then
        for k, v in pairs(json.decode(file:read("*all")) or {}) do
            self.Settings[k] = v
        end
        file:close()
    end
end

function AdvancedMethHelper:Save()
    if not self._config_changed then
        return
    end
    local file = io.open(self._save_path, "w+")
    if file then
        file:write(json.encode(self.Settings))
        file:close()
    end
    self._config_changed = false
end

Hooks:Add(
    "LocalizationManagerPostInit",
    "LocalizationManagerPostInit_AdvancedMethHelper",
    function(loc)
        loc:load_localization_file(AdvancedMethHelper._mod_path .. "loc/en.json")
    end
)

Hooks:Add(
    "MenuManagerInitialize",
    "MenuManagerInitialize_AdvancedMethHelper",
    function(menu_manager)
        MenuCallbackHandler.AdvancedMethHelper_SetEnabled = function(self, item)
            local value = item:value() == "on"
            AdvancedMethHelper.Settings.enabled = value
            AdvancedMethHelper._config_changed = true
        end

        MenuCallbackHandler.AdvancedMethHelper_SetNotificationType = function(self, item)
            local value = item:value()
            AdvancedMethHelper.Settings.notification_type = value
            AdvancedMethHelper._config_changed = true
        end

        MenuCallbackHandler.AdvancedMethHelper_SaveOptions = function(self, item)
            AdvancedMethHelper:Save()
        end

        AdvancedMethHelper:Load()

        MenuHelper:LoadFromJsonFile(
            AdvancedMethHelper._mod_path .. "menu/options.json",
            AdvancedMethHelper,
            AdvancedMethHelper.Settings
        )
    end
)
