-- Command line was: E:\github\dhgametool\scripts\net\dhTcpAgent.lua 

cc.net = require("framework.cc.net.init")
cc.utils = require("framework.cc.utils.init")
require("pack")
local ByteArray = require("framework.cc.utils.ByteArray")
local EventProtocol = require("framework.api.EventProtocol")
local scheduler = require("framework.scheduler")
local TcpAgent = {}
TcpAgent.FIRST_FIELD_LEN = 2
TcpAgent.MAX_TYPE_NUM = 100
TcpAgent.MAX_CMD_NUM = 1000
TcpAgent.NOT_CONNECTED = "NOT_CONNECTED"
TcpAgent.EVENT_CONNECTED = "EVENT_CONNECTED"
TcpAgent.EVENT_ERROR = "EVENT_ERROR"
TcpAgent.EVENT_CMD_2_1 = "EVENT_CMD_2_1"
TcpAgent.EVENT_CMD_2_2 = "EVENT_CMD_2_2"
TcpAgent.EVENT_CMD_2_3 = "EVENT_CMD_2_3"
TcpAgent.EVENT_CMD_3_1 = "EVENT_CMD_3_1"
TcpAgent.EVENT_CMD_3_2 = "EVENT_CMD_3_2"
TcpAgent.EVENT_CMD_4_1 = "EVENT_CMD_4_1"
local _ba = ByteArray.new(ByteArray.ENDIAN_BIG)
local _auto_reconnect = false
local readHeader = function(l_1_0)
  local rcv_len = l_1_0:readUShort()
  local rcv_type = l_1_0:readUByte()
  local rcv_cmd = l_1_0:readUByte()
  print("rcv_len:", rcv_len)
  print("rcv_type:", rcv_type)
  print("rcv_cmd:", rcv_cmd)
  return rcv_len, rcv_type, rcv_cmd
end

TcpAgent.new = function(l_2_0, l_2_1)
  if not l_2_1 then
    l_2_1 = {}
  end
  l_2_1 = EventProtocol.extend(l_2_1)
  setmetatable(l_2_1, l_2_0)
  l_2_0.__index = l_2_0
  l_2_0._isConnected = false
  l_2_0._last_isCompleted = true
  l_2_0._last_pos = 0
  l_2_0._last_need_len = 0
  l_2_0._last_data = nil
  l_2_0.__data = {}
  return l_2_1
end

TcpAgent.getInstance = function(l_3_0)
  if l_3_0._instance == nil then
    l_3_0._instance = l_3_0:new()
  end
  return l_3_0._instance
end

TcpAgent.isConnected = function(l_4_0)
  return l_4_0._isConnected
end

TcpAgent.setAutoReconnect = function(l_5_0, l_5_1)
  if type(l_5_1) == type(true) then
    _auto_reconnect = l_5_1
  end
end

local isIPv6Now = function(l_6_0)
  if device.platform == "ios" then
    local socket = require("socket")
    local addrinfo, err = socket.dns.getaddrinfo(l_6_0)
    print("isIPv6Now  error:", err)
    if addrinfo and addrinfo[1] and addrinfo[1].family == "inet6" then
      return true
    end
  end
  return false
end

local getaddrinfo = function(l_7_0, l_7_1)
  if device.platform == "ios" then
    print("------------ios")
    dhutil:getHostIpAddress(l_7_1, l_7_0)
  else
    return l_7_1({1 = {status = 0, ip = l_7_0, ipType = 0}})
  end
end

