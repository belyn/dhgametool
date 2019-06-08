-- Command line was: E:\github\dhgametool\scripts\common\msdkcfg.lua 

local cfg = {}
cfg.upName = "msdk"
cfg.support_takingdata = true
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local director = CCDirector:sharedDirector()
local bcfg = require("common.basesdkcfg")
local popReLogin = function()
  local params = {title = "", body = "\231\153\187\229\189\149\232\191\135\230\156\159\239\188\140\233\156\128\232\166\129\233\135\141\230\150\176\231\153\187\229\189\149", btn_count = 1, btn_text = {1 = "\231\161\174\229\174\154"}, selected_btn = 0, callback = function(l_1_0)
    if l_1_0.selected_btn == 1 then
      l_1_0.button:setEnabled(false)
      local lparams = {which = "logout"}
      local lparamStr = cjson.encode(lparams)
      SDKHelper:getInstance():login(lparamStr, function(l_1_0)
        print("msdk cfg logout data:", l_1_0)
        local director = CCDirector:sharedDirector()
        schedule(director:getRunningScene(), function()
          require("ui.login.home").goUpdate(layer, getVersion())
            end)
         end)
    end
   end}
  local dialog = require("ui.dialog")
  local d = dialog.create(params)
  d.onAndroidBack = function()
   end
  local scene = director:getRunningScene()
  scene:addChild(d, 10000000)
end

local getOrder = function(l_2_0, l_2_1)
  local cfgstore = require("config.store")
  l_2_0.sid = player.sid
  l_2_0.storeid = l_2_0.productId
  l_2_0.device_info = HHUtils:getAdvertisingId() or ""
  l_2_0.body = l_2_0.body or "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_2_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  if cfgstore[l_2_0.productId] then
    l_2_0.body = cfgstore[l_2_0.productId].commodityName
    l_2_0.subject = cfgstore[l_2_0.productId].commodityName
  end
  netClient:gorder(l_2_0, function(l_1_0)
    tablePrint(l_1_0)
    if l_1_0.status ~= 0 then
      delWaitNet()
      popReLogin()
      return 
    end
    if callback then
      callback(l_1_0)
    end
   end)
end

local jsonEncode = bcfg.jsonEncode
local jsonDecode = bcfg.jsonDecode
local loginJson = {}
cfg.login = function(l_3_0, l_3_1)
  loginJson = {}
  local whichtx = userdata.getString(userdata.keys.txwhich, "wx")
  addWaitNet()
  local txparams = {which = whichtx}
  local txparamsstr = jsonEncode(txparams)
  print("msdk login, param is ", whichtx)
  cfg.initGame("")
  cfg.logout("false")
  SDKHelper:getInstance():login(txparamsstr, function(l_1_0)
    print("tx sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    tablePrint(__data)
    delWaitNet()
    if __data and __data.errcode and __data.errcode ~= 0 then
      showToast("\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      showToast("\231\153\187\229\189\149\230\136\144\229\138\159")
      upvalue_1024 = __data
      if loginJson.platform then
        upvalue_1536 = loginJson.platform
        userdata.setString(userdata.keys.txwhich, whichtx)
      end
      local jparams = {platform = whichtx, openkey = __data.accessToken, accessToken = __data.accessToken, openid = __data.openid, pf = __data.pf, pfkey = __data.pf_key, paytoken = __data.payToken}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0, jsonStr = jsonstr, platform = "msdk"}
      print("tx22222 jsonstr:", nparams.jsonStr)
      netClient:thirdlogin(nparams, function(l_2_0)
        delWaitNet()
        print("tx login finish, data is:")
        tablePrint(l_2_0)
        if callback then
          callback(l_2_0)
        end
         end)
    end
   end)
end

cfg.initGame = function(l_4_0, l_4_1)
  print("msdk common initGame data:", data)
  if data and data == "wxcall2" then
    userdata.setString(userdata.keys.txwhich, "wx")
    require("ui.login.home").goUpdate(layer, getVersion())
  elseif data and data == "qqcall2" then
    userdata.setString(userdata.keys.txwhich, "qq")
    require("ui.login.home").goUpdate(layer, getVersion())
  end
  local player = require("data.player")
  if player.uid and player.sid then
    return 
  end
  if data and data == "wxcall" then
    userdata.setString(userdata.keys.txwhich, "wx")
    require("ui.login.home").goUpdate(layer, getVersion())
  elseif data and data == "qqcall" then
    userdata.setString(userdata.keys.txwhich, "qq")
    require("ui.login.home").goUpdate(layer, getVersion())
  end
end

cfg.logout = function(l_5_0, l_5_1)
  SDKHelper:getInstance():logout(l_5_0, function(l_1_0)
    local toaststr = "\231\153\187\229\189\149\229\164\177\232\180\165"
    if l_1_0 and l_1_0 == "2002" then
      toaststr = "\231\153\187\229\189\149\230\142\136\230\157\131\229\164\177\232\180\165"
    end
    local scheduler = require("framework.scheduler")
    scheduler.performWithDelayGlobal(function()
      showToast(toaststr)
      end, 1)
    replaceScene(require("ui.login.home").create())
   end)
end

cfg.pay = function(l_6_0, l_6_1)
  local whichtx = userdata.getString(userdata.keys.txwhich, "wx")
  local oparams = {productId = l_6_0.productId, type = 26, body = userdata.getString(userdata.keys.txwhich, "wx")}
  local extInfo = {openid = loginJson.openid, pf = loginJson.pf, pfKey = loginJson.pfKey, openkey = loginJson.accessToken, sub_platform = whichtx}
  oparams.extInfo = jsonEncode(extInfo)
  getOrder(oparams, function(l_1_0)
    print("tx pay, order info is:")
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local txParams = {zoneId = "1", userId = loginJson.openid, openKey = netOrder.token, pf = loginJson.pf, pfKey = loginJson.pfKey, saveValue = netOrder.price, url_params = netOrder.url_params, isCanChange = false, ysdkExtInfo = ""}
    require("data.takingdata").onChargeReq(netOrder.id, params.productId, netOrder.price / 10, "CNY", 0, "third")
    local paramStr = jsonEncode(txParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      print("pay data:", l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if tdata and tdata.errcode == "-1" then
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        elseif tdata and tdata.errcode == "-2" then
          showToast("\230\148\175\228\187\152\229\143\150\230\182\136")
        elseif tdata and tdata.errcode == "-3" then
          popReLogin()
          return 
        else
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        end
        if callback then
          callback()
        end
        return 
      end
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      require("data.takingdata").onChargeSuc(netOrder.id)
      local gParams = {sid = player.sid, orderid = netOrder.cpOrderId or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      print("client gpay, param is:")
      tablePrint(gParams)
      netClient:gpay(gParams, function(l_1_0)
        print("client gpay back, data is:")
        tablePrint(l_1_0)
        delWaitNet()
        if l_1_0.status ~= 0 then
          showToast("\231\153\187\229\189\149\232\191\135\230\156\159\239\188\140\232\175\183\233\135\141\230\150\176\231\153\187\229\189\149\230\184\184\230\136\143")
          schedule(director:getRunningScene(), function()
            replaceScene(require("ui.login.home").create())
               end)
          return 
        end
        if (l_1_0.reward.equips and  l_1_0.reward.equips > 0) or l_1_0.reward.items and  l_1_0.reward.items > 0 then
          require("data.activity").pay()
        end
        if callback then
          callback(l_1_0.reward)
        end
         end)
      end)
   end)
end

return cfg

