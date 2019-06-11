-- Command line was: E:\github\dhgametool\scripts\net\netClient.lua 

cc.net = require("framework.cc.net.init")
cc.utils = require("framework.cc.utils.init")
require("protocol.dr2_login_pb")
require("protocol.dr2_comm_pb")
require("protocol.dr2_logic_pb")
require("pack")
require("common.func")
require("common.const")
local i18n = require("res.i18n")
local eventName = require("net.eventName")
local protoParser = require("net.protoParser")
local protoGenerator = require("net.protoGenerator")
local ByteArray = require("framework.cc.utils.ByteArray")
local EventProtocol = require("framework.api.EventProtocol")
local TcpAgent = require("net.dhTcpAgent")
local NET_OK = 0
local NET_ERROR = 1
local NetClient = {}
local net_rid = 100
NetClient.__timer = {}
local _base_module_name = "dr2_comm_pb"
local modules = {}
modules[_base_module_name] = dr2_comm_pb
modules.dr2_login_pb = dr2_login_pb
modules.dr2_logic_pb = dr2_logic_pb
EventProtocol.extend(NetClient)
NetClient.new = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = {}
  end
  l_1_1 = EventProtocol.extend(l_1_1)
  setmetatable(l_1_1, l_1_0)
  l_1_0.__index = l_1_0
  return l_1_1
end

NetClient.inceRid = function(l_2_0)
  net_rid = net_rid + 1
  if net_rid > 10000 then
    net_rid = 100
  end
end

NetClient.setDialogEnable = function(l_3_0, l_3_1)
  l_3_0._enable_dialog = l_3_1
end

NetClient:setDialogEnable(false)
NetClient.setTimer = function(l_4_0, l_4_1)
  if not NetClient.__timer then
    NetClient.__timer = {}
  end
  NetClient.__timer[l_4_1] = os.time()
end

NetClient.isTimeout = function(l_5_0, l_5_1)
  if NET_TIMEOUT < os.time() - NetClient.__timer[l_5_1] then
    local eventInfo = {event_type = "timeout", event_name = l_5_1 .. " is timeout", silence = "1", event_value = {desc = l_5_1 .. " is timeout"}}
    reportEvent(eventInfo)
    print(l_5_1 .. " is timeout.")
    return true
  else
    return false
  end
  return true
end

NetClient.getInstance = function(l_6_0)
  return NetClient
  if l_6_0._instance == nil then
    l_6_0._instance = l_6_0:new()
  end
  return l_6_0._instance
end

NetClient.isConnected = function(l_7_0)
  if not l_7_0._tcpAgent then
    return false
  end
  return l_7_0._tcpAgent:isConnected()
end

local pack_proto_data = function(l_8_0)
  local _ba = ByteArray.new(ByteArray.ENDIAN_BIG)
  _ba:setPos(1)
  local _proto_data = l_8_0.data
  local _proto_len = string.len(_proto_data)
  local _data_len = CONFIG_PROTOCOL_HEADER_EXCEPT_FIRST_LEN + _proto_len
  _ba:writeUShort(_data_len)
  _ba:writeUByte(l_8_0.group)
  _ba:writeUByte(l_8_0.cmd)
  _ba:writeUShort(l_8_0.sid)
  _ba:writeBuf(_proto_data)
  l_8_0 = nil
  return _ba
end

local get_proto_string = function(l_9_0)
  local _ba = ByteArray.new(ByteArray.ENDIAN_BIG)
  _ba:setPos(1)
  local tmp_data = string.sub(l_9_0, 1, CONFIG_PROTOCOL_HEADER_LEN_RECV)
  _ba:writeBuf(tmp_data)
  _ba:setPos(1)
  local rcv_len = _ba:readUShort()
  local rcv_type = _ba:readUByte()
  local rcv_cmd = _ba:readUByte()
  local _proto_string = string.sub(l_9_0, CONFIG_PROTOCOL_HEADER_LEN_RECV + 1, -1)
  _ba, l_9_0 = nil
  return _proto_string, rcv_len, rcv_type, rcv_cmd
end

local removeEventByName = function(l_10_0, l_10_1)
  if l_10_0._tcpAgent then
    l_10_0._tcpAgent:removeAllEventListenersForEvent(l_10_1)
  end
end

local addEventListener = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._tcpAgent then
    return 
  end
  return l_11_0._tcpAgent:addEventListener(l_11_1, l_11_2)
end