TcpAgent.connect = function(l_8_0, l_8_1, l_8_2)
  if l_8_1 then
    l_8_0._host = l_8_1
    print("self host:" .. l_8_0._host)
  end
  if l_8_2 and type(l_8_2) == "number" then
    l_8_0._port = l_8_2
    print("self port:" .. l_8_0._port)
  end
  print("host:" .. (l_8_0._host or "") .. " port:" .. (l_8_0._port or 0))
  if not l_8_0._socket then
    l_8_0._socket = cc.net.SocketTCP.new(l_8_0._host, l_8_0._port, _auto_reconnect)
    l_8_0._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(l_8_0, l_8_0.onConnected))
    l_8_0._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(l_8_0, l_8_0.onClose))
    l_8_0._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(l_8_0, l_8_0.onClosed))
    l_8_0._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(l_8_0, l_8_0.onConnectFailure))
    l_8_0._socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(l_8_0, l_8_0.onData))
  end
  print("to get addr_info --------")
  local tryGetAddrInfo = function()
    if self.tryScheduler then
      scheduler.unscheduleGlobal(self.tryScheduler)
      self.tryScheduler = nil
    end
    getaddrinfo(host, function(l_1_0)
      print("get addr_info below:")
      tbl2string(l_1_0)
      local addr_ip = host
      local ipv6 = false
      if l_1_0 and  l_1_0 > 0 then
        for ii = 1,  l_1_0 do
          if l_1_0[ii].status ~= 0 then
            if l_1_0[ii].status and host then
              local eventInfo = {event_type = "error", event_name = "DNS Error", silence = "1", event_value = {desc = "dns status:" .. l_1_0[ii].status .. " host:" .. host}}
              reportEvent(eventInfo)
            end
            print("DNS error. host:", host)
            self.tryScheduler = scheduler.scheduleGlobal(tryGetAddrInfo, 0.5)
            return 
          else
            if l_1_0[ii].ipType == 1 then
              addr_ip = l_1_0[ii].ip
              ipv6 = true
              local eventInfo = {event_type = "error", event_name = "DNS Find ipv6", silence = "1", event_value = {desc = "host:" .. host .. " ip:" .. addr_ip}}
              reportEvent(eventInfo)
              print("DNS find ipv6. ip:", addr_ip)
              self._socket:connect(addr_ip, self._port, _auto_reconnect, ipv6)
              self.r_ip = addr_ip
              do return end
            else
              local eventInfo = {event_type = "error", event_name = "DNS ipType 0", silence = "1", event_value = {desc = "dns: status 0, ipType 0 ip " .. l_1_0[ii].ip}}
              reportEvent(eventInfo)
            end
          end
        end
        if not ipv6 then
          local eventInfo = {event_type = "error", event_name = "DNS not Find ipv6", silence = "1", event_value = {desc = "no ipv6 response, try ipv4"}}
          reportEvent(eventInfo)
          for ii = 1,  l_1_0 do
            if l_1_0[ii].ipType == 0 then
              addr_ip = l_1_0[ii].ip
              ipv6 = false
              self._socket:connect(addr_ip, self._port, _auto_reconnect, ipv6)
              self.r_ip = addr_ip
          else
            end
          end
        else
          local eventInfo = {event_type = "error", event_name = "DNS Error", silence = "1", event_value = {desc = "dns nil"}}
          reportEvent(eventInfo)
          self.tryScheduler = scheduler.scheduleGlobal(tryGetAddrInfo, 0.5)
          return 
        end
      end
      end)
   end
  tryGetAddrInfo()
end

TcpAgent.onConnected = function(l_9_0, l_9_1)
  print("connected to " .. l_9_0._host .. " " .. l_9_0._port)
  l_9_0._isConnected = true
  l_9_0:dispatchEvent({name = TcpAgent.EVENT_CONNECTED, error = 0})
end

TcpAgent.onClose = function(l_10_0, l_10_1)
end

TcpAgent.onClosed = function(l_11_0, l_11_1)
  print("socket closed.")
  l_11_0._isConnected = false
  l_11_0:dispatchEvent({name = cc.net.SocketTCP.EVENT_CLOSED, error = -1})
end

TcpAgent.onConnectFailure = function(l_12_0, l_12_1)
end

TcpAgent.onData = function(l_13_0, l_13_1)
  print("TcpAgent got data, len:", string.len(l_13_1.data))
  l_13_0:parseHeader(l_13_1.data)
end

