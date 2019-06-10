-- Command line was: E:\github\dhgametool\scripts\res\i18n.lua 

local i18n = {}
local dirs = {kLanguageEnglish = "us", kLanguageRussian = "ru", kLanguageGerman = "de", kLanguageFrench = "fr", kLanguageSpanish = "es", kLanguagePortuguese = "pt", kLanguageChineseTW = "tw", kLanguageJapanese = "jp", kLanguageKorean = "kr", kLanguageTurkish = "tr", kLanguageChinese = "cn", kLanguageItalian = "it", kLanguageThai = "th"}
if not APP_CHANNEL or APP_CHANNEL == "" or APP_CHANNEL == "AMAZON" then
  dirs[kLanguageMalay] = "ms"
  dirs[kLanguageVietnamese] = "vi"
end
local files = {"global", "buff", "hero", "equip", "item", "help", "faq", "achievement", "fort", "arena", "vipdes", "skill", "mail", "loadingtips", "dailytask", "guildskill", "brave", "herotaskname", "petskill", "spkdrug", "itemgetways", "shortcut"}
local current = nil
i18n.getCurrentLanguage = function()
  return current
end

i18n.getLanguageShortName = function(l_2_0)
  if not l_2_0 then
    l_2_0 = current
  end
  return dirs[l_2_0]
end

i18n.init = function()
  local userdata = require("data.userdata")
  current = userdata.getInt(userdata.keys.language, -1)
  if isAmazon() then
    do return end
  end
  if isOnestore() then
    do return end
  end
  if isChannel() then
    current = kLanguageChinese
  end
  if current == -1 or dirs[current] == nil then
    current = CCApplication:sharedApplication():getCurrentLanguage()
    if dirs[current] == nil then
      current = kLanguageEnglish
    end
  end
  print("current language", current)
  for _,f in ipairs(files) do
    i18n[f] = require(string.format("config.strings.%s.%s", dirs[current], f))
  end
end

i18n.switchLanguage = function(l_4_0)
  if l_4_0 == current or dirs[l_4_0] == nil then
    return 
  end
  current = l_4_0
  local userdata = require("data.userdata")
  userdata.setInt(userdata.keys.language, l_4_0)
  print("current language", current)
  for _,f in ipairs(files) do
    i18n[f] = require(string.format("config.strings.%s.%s", dirs[l_4_0], f))
  end
end

i18n.init()
return i18n