NetClient.newConnect = function(l_12_0, l_12_1, l_12_2)
  l_12_0.connect_callback = l_12_2
  l_12_0._tcpAgent = TcpAgent:new()
  l_12_0._tcpAgent:removeAllEventListenersForEvent(TcpAgent.EVENT_CONNECTED)
  l_12_0._tcpAgent:removeAllEventListenersForEvent(cc.net.SocketTCP.EVENT_CLOSED)
  l_12_0._tcpAgent:removeAllEventListenersForEvent(TcpAgent.EVENT_ERROR)
  l_12_0._statusHandle = addEventListener(l_12_0, TcpAgent.EVENT_CONNECTED, handler(l_12_0, l_12_0.onStatus))
  l_12_0._closedHandle = addEventListener(l_12_0, cc.net.SocketTCP.EVENT_CLOSED, handler(l_12_0, l_12_0.onClosed))
  l_12_0._errorHandle = addEventListener(l_12_0, TcpAgent.EVENT_ERROR, handler(l_12_0, l_12_0.onError))
  if not l_12_0._tcpAgent:isConnected() then
    l_12_0._tcpAgent:connect(l_12_1.host, l_12_1.port)
  end
end

NetClient.getRIp = function(l_13_0)
  if l_13_0._tcpAgent and l_13_0._tcpAgent.r_ip then
    return l_13_0._tcpAgent.r_ip
  end
  return " no ip"
end

NetClient.Event = function(l_14_0, l_14_1, l_14_2, l_14_3)
  removeEventByName(l_14_0, l_14_1)
  if not l_14_0.handlers then
    l_14_0.handlers = {}
  end
  if not l_14_0.callbacks then
    l_14_0.callbacks = {}
  end
  if not l_14_0._tcpAgent then
    return 
  end
  l_14_0.handlers[l_14_1] = l_14_0._tcpAgent:addEventListener(l_14_1, handler(l_14_0, l_14_2.event_callback))
  if l_14_3 then
    l_14_0.callbacks[l_14_1] = l_14_3
  else
    l_14_0.callbacks[l_14_1] = nil
  end
  if l_14_1 == "EVENT_CMD_18_3" then
    local t_proto_gen_method = protoGenerator.pay
    local _proto_data = t_proto_gen_method(l_14_2)
    local limit_size = 7168
    local _proto_len = string.len(_proto_data)
    local pack_count = math.floor((_proto_len + limit_size - 1) / limit_size)
    for ii = 1, pack_count do
      local params = {}
      local start_i = 1 + (ii - 1) * limit_size
      local end_i = ii * limit_size
      if _proto_len < end_i then
        end_i = _proto_len
      end
      local pay2_params = {data = tostring(string.sub(_proto_data, 1 + (ii - 1) * limit_size, ii * limit_size))}
      if ii < pack_count then
        pay2_params.left = 1
      else
        pay2_params.left = 0
      end
      local _proto_data2 = l_14_2.proto_gen_method(pay2_params)
      local params = {}
      params.data = _proto_data2
      params.group = l_14_2.group
      params.cmd = l_14_2.cmd
      params.sid = l_14_2.sid
      params.reserved = l_14_2.reserved or 0
      local _ba = pack_proto_data(params)
      l_14_0:send(_ba)
      l_14_0:setTimer(l_14_1)
    end
  else
    local _proto_data = l_14_2.proto_gen_method(l_14_2)
    local params = {}
    params.data = _proto_data
    params.group = l_14_2.group
    params.cmd = l_14_2.cmd
    params.sid = l_14_2.sid
    params.reserved = l_14_2.reserved or 0
    local _ba = pack_proto_data(params)
    l_14_0:send(_ba)
    l_14_0:setTimer(l_14_1)
  end
end

NetClient.RegEvent = function(l_15_0, l_15_1, l_15_2, l_15_3)
  removeEventByName(l_15_0, l_15_1)
  if not l_15_0.handlers then
    l_15_0.handlers = {}
  end
  if not l_15_0.callbacks then
    l_15_0.callbacks = {}
  end
  if not l_15_0._tcpAgent then
    return 
  end
  l_15_0.handlers[l_15_1] = l_15_0._tcpAgent:addEventListener(l_15_1, handler(l_15_0, l_15_2))
  if l_15_3 then
    l_15_0.callbacks[l_15_1] = l_15_3
  else
    l_15_0.callbacks[l_15_1] = nil
  end
end

