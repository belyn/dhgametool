-- Command line was: E:\github\dhgametool\scripts\ui\login\auth.lua 

local auth = {}
require("common.const")
require("common.func")
local i18n = require("res.i18n")
local netClient = require("net.netClient")
local userdata = require("data.userdata")
local bcfg = require("common.basesdkcfg")
local jsonEncode = bcfg.jsonEncode
local jsonDecode = bcfg.jsonDecode
auth.start = function(l_1_0, l_1_1, l_1_2)
  if not l_1_0 then
    l_1_0 = {}
  end
  if not l_1_0.account then
    local acct = userdata.getString(userdata.keys.account)
  end
  if not l_1_0.password then
    local pswd = userdata.getEncryptString(userdata.keys.password)
  end
  local net = op3(l_1_0.new, netClient:new(), netClient)
  local connect = op3(l_1_0.new, net.newConnect, net.connect)
  local m = {}
  m.connect = function()
    m.setHint(i18n.global.connect_gate_server.string)
    local gate = require("ui.login.gate").get()
    connect(net, {host = gate.host, port = gate.port}, function()
      if acct == "" or pswd == "" then
        m.setHint(i18n.global.register_account.string)
        require("version")
        local osversion = ""
        osversion = not HHUtils.getOSVersion or HHUtils:getOSVersion() or ""
        local reg_params = {sid = 0, rdid = HHUtils:getAdvertisingId() or "", appversion = VERSION_CODE, osversion = osversion}
        net:reg(reg_params, function(l_1_0)
          m.setHint(i18n.global.register_account_ok.string)
          upvalue_1024 = l_1_0.account
          upvalue_1536 = l_1_0.password
          userdata.setString(userdata.keys.account, acct)
          userdata.setEncryptString(userdata.keys.password, pswd)
          userdata.setBool(userdata.keys.accountFormal, false)
          m.salt()
          require("data.toutiao").eventRegister("visitor")
            end)
      else
        m.salt()
      end
      end)
   end
  m.thirdConnect = function()
    m.setHint(i18n.global.connect_gate_server.string)
    local gate = require("ui.login.gate").get()
    connect(net, {host = gate.host, port = gate.port}, function()
      m.thirdLogin()
      end)
   end
  m.salt = function()
    m.setHint(i18n.global.auth_account.string)
    net:salt({sid = 0, account = acct}, function(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -1 then
          m.setHint(i18n.global.error_account_passwd.string)
          m.onFinish(i18n.global.error_account_passwd.string)
        else
          m.setHint(i18n.global.auth_account_fail.string .. " salt:" .. l_1_0.status)
          m.onFinish(i18n.global.auth_account_fail.string .. " salt:" .. l_1_0.status)
        end
        return 
      end
      print("uid", l_1_0.uid)
      m.login(l_1_0.uid, l_1_0.salt)
      end)
   end
  m.login = function(l_4_0, l_4_1)
    local checksum = crypto.md5(l_4_1 .. "rwmkxhgi6;578i650" .. pswd)
    local lParam = {sid = 0, checksum = checksum, idfa = HHUtils:getAdvertisingId(), keychain = HHUtils:getUniqKC(), idfv = HHUtils:getUniqFv()}
    net:login(lParam, function(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -1 then
          m.setHint(i18n.global.error_account_passwd.string)
          m.onFinish(i18n.global.error_account_passwd.string)
        elseif l_1_0.status == -2 then
          m.setHint(i18n.global.acct_ban.string)
          m.onFinish(i18n.global.acct_ban.string)
        else
          m.setHint(i18n.global.auth_account_fail.string .. " login:" .. l_1_0.status)
          m.onFinish(i18n.global.auth_account_fail.string .. " login:" .. l_1_0.status)
        end
        return 
      end
      if param and param.extra and param.extra.uid then
        upvalue_1536 = param.extra.uid
      elseif l_1_0 and l_1_0.uid then
        upvalue_1536 = l_1_0.uid
      end
      print("data.sid", l_1_0.sid)
      print("param.sid", param.sid)
      print("data.uid", l_1_0.uid)
      if not param.sid then
        m.auth(uid, l_1_0.session, l_1_0.sid)
      end
      end)
   end
  m.thirdLogin = function()
    local sdkcfg = require("common.sdkcfg")
    if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].login then
      sdkcfg[APP_CHANNEL].login({}, function(l_1_0)
      if not l_1_0.createTs then
        userdata.createTs = l_1_0.status ~= 0 or 0
      end
      local uid = l_1_0.uid
      if param and param.extra and param.extra.uid then
        uid = param.extra.uid
      elseif l_1_0 and l_1_0.uid then
        uid = l_1_0.uid
      end
      if not param.sid then
        m.auth(uid, l_1_0.session, l_1_0.sid)
      end
      if not param.sid then
        local lParams = {uid = "" .. uid, acct = "" .. uid, sid = "S" .. l_1_0.sid}
        do
          local paramStr = jsonEncode(lParams)
          require("data.takingdata").statAccount(2, paramStr)
        end
        do return end
        if l_1_0.status == -2 then
          m.setHint(i18n.global.acct_ban.string)
          m.onFinish(i18n.global.acct_ban.string)
        else
          m.setHint("login failed.")
          m.onFinish("login failed.")
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
    end
   end
  m.auth = function(l_6_0, l_6_1, l_6_2)
    local userid = userdata.getString(userdata.keys.userid, "")
    local s_uid = l_6_0 or ""
    if userid and userid ~= "" and userid ~= "" .. s_uid then
      userdata.clearWhenSwitchAccount()
    end
    userdata.setString(userdata.keys.userid, s_uid)
    local envInfo = jsonEncode(getEnvInfo())
    local dids = jsonEncode(getDIDS())
    net:auth({uid = l_6_0, sid = l_6_2, session = l_6_1, env = envInfo, ids = dids}, function(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -2 then
          m.setHint(i18n.global.error_server_maintain.string)
          m.onFinish(i18n.global.error_server_maintain.string)
        else
          m.setHint(i18n.global.auth_account_fail.string .. " auth:" .. l_1_0.status)
          m.onFinish(i18n.global.auth_account_fail.string .. " auth:" .. l_1_0.status)
        end
        return 
      end
      userdata.createTs = l_1_0.createTs or 0
      m.setHint(i18n.global.auth_account_ok.string)
      m.onFinish("ok", uid, sid)
      end)
   end
  m.setHint = function(l_7_0)
    if setHint then
      setHint(l_7_0)
    end
   end
  m.onFinish = function(l_8_0, l_8_1, l_8_2)
    if param.new then
      net:close(function()
      if onFinish then
        onFinish(status, uid, sid)
      end
      end)
    elseif onFinish then
      onFinish(l_8_0, l_8_1, l_8_2)
    end
   end
  if not APP_CHANNEL or APP_CHANNEL == "" then
    m.connect()
  elseif APP_CHANNEL == "IAS" then
    m.connect()
  elseif APP_CHANNEL == "ONESTORE" then
    local sdkcfg = require("common.sdkcfg")
    if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].init then
      sdkcfg[APP_CHANNEL].init()
    end
    m.connect()
  else
    m.thirdConnect()
  end
end

return auth