TcpAgent.parseHeader = function(l_14_0, l_14_1)
  local data_len = string.len(l_14_1)
  print("start to parse header ... data len:" .. data_len)
  local toPos = 1
  local rcv_len, rcv_type, rcv_cmd = nil, nil, nil
  if not l_14_0._last_isCompleted then
    toPos = l_14_0._last_pos + 1
    if data_len == l_14_0._last_need_len then
      _ba:setPos(toPos)
      _ba:setPos(1)
      rcv_len, rcv_type, rcv_cmd = readHeader(_ba)
      if not l_14_0:isValideHeader(rcv_type, rcv_cmd) then
        return 
      end
      event_name = "EVENT_CMD_" .. rcv_type .. "_" .. rcv_cmd
      l_14_0.__data[ l_14_0.__data + 1] = l_14_1
      local _dispatch_data = nil
      if  l_14_0.__data > 0 then
        _dispatch_data = table.concat(l_14_0.__data)
      end
      l_14_0._last_isCompleted = true
      l_14_0._last_pos = 0
      l_14_0._last_need_len = 0
      l_14_0.__data = {}
      l_14_0:dispatchEvent({name = event_name, data = _dispatch_data, error = 0})
      return 
    elseif data_len < l_14_0._last_need_len then
      _ba:setPos(toPos)
      l_14_0._last_pos = toPos + data_len - 1
      l_14_0._last_need_len = l_14_0._last_need_len - data_len
      l_14_0._last_isCompleted = false
      l_14_0.__data[ l_14_0.__data + 1] = l_14_1
      return 
    elseif l_14_0._last_need_len < data_len then
      _ba:setPos(toPos)
      _ba:setPos(1)
      rcv_len, rcv_type, rcv_cmd = readHeader(_ba)
      if not l_14_0:isValideHeader(rcv_type, rcv_cmd) then
        return 
      end
      event_name = "EVENT_CMD_" .. rcv_type .. "_" .. rcv_cmd
      l_14_0.__data[ l_14_0.__data + 1] = string.sub(l_14_1, 1, l_14_0._last_need_len)
      local _dispatch_data = nil
      if  l_14_0.__data > 0 then
        _dispatch_data = table.concat(l_14_0.__data)
      end
      local remain_data = string.sub(l_14_1, l_14_0._last_need_len + 1, -1)
      l_14_0._last_isCompleted = true
      l_14_0._last_pos = 0
      l_14_0._last_need_len = 0
      l_14_0.__data = {}
      l_14_0:dispatchEvent({name = event_name, data = _dispatch_data, error = 0})
      return l_14_0:parseHeader(remain_data)
    else
      if  l_14_0.__data > 0 and  l_14_0.__data[1] < CONFIG_PROTOCOL_HEADER_LEN_RECV then
        l_14_0.__data[1] = l_14_0.__data[1] .. l_14_1
      else
        l_14_0.__data[ l_14_0.__data + 1] = l_14_1
      end
      if  l_14_0.__data[1] < CONFIG_PROTOCOL_HEADER_LEN_RECV then
        return 
      end
      _ba:setPos(toPos)
      _ba:writeBuf(string.sub(l_14_0.__data[1], 1, CONFIG_PROTOCOL_HEADER_LEN_RECV))
      _ba:setPos(1)
      rcv_len, rcv_type, rcv_cmd = readHeader(_ba)
      if not l_14_0:isValideHeader(rcv_type, rcv_cmd) then
        return 
      end
      data_len =  l_14_0.__data[1]
      if rcv_len + TcpAgent.FIRST_FIELD_LEN == data_len then
        event_name = "EVENT_CMD_" .. rcv_type .. "_" .. rcv_cmd
        local _dispatch_data = nil
        if  l_14_0.__data > 0 then
          _dispatch_data = table.concat(l_14_0.__data)
        end
        l_14_0._last_isCompleted = true
        l_14_0._last_pos = 0
        l_14_0._last_need_len = 0
        l_14_0._last_data = nil
        l_14_0.__data = {}
        l_14_0:dispatchEvent({name = event_name, data = _dispatch_data, error = 0})
        return 
      else
        if data_len < rcv_len + TcpAgent.FIRST_FIELD_LEN then
          l_14_0._last_pos = data_len
          l_14_0._last_need_len = rcv_len + TcpAgent.FIRST_FIELD_LEN - data_len
          l_14_0._last_isCompleted = false
          return 
        else
          if rcv_len + TcpAgent.FIRST_FIELD_LEN < data_len then
            event_name = "EVENT_CMD_" .. rcv_type .. "_" .. rcv_cmd
            local _dispatch_data = string.sub(l_14_0.__data[1], 1, rcv_len + TcpAgent.FIRST_FIELD_LEN)
            l_14_0._last_isCompleted = true
            l_14_0._last_pos = 0
            l_14_0._last_need_len = 0
            l_14_0._last_data = nil
            local remain_data = string.sub(l_14_0.__data[1], rcv_len + TcpAgent.FIRST_FIELD_LEN + 1, -1)
            l_14_0.__data = {}
            l_14_0:dispatchEvent({name = event_name, data = _dispatch_data, error = 0})
            return l_14_0:parseHeader(remain_data)
          end
        end
      end
    end
  end
end

TcpAgent.send = function(l_15_0, l_15_1)
  if not l_15_0._socket or not l_15_0._isConnected then
    print("connect first please.")
    l_15_0:dispatchEvent({name = TcpAgent.NOT_CONNECTED})
    return 
  end
  l_15_0._socket:send(l_15_1)
  print("TcpAgent:send")
end

TcpAgent.close = function(l_16_0)
  l_16_0._socket:disconnect()
end

TcpAgent.isValideHeader = function(l_17_0, l_17_1, l_17_2)
  local rcv_type = l_17_1
  local rcv_cmd = l_17_2
  if rcv_type < 0 or l_17_0.MAX_TYPE_NUM < rcv_type then
    print("bad header type: " .. rcv_type)
    l_17_0:resetBuff()
    l_17_0._last_isCompleted = true
    l_17_0._last_pos = 0
    l_17_0._last_need_len = 0
    l_17_0.__data = {}
    l_17_0:dispatchEvent({name = TcpAgent.EVENT_ERROR, error = 1})
    return false
  end
  if rcv_cmd < 0 or l_17_0.MAX_CMD_NUM < rcv_cmd then
    print("bad header cmd: " .. rcv_cmd)
    l_17_0:resetBuff()
    l_17_0._last_isCompleted = true
    l_17_0._last_pos = 0
    l_17_0._last_need_len = 0
    l_17_0.__data = {}
    l_17_0:dispatchEvent({name = TcpAgent.EVENT_ERROR, error = 1})
    return false
  end
  return true
end

TcpAgent.resetBuff = function(l_18_0)
  l_18_0._last_isCompleted = true
  l_18_0._last_pos = 0
  l_18_0._last_need_len = 0
  l_18_0._last_data = nil
end

return TcpAgent