NetClient.onEvent = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  if NetClient:isTimeout(l_16_1) then
    return 
  end
  CCLuaLog("get " .. l_16_1 .. " data. start to parse ...:")
  local _proto_string = get_proto_string(l_16_2.data)
  l_16_3:ParseFromString(_proto_string)
  local __data = l_16_4(l_16_3)
  if l_16_0.extra_callback then
    l_16_0.extra_callback({name = l_16_1, data = l_16_2.data})
  end
  if l_16_0.callbacks[l_16_1] then
    l_16_0.callbacks[l_16_1](__data)
  end
end

NetClient.onPushEvent = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  CCLuaLog("get " .. l_17_1 .. " data. start to parse ...:")
  local _proto_string = get_proto_string(l_17_2.data)
  l_17_3:ParseFromString(_proto_string)
  local __data = l_17_4(l_17_3)
  if l_17_0.callbacks[l_17_1] then
    l_17_0.callbacks[l_17_1](__data)
  end
end

NetClient.regExtraListener = function(l_18_0, l_18_1)
  l_18_0.extra_callback = l_18_1
end

NetClient.connect = function(l_19_0, l_19_1, l_19_2)
  l_19_0.connect_callback = l_19_2
  if not l_19_0._tcpAgent then
    l_19_0._tcpAgent = TcpAgent:getInstance()
    l_19_0._tcpAgent:removeAllEventListenersForEvent(TcpAgent.EVENT_CONNECTED)
    l_19_0._tcpAgent:removeAllEventListenersForEvent(cc.net.SocketTCP.EVENT_CLOSED)
    l_19_0._tcpAgent:removeAllEventListenersForEvent(TcpAgent.EVENT_ERROR)
    l_19_0._statusHandle = addEventListener(l_19_0, TcpAgent.EVENT_CONNECTED, handler(l_19_0, l_19_0.onStatus))
    l_19_0._closedHandle = addEventListener(l_19_0, cc.net.SocketTCP.EVENT_CLOSED, handler(l_19_0, l_19_0.onClosed))
    l_19_0._errorHandle = addEventListener(l_19_0, TcpAgent.EVENT_ERROR, handler(l_19_0, l_19_0.onError))
  end
  if not l_19_0._tcpAgent:isConnected() then
    l_19_0._tcpAgent:connect(l_19_1.host, l_19_1.port)
  end
end

NetClient.send = function(l_20_0, l_20_1)
  if not l_20_0._tcpAgent then
    print("_tcpAgent false.")
    return 
  end
  if l_20_0._enable_dialog and not l_20_0:isConnected() then
    popReconnectDialog()
    return 
  end
  l_20_0._tcpAgent:send(l_20_1:getPack())
  l_20_1 = nil
  l_20_0:inceRid()
  return 
end

NetClient.close = function(l_21_0, l_21_1)
  if l_21_1 then
    l_21_0.self_close_callback = l_21_1
  else
    l_21_0.self_close_callback = nil
  end
  print("client close socket.")
  if l_21_0._tcpAgent then
    l_21_0.is_self_close = true
    l_21_0._tcpAgent:close()
  elseif l_21_0.self_close_callback then
    l_21_0.self_close_callback()
  end
end

NetClient.onStatus = function(l_22_0, l_22_1)
  print("socket status: " .. l_22_1.name)
  print("onstatus eventname: " .. l_22_1.name)
  if l_22_1.name == TcpAgent.EVENT_CONNECTED then
    CCLuaLog("connected to server.")
    l_22_0.is_self_close = nil
    if not l_22_0._tcpAgent then
      return 
    end
    l_22_0._tcpAgent:removeEventListener(TcpAgent.EVENT_CONNECTED, l_22_0._statusHandle)
    __data = {status = 0}
    l_22_0.connect_callback(__data)
  end
end

NetClient.registForegroundListener = function(l_23_0, l_23_1)
  l_23_0.foreground_listener = l_23_1
end

NetClient.unregistForegroundListener = function(l_24_0)
  if l_24_0.foreground_listener then
    l_24_0.foreground_listener = nil
  end
end

NetClient.onClosed = function(l_25_0, l_25_1)
  print("event name: " .. l_25_1.name)
  l_25_0._tcpAgent = nil
  if l_25_0.foreground_listener and l_25_0._enable_dialog then
    l_25_0.foreground_listener()
    return 
  end
  if l_25_0.is_newconn and not l_25_0.is_self_close then
    delWaitNet()
    showToast(i18n.global.error_account_passwd.string)
    l_25_0.is_newconn = nil
    return 
  end
  if l_25_0._enable_dialog and not l_25_0.is_self_close then
    popReconnectDialog(i18n.global.error_server_close.string)
  elseif l_25_0.self_close_callback then
    l_25_0.self_close_callback()
  end
