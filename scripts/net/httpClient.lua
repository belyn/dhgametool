-- Command line was: E:\github\dhgametool\scripts\net\httpClient.lua 

local httpClient = {}
local cjson = json
local fileOpt = require("common.fileOpt")
local LOG_REPORT_KEY = "fbiubi9gewaga=niu1n3091mlnoahgawng"
httpClient.download = function(l_1_0, l_1_1)
  local url = l_1_0.url
  local method = l_1_0.method or "GET"
  local out_filename = l_1_0.out_filename or ""
  local request = network.createHTTPRequest(function(l_1_0)
    local _request = l_1_0.request
    if l_1_0.name == "completed" and _request:getResponseStatusCode() == 200 and callback then
      callback({status = 0, data = _request:getResponseData()})
    end
   end, url, method)
  request:setTimeout(1000)
  request:start()
end

httpClient.reportException = function(l_2_0, l_2_1)
  local request = network.createHTTPRequest(function(l_1_0)
   end, l_2_0, "POST")
  local currTime = os.time() .. tostring({}):sub(8)
  local authorization = crypto.md5(LOG_REPORT_KEY .. currTime, false)
  request:addRequestHeader("Authorization:" .. authorization)
  request:addRequestHeader("Date:" .. currTime)
  request:addPOSTValue("data", l_2_1)
  request:setTimeout(1000)
  request:start()
end

local targetLgg = {kLanguageEnglish = "en", kLanguageRussian = "ru", kLanguageGerman = "de", kLanguageFrench = "fr", kLanguageSpanish = "es", kLanguagePortuguese = "pt", kLanguageChineseTW = "zh-TW", kLanguageJapanese = "ja", kLanguageKorean = "k0", kLanguageTurkish = "tr", kLanguageChinese = "zh-CN", kLanguageItalian = "it", kLanguageThai = "th"}
httpClient.trans = function(l_3_0, l_3_1)
  local i18n = require("res.i18n")
  local curLgg = i18n.getCurrentLanguage()
  local key = "empty"
  local target = targetLgg[curLgg] or "en"
  local url = "https://www.googleapis.com/language/translate/v2?key=" .. key .. "&target=" .. target .. "&q=" .. string.urlencode(l_3_0)
  httpClient.download({url = url}, function(l_1_0)
    if l_1_0.status == 0 then
      local res = cjson.decode(l_1_0.data)
      local translatedText = res.data.translations[1].translatedText
      if callback then
        callback(translatedText)
    end
   end)
end

httpClient.userAction = function(l_4_0)
  local uid = require("data.player").uid or "0"
  local game = require("ui.login.update").getPackageName() or "unknown"
  if not l_4_0 then
    l_4_0 = "unknown"
  end
  local url = "http://www.chockly.top/userAction/" .. uid .. "/" .. game .. "/" .. l_4_0
  local request = network.createHTTPRequest(function(l_1_0)
   end, url, "GET")
  request:setTimeout(1000)
  request:start()
end

return httpClient

