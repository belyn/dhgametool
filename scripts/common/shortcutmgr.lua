-- Command line was: E:\github\dhgametool\scripts\common\shortcutmgr.lua 

local ShortcutManager = {}
local i18n = require("res.i18n")
ShortcutManager.ActionEnum = {SIGN = 1, TASK = 2, DARE = 3}
local SHORTCUT_ACTIVITY_TYPE = "com.droidhang.ad.action"
ShortcutManager.registShortcutListener = function(l_1_0)
  if HHUtils.registShortcutListener == nil then
    return 
  end
  HHUtils:registShortcutListener(l_1_0)
end

ShortcutManager.unregistShortcutListener = function()
  if HHUtils.unregistShortcutListener == nil then
    return 
  end
  HHUtils:unregistShortcutListener()
end

ShortcutManager.donateShortcut = function(l_3_0)
  if HHUtils.donateUserActivity == nil then
    return 
  end
  if i18n.shortcut[l_3_0] == nil then
    return 
  end
  local shortcutId = ShortcutManager.getShortcutFullId(l_3_0)
  HHUtils:donateUserActivity(shortcutId, i18n.shortcut[l_3_0].pushTitle, i18n.shortcut[l_3_0].pushDescription, i18n.shortcut[l_3_0].voiceText, "{}")
end

ShortcutManager.addVoiceShortcut = function(l_4_0, l_4_1)
  if HHUtils.addVoiceShortcutWithUserActivity == nil then
    return 
  end
  if i18n.shortcut[l_4_0] == nil then
    return 
  end
  local shortcutId = ShortcutManager.getShortcutFullId(l_4_0)
  HHUtils:addVoiceShortcutWithUserActivity(shortcutId, i18n.shortcut[l_4_0].pushTitle, i18n.shortcut[l_4_0].pushDescription, i18n.shortcut[l_4_0].voiceText, l_4_1, "{}")
end

ShortcutManager.setShortcutSuggestions = function(l_5_0)
  if HHUtils.setShortcutSuggestions == nil then
    return 
  end
  HHUtils:setShortcutSuggestions(l_5_0)
end

ShortcutManager.deleteShortcutWithIdentifiers = function(l_6_0)
  if HHUtils.deleteSavedUserActivitiesWithIdentifiers == nil then
    return 
  end
  if i18n.shortcut[l_6_0] == nil then
    return 
  end
  local shortcutId = ShortcutManager.getShortcutFullId(l_6_0)
  HHUtils:deleteSavedUserActivitiesWithIdentifiers(shortcutId)
end

ShortcutManager.deleteAllSavedShortcuts = function()
  if HHUtils.deleteAllSavedUserActivities == nil then
    return 
  end
  HHUtils:deleteAllSavedUserActivities()
end

ShortcutManager.getAllVoiceShortcuts = function(l_8_0)
  if HHUtils.getAllVoiceShortcuts == nil then
    return 
  end
  HHUtils:getAllVoiceShortcuts(l_8_0)
end

ShortcutManager.isVoiceShortcutAdded = function(l_9_0, l_9_1)
  if HHUtils.isVoiceShortcutAdded == nil then
    return 
  end
  if i18n.shortcut[l_9_0] == nil then
    return 
  end
  local shortcutId = ShortcutManager.getShortcutFullId(l_9_0)
  HHUtils:isVoiceShortcutAdded(shortcutId, l_9_1)
end

ShortcutManager.getShortcutFullId = function(l_10_0)
  return SHORTCUT_ACTIVITY_TYPE .. l_10_0
end

return ShortcutManager