end

NetClient.onError = function(l_26_0, l_26_1)
  print("socket error: " .. l_26_1.error)
  print("onError eventname: " .. l_26_1.name)
end

local cmds = eventName.cmds
local generatorMethod = function(l_27_0)
  protoGenerator[l_27_0.cmd] = function(l_1_0)
    l_1_0.module_name = params.module_name
    l_1_0.class_name = params.req_name
    return protoGenerator.genProtoData(l_1_0)
   end
end

for _,params in ipairs(cmds) do
  do
    generatorMethod(params)
    local event_callback_name = "on" .. params.cmd .. "Data"
    do
      NetClient[params.cmd] = function(l_28_0, l_28_1, l_28_2)
        l_28_1.group = params.cmd_group
        l_28_1.cmd = params.cmd_type
        l_28_1.event_callback = l_28_0[event_callback_name]
        l_28_1.proto_gen_method = protoGenerator[params.cmd]
        l_28_0:Event(params.cmd_name, l_28_1, l_28_2)
         end
      NetClient[event_callback_name] = function(l_29_0, l_29_1)
        l_29_0:onEvent(params.cmd_name, l_29_1, modules[params.module_name][params.rsp_name](), protoParser.obj2Tbl)
         end
    end
  end
end
NetClient.heart_beat = function(l_30_0, l_30_1, l_30_2)
  l_30_1.group = 1
  l_30_1.cmd = 1
  l_30_1.event_callback = l_30_0.onHeart_beatData
  l_30_1.proto_gen_method = protoGenerator.genEchoData
  l_30_0:Event(eventName.EVENT_CMD_1_1, l_30_1, l_30_2)
end

NetClient.onHeart_beatData = function(l_31_0, l_31_1)
end

NetClient.onMailData = function(l_32_0, l_32_1)
  l_32_0:onPushEvent(eventName.EVENT_CMD_5_0, l_32_1, dr2_comm_pb.pb_mail(), protoParser.obj2Tbl)
end

NetClient.registMailEvent = function(l_33_0, l_33_1)
  l_33_0:RegEvent(eventName.EVENT_CMD_5_0, l_33_0.onMailData, l_33_1)
end

NetClient.onChatData = function(l_34_0, l_34_1)
  l_34_0:onPushEvent(eventName.EVENT_CMD_7_0, l_34_1, dr2_comm_pb.pb_chat(), protoParser.obj2Tbl)
end

NetClient.registChatEvent = function(l_35_0, l_35_1)
  l_35_0:RegEvent(eventName.EVENT_CMD_7_0, l_35_0.onChatData, l_35_1)
end

NetClient.onFriendsData = function(l_36_0, l_36_1)
  l_36_0:onPushEvent(eventName.EVENT_CMD_10_4, l_36_1, dr2_logic_pb.pbrsp_frd_notify(), protoParser.obj2Tbl)
end

NetClient.onFriendsbossData = function(l_37_0, l_37_1)
  l_37_0:onPushEvent(eventName.EVENT_CMD_23_6, l_37_1, dr2_logic_pb.pbrsp_fboss_notify(), protoParser.obj2Tbl)
end

NetClient.onFrdarenaData = function(l_38_0, l_38_1)
  l_38_0:onPushEvent(eventName.EVENT_CMD_26_10, l_38_1, dr2_logic_pb.pbrsp_gpvpteam_notify(), protoParser.obj2Tbl)
end

NetClient.registFriendsEvent = function(l_39_0, l_39_1)
  l_39_0:RegEvent(eventName.EVENT_CMD_10_4, l_39_0.onFriendsData, l_39_1)
end

NetClient.registFriendsbossEvent = function(l_40_0, l_40_1)
  l_40_0:RegEvent(eventName.EVENT_CMD_23_6, l_40_0.onFriendsbossData, l_40_1)
end

NetClient.registFrdarenaEvent = function(l_41_0, l_41_1)
  l_41_0:RegEvent(eventName.EVENT_CMD_26_10, l_41_0.onFrdarenaData, l_41_1)
end

NetClient.onGuildData = function(l_42_0, l_42_1)
  l_42_0:onPushEvent(eventName.EVENT_CMD_13_0, l_42_1, dr2_logic_pb.pbrsp_guild_notify(), protoParser.obj2Tbl)
end

NetClient.registGuildEvent = function(l_43_0, l_43_1)
  l_43_0:RegEvent(eventName.EVENT_CMD_13_0, l_43_0.onGuildData, l_43_1)
end

return NetClient

