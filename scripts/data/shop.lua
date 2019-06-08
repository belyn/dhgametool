-- Command line was: E:\github\dhgametool\scripts\data\shop.lua 

local shop = {}
local cjson = json
require("common.const")
require("common.func")
local isread6 = false
local isread32 = false
local subid = 0
shop.init = function(l_1_0)
  if l_1_0 then
    tbl2string(l_1_0)
    shop.pay = l_1_0
  end
  if device.platform ~= "android" then
    return 
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  shop.getSkus()
end

local skuDetails = {}
local did_getSku = false
local coupSkuArray = function(l_2_0)
  print("------------getSkuDetails  2:")
  tbl2string(l_2_0)
  if not l_2_0 or  l_2_0 == 0 then
    return 
  end
  for ii = 1,  l_2_0 do
    skuDetails[l_2_0[ii].mSku] = clone(l_2_0[ii])
  end
  if  l_2_0 == 1 then
    return 
  end
  local cfgstore = require("config.store")
  if skuDetails["com.droidhang.ad.diamond36"] then
    do return end
  end
  skuDetails["com.droidhang.ad.diamond36"] = {mPrice = cfgstore[33].priceStr}
  if skuDetails["com.droidhang.ad.diamond2"] then
    local _sku = skuDetails["com.droidhang.ad.diamond2"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({9, 14, 16, 27, 33}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond4"] then
    local _sku = skuDetails["com.droidhang.ad.diamond4"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({18, 24}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond5"] then
    local _sku = skuDetails["com.droidhang.ad.diamond5"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({12, 20, 25, 30}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond6"] then
    local _sku = skuDetails["com.droidhang.ad.diamond6"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({22, 32}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond11"] then
    local _sku = skuDetails["com.droidhang.ad.diamond11"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({19, 29}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond21"] then
    local _sku = skuDetails["com.droidhang.ad.diamond21"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({26, 31}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
  end
  if skuDetails["com.droidhang.ad.diamond3"] then
    local _sku = skuDetails["com.droidhang.ad.diamond3"]
    local mPrice = _sku.mPrice
    if not mPrice or mPrice == "" then
      return 
    end
    for _,_v in ipairs({10, 13, 15, 17, 23, 28, 35}) do
      skuDetails["com.droidhang.ad.diamond" .. _v] = {mPrice = mPrice}
    end
    local npos = string.find(mPrice, "[0-9.]")
    if not npos then
      return 
    end
    local price_num = string.sub(mPrice, npos, -1)
    local price_str = string.sub(mPrice, 1, npos - 1)
    if price_num and price_str and checknumber(price_num) > 0 then
      price_num = checknumber(price_num)
      skuDetails["com.droidhang.ad.diamond36"].mPrice = price_str .. price_num / 10
    end
  end
end

local dhGetSkuDetail = function(l_3_0, l_3_1, l_3_2, l_3_3)
  DHPayment:getInstance():getSkuDetails(l_3_0, l_3_1, function(l_1_0, l_1_1)
    if not l_1_0 or l_1_0 ~= "0" then
      return 
    end
    local skuArray = cjson.decode(l_1_1)
    if skuHandler then
      skuHandler(skuArray)
    end
   end)
end

shop.getSkus = function()
  if did_getSku then
    return 
  end
  did_getSku = true
  local sku_ids = {2, 3, 4, 5, 6, 7, 8, 11, 21}
  local skus1 = {}
  for ii = 1,  sku_ids do
    skus1[ skus1 + 1] = "com.droidhang.ad.diamond" .. sku_ids[ii]
  end
  local skus3 = {}
  for ii = 36, 36 do
    skus3[ skus3 + 1] = "com.droidhang.ad.diamond" .. ii
  end
  local fstep1 = false
  if DHPayment.getSkuDetails then
    DHPayment:getInstance():getSkuDetails("inapp", cjson.encode(skus1), function(l_1_0, l_1_1)
    fstep1 = true
    print("------------getSkuDetails:", l_1_0)
    print(l_1_1)
    if not l_1_0 or l_1_0 ~= "0" then
      return 
    end
    local skuArray = cjson.decode(l_1_1)
    coupSkuArray(skuArray)
   end)
    schedule(CCDirector:sharedDirector():getRunningScene(), 1.2, function()
      if not fstep1 then
        return 
      end
      DHPayment:getInstance():getSkuDetails("subs", cjson.encode(skus3), function(l_1_0, l_1_1)
        print("------------getSkuDetails subs:", l_1_0)
        print(l_1_1)
        if not l_1_0 or l_1_0 ~= "0" then
          return 
        end
        local skuArray = cjson.decode(l_1_1)
        coupSkuArray(skuArray)
         end)
      end)
  end
end

shop.getPrice = function(l_5_0, l_5_1)
  if device.platform ~= "android" then
    return l_5_1
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return l_5_1
  end
  local cfgstore = require("config.store")
  if not cfgstore[l_5_0] then
    return l_5_1
  end
  if not skuDetails[cfgstore[l_5_0].payId] then
    return l_5_1
  end
  return skuDetails[cfgstore[l_5_0].payId].mPrice or l_5_1
end

shop.getPriceByPayId = function(l_6_0, l_6_1)
  if device.platform ~= "android" then
    return l_6_1
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return l_6_1
  end
  if not skuDetails[l_6_0] then
    return l_6_1
  end
  return skuDetails[l_6_0].mPrice or l_6_1
end

shop.showRedDot = function()
  if not shop.pay then
    return false
  end
  if not isread6 and shop.pay[6] and shop.pay[6] == 0 then
    return true
  end
  return false
end

shop.showRedDot2 = function()
  if not shop.pay then
    return false
  end
  if not isread32 and shop.pay[32] == 0 then
    return true
  end
  return false
end

shop.read6 = function()
  isread6 = true
end

shop.read32 = function()
  isread32 = true
end

shop.showSub = function()
  if device.platform == "ios" then
    return false
  end
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return true
  end
  return false
end

shop.setPay = function(l_12_0, l_12_1)
  if not l_12_1 then
    l_12_1 = 1
  end
  if not shop.pay then
    shop.pay = {}
  end
  shop.pay[l_12_0] = l_12_1
end

shop.addSubHead = function()
  local bag = require("data.bag")
  bag.items.add({id = ITEM_ID_SP_SUB, num = 10})
end

shop.subId = function(l_14_0)
  if l_14_0 then
    subid = l_14_0
  end
  return subid
end

shop.everSubbed = function()
  if not shop.pay then
    return false
  end
  if shop.pay[33] and shop.pay[33] > 0 then
    return true
  end
  if shop.pay[35] and shop.pay[35] > 0 then
    return true
  end
  if shop.pay[36] and shop.pay[36] > 0 then
    return true
  end
  return false
end

shop.print = function()
  print("--------- shop --------- {")
  print("pay:", shop.pay)
  print("subid:", subid)
  print("--------- shop --------- }")
end

return shop

