local ingredient_dialog = {}
ingredient_dialog["pln_rt1_12"] = "Ingredient added"
ingredient_dialog["pln_rt1_20"] = "Add Muriatic Acid"
ingredient_dialog["pln_rt1_22"] = "Add Caustic Soda"
ingredient_dialog["pln_rt1_24"] = "Add Hydrogen Chloride"
ingredient_dialog["pln_rt1_28"] = "Meth batch is complete"
ingredient_dialog["pln_rat_stage1_20"] = "Add Muriatic Acid"
ingredient_dialog["pln_rat_stage1_22"] = "Add Caustic Soda"
ingredient_dialog["pln_rat_stage1_24"] = "Add Hydrogen Chloride"
ingredient_dialog["pln_rat_stage1_28"] = "Meth batch is complete"

if not _queue_dialog_orig then
    _queue_dialog_orig = DialogManager.queue_dialog
end

function DialogManager:queue_dialog(id, ...)
    if not AdvancedMethHelper.Settings.enabled then
        return _queue_dialog_orig(self, id, ...)
    end

    local same_ingredient = ingredient_dialog[id] == self.last_ingredient

    if ingredient_dialog[id] then
        if AdvancedMethHelper.Settings.notification_type == 1 then --amh_notification_type_message_local
            if same_ingredient then
                return _queue_dialog_orig(self, id, ...)
            end
            managers.chat:_receive_message(1, "AMH", ingredient_dialog[id], tweak_data.system_chat_color)
        elseif AdvancedMethHelper.Settings.notification_type == 2 then --amh_notification_type_message_local_spammy
            managers.chat:_receive_message(1, "AMH", ingredient_dialog[id], tweak_data.system_chat_color)
        elseif AdvancedMethHelper.Settings.notification_type == 3 then --amh_notification_type_midtext
            managers.hud:present_mid_text({text = ingredient_dialog[id], title = "Ingredient", time = 10})
        elseif AdvancedMethHelper.Settings.notification_type == 4 then --amh_notification_type_hint
            managers.hud:show_hint({text = ingredient_dialog[id], time = 10})
        elseif AdvancedMethHelper.Settings.notification_type == 5 then --amh_notification_type_message_public
            if same_ingredient then
                return _queue_dialog_orig(self, id, ...)
            end
            managers.chat:send_message(ChatManager.GAME, "AMH", ingredient_dialog[id])
        elseif AdvancedMethHelper.Settings.notification_type == 6 then --amh_notification_type_message_public_spammy
            managers.chat:send_message(ChatManager.GAME, "AMH", ingredient_dialog[id])
        end
        self.last_ingredient = ingredient_dialog[id]
    end

    return _queue_dialog_orig(self, id, ...)
end
