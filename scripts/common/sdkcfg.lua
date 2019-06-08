-- Command line was: E:\github\dhgametool\scripts\common\sdkcfg.lua 

local cfg = {}
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local cfgMap = {}
cfgMap.TX = "common.txsdkcfg"
cfgMap.UC = "common.ucsdkcfg"
cfgMap.ALI = "common.alisdkcfg"
cfgMap.HW = "common.hwsdkcfg"
cfgMap.AMIGO = "common.amigosdkcfg"
cfgMap.OPPO = "common.opposdkcfg"
cfgMap.BAIDU = "common.baidusdkcfg"
cfgMap.M4399 = "common.m4399sdkcfg"
cfgMap.MZW = "common.mzwsdkcfg"
cfgMap.ALYX = "common.alyxsdkcfg"
cfgMap.KAOPU = "common.kaopusdkcfg"
cfgMap.XM = "common.xmsdkcfg"
cfgMap["360"] = "common.360sdkcfg"
cfgMap.VIVO = "common.vivosdkcfg"
cfgMap.MZ = "common.mzsdkcfg"
cfgMap.MRGAME = "common.mrgamesdkcfg"
cfgMap.KP = "common.kpsdkcfg"
cfgMap.LX = "common.lenovosdkcfg"
cfgMap.GAMES63 = "common.games63sdkcfg"
cfgMap.GAMES37 = "common.games37sdkcfg"
cfgMap.GAMEUSDK = "common.gameusdkcfg"
cfgMap.DL = "common.danglesdkcfg"
cfgMap.CHUDONG = "common.chudongsdkcfg"
cfgMap.AMAZON = "common.amazonsdkcfg"
cfgMap.ONESTORE = "common.onestoresdkcfg"
cfgMap.MSDK = "common.msdkcfg"
cfgMap.WUFAN = "common.wufansdkcfg"
cfgMap.SAMSUNG = "common.samsungsdkcfg"
cfgMap.PLAY800 = "common.play800sdkcfg"
cfgMap["6KW"] = "common.6kwsdkcfg"
cfgMap["6KWYYB"] = "common.6kwyybsdkcfg"
if APP_CHANNEL and APP_CHANNEL ~= "" and cfgMap[APP_CHANNEL] then
  cfg[APP_CHANNEL] = require(cfgMap[APP_CHANNEL])
end
return cfg

