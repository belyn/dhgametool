-- Command line was: E:\github\dhgametool\scripts\sdk\sdk.lua 

local sdk = {}
sdk.login_hw = function(l_1_0, l_1_1)
  print("lua start login")
  SDKHelper:getInstance():login("", function(l_1_0)
    print(l_1_0)
    local ret = json.decode(l_1_0)
    if ret.errcode and ret.errcode == 0 then
      local appId = ret.appId
      local ts = ret.ts
      local playerId = ret.playerId
      local sign = ret.sign
      local playerId = ret.playerId
      callback(true)
    else
      callback(false)
    end
   end)
end

sdk.login_uc = function(l_2_0, l_2_1)
  print("lua start login")
  SDKHelper:getInstance():login("", function(l_1_0)
    print(l_1_0)
    local ret = json.decode(l_1_0)
    if ret.errcode and ret.errcode == 0 then
      local sid = ret.sid
      callback(true)
    else
      callback(false)
    end
   end)
end

sdk.pay_hw = function(l_3_0, l_3_1)
  print("lua start pay")
  local params = {price = 0.01, productName = "sb", productDesc = "sxxx", requestId = "xxxyyy", sign = "omg"}
  SDKHelper:getInstance():pay(json.encode(params), function(l_1_0)
    print(l_1_0)
    local ret = json.decode(l_1_0)
    if ret.errcode and ret.errcode == 0 then
      local sign = ret.sign
      local noSigna = ret.noSigna
      callback(true)
    else
      callback(false)
    end
   end)
end

sdk.pay_uc = function(l_4_0, l_4_1)
  print("lua start pay")
  local params = {price = 0.01, callback_info = "sb", notify_url = "sxxx", order_id = "order_id", account_id = "account_id", signType = "signType", sign = "omg"}
  SDKHelper:getInstance():pay(json.encode(params), function(l_1_0)
    print(l_1_0)
    local ret = json.decode(l_1_0)
    if ret.errcode and ret.errcode == 0 then
      local orderId = ret.orderId
      local orderAmount = ret.orderAmount
      local payWay = ret.payWay
      callback(true)
    else
      callback(false)
    end
   end)
end

sdk.exitGame = function(l_5_0, l_5_1)
  print("lua exitGame")
end

return sdk

