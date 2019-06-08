-- Command line was: E:\github\dhgametool\scripts\data\gvar.lua 

local data = {}
data.appstore_productid = nil
data.onAppStore = function(l_1_0)
  print("get appstore_productid:", l_1_0)
  if not l_1_0 or l_1_0 == "" then
    return 
  end
  data.appstore_productid = l_1_0
  data.payAppStore()
end

data.payAppStore = function()
  print("call payAppStore")
  if not data.appstore_productid then
    return 
  end
  local cfgstore = require("config.store")
  local shopData = require("data.shop")
  local pos = 0
  if data.appstore_productid == cfgstore[6].payId then
    pos = 6
    if shopData.pay and shopData.pay[6] ~= 0 then
      showToast("you have already purchased crazy gift package")
      return 
    else
      if data.appstore_productid == cfgstore[32].payId then
        pos = 32
        if shopData.pay and shopData.pay[32] ~= 0 then
          showToast("you have already purchased mini crazy gift package")
          return 
        else
          if data.appstore_productid == cfgstore[33].payId then
            pos = 33
            if shopData.pay and shopData.pay[33] ~= 0 then
              showToast("you have already subscribed weekly extra gold")
              return 
            else
              if data.appstore_productid == cfgstore[35].payId then
                pos = 35
                if shopData.pay and shopData.pay[35] ~= 0 then
                  showToast("you have already subscribed monthly extra gold")
                  return 
                else
                  if data.appstore_productid == cfgstore[36].payId then
                    pos = 36
                    if shopData.pay and shopData.pay[36] ~= 0 then
                      showToast("you have already subscribed quarterly extra gold")
                      return 
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  local waitnet = addWaitNet()
  waitnet.setTimeout(120)
  require("common.iap").pay(data.appstore_productid, function(l_1_0)
    delWaitNet()
    if l_1_0 then
      shopData.setPay(pos, 1)
      if pos == 33 or pos == 35 or pos == 36 then
        shopData.addSubHead()
        shopData.subId(pos)
        shopData.setPay(pos, 1)
      end
      require("data.bag").addRewards(l_1_0)
      local rewards = require("ui.reward")
      CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0), 2000000)
    end
   end)
end

data.checkAppStore = function()
  if require("data.tutorial").exists() then
    return 
  end
  if DHPayment:getInstance().listenAppStore then
    DHPayment:getInstance():listenAppStore(data.onAppStore)
  end
end

return data

