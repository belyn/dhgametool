-- Command line was: E:\github\dhgametool\scripts\ui\login\loading.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local userdata = require("data.userdata")
local heartbeat = require("data.heartbeat")
ShaderManager:getInstance():init(require("data.shaders"))
ui.create = function(l_1_0, l_1_1)
  local layer = (CCLayer:create())
  local parent = nil
  layer.setHint = function(l_1_0)
    if not parent and not tolua.isnull(layer) then
      parent = layer:getParent()
    end
    if parent and parent.setHint then
      parent.setHint(l_1_0)
    end
   end
  layer.setPercentageForProgress = function(l_2_0)
    if not parent and not tolua.isnull(layer) then
      parent = layer:getParent()
    end
    if parent and parent.setPercentageForProgress then
      parent.setPercentageForProgress(l_2_0)
    end
   end
  net:setDialogEnable(true)
  heartbeat.run(l_1_1)
  layer.checkIAP = function()
    require("data.player").init(uid, sid)
    require("common.iap").pull(function(l_1_0)
      if l_1_0 then
        require("data.bag").addRewards(l_1_0)
      end
      layer.sync()
      end)
   end
  layer:runAction(CCCallFunc:create(layer.checkIAP))
  layer.sync = function()
    layer.setHint(i18n.global.sync_data.string)
    local isDone = false
    local sync_param = {sid = sid, idfa = HHUtils:getAdvertisingId(), keychain = HHUtils:getUniqKC(), idfv = HHUtils:getUniqFv()}
    net:sync(sync_param, function(l_1_0)
      print("------------------------------sysnc data:")
      tbl2string(l_1_0)
      if not isDone then
        isDone = true
        if l_1_0.status ~= 0 then
          layer.setHint(i18n.global.sync_data_fail.string .. l_1_0.status)
          return 
        end
        local playerdata = require("data.player")
        playerdata.init(uid, sid, l_1_0.player)
        if l_1_0.final_rank then
          playerdata.final_rank = l_1_0.final_rank
        else
          playerdata.final_rank = nil
        end
        if l_1_0.hide_vip then
          playerdata.hide_vip = l_1_0.hide_vip
        else
          playerdata.hide_vip = nil
        end
        if l_1_0.chatblocks then
          playerdata.chatblocks = l_1_0.chatblocks
        else
          playerdata.chatblocks = 0
        end
        playerdata.print()
        playerdata.buy_hlimit = l_1_0.buy_hlimit or 0
        local bagdata = require("data.bag")
        bagdata.init(l_1_0.bag)
        bagdata.print()
        local herosdata = require("data.heros")
        herosdata.init(l_1_0.heroes)
        herosdata.print()
        local gachadata = require("data.gacha")
        gachadata.init(l_1_0.gacha)
        gachadata.initspacesummon(l_1_0.space_gacha)
        gachadata.print()
        local skinbook = require("data.skinbook")
        skinbook.init(l_1_0.sf_ids)
        skinbook.print()
        local herobook = require("data.herobook")
        herobook.init(l_1_0.hero_ids)
        herobook.print()
        local rateus = require("data.rateus")
        rateus.init(l_1_0.rate_us)
        rateus.print()
        local videoad = require("data.videoad")
        videoad.init(l_1_0.video_ad)
        videoad.print()
        local trialdata = require("data.trial")
        trialdata.init(l_1_0.trial)
        local chatdata = require("data.chat")
        chatdata.deSync()
        chatdata.registEvent()
        if l_1_0.htask then
          local herotaskData = require("data.herotask")
          herotaskData.init(l_1_0.htask)
        end
        local mail = require("data.mail")
        mail.init(l_1_0.mails)
        mail.registEvent()
        local midas = require("data.midas")
        midas.init(l_1_0.midas_cd, l_1_0.midas_flag)
        midas.print()
        local achieveData = require("data.achieve")
        achieveData.init(l_1_0.achieve)
        local databrave = require("data.brave")
        databrave.clear()
        if l_1_0.reddot then
          databrave.initRedDot(l_1_0.reddot)
        end
        if l_1_0.tasks then
          tbl2string(l_1_0.tasks)
          local taskdata = require("data.task")
          taskdata.syncInit({tasks = l_1_0.tasks})
          taskdata.setCD(l_1_0.task_cd or 8640000)
        end
        if l_1_0.online then
          local onlinedata = require("data.online")
          onlinedata.sync(l_1_0.online)
        end
        if l_1_0.sact then
          local christmas = require("data.christmas")
          christmas.init(l_1_0.sact)
          print("**********christmas**************")
          tbl2string(l_1_0.sact)
        end
        if l_1_0.acts then
          local activityData = require("data.activity")
          print("****activity****")
          tbl2string(l_1_0.acts)
          activityData.init({status = l_1_0.acts})
          activityData.print()
        end
        if l_1_0.limitacts then
          print("--------------------limitactivity status--------------")
          tbl2string(l_1_0.limitacts)
          local limitactivityData = require("data.activitylimit")
          limitactivityData.init({status = l_1_0.limitacts})
        else
          local limitactivityData = require("data.activitylimit")
          limitactivityData.init({status = nil})
        end
        if l_1_0.mact then
          local mactivityData = require("data.monthlyactivity")
          print("****mactivity****")
          tbl2string(l_1_0.mact)
          mactivityData.init({status = l_1_0.mact})
          mactivityData.print()
        end
        local hook = require("data.hook")
        print("sync ------------- hook")
        if l_1_0.hook then
          tbl2string(l_1_0.hook)
        end
        hook.init(l_1_0.hook)
        local friend = require("data.friend")
        if l_1_0.friends then
          friend.init(l_1_0.friends)
        end
        friend.registEvent()
        local frdboss = require("data.friendboss")
        if l_1_0.frd_boss then
          frdboss.init(l_1_0.frd_boss)
        end
        frdboss.registEvent()
        local frdarena = require("data.frdarena")
        frdarena.registEvent()
        local gdata = require("data.guild")
        gdata.deInit()
        gdata.Listen()
        local gmilldata = require("data.guildmill")
        if l_1_0.reddot then
          gmilldata.initRedDot(l_1_0.reddot)
        end
        local shop = require("data.shop")
        shop.init(l_1_0.pay_num)
        if l_1_0.subscribed and l_1_0.subscribed >= 1 then
          shop.setPay(33, 1)
        else
          shop.setPay(33, 0)
        end
        shop.subId(l_1_0.subscribed or 0)
        shop.print()
        local monthlogin = require("data.monthlogin")
        if l_1_0.alogin then
          monthlogin.init(l_1_0.alogin)
          monthlogin.print()
        end
        local smith = require("ui.smith.main")
        smith.equipformulas.init()
        local airData = require("data.airisland")
        if l_1_0.reddot then
          airData.initRedDot(l_1_0.reddot)
        end
        if l_1_0.cds then
          require("data.cd").initCDS(l_1_0.cds)
        end
        require("data.gskill").sync(l_1_0.gskls)
        require("data.gskill").initCode(l_1_0.gsklcode)
        local pet = require("data.pet")
        pet.data = {}
        pet.initData()
        if l_1_0.pets then
          pet.setData(l_1_0.pets)
        end
        local solo = require("data.solo")
        if l_1_0.reddot then
          solo.initRedDot(l_1_0.reddot)
        end
        local airData = require("data.airisland")
        airData.setCount()
        local tutorial = require("data.tutorial")
        tutorial.init(l_1_0.tutorial, l_1_0.tutorial2)
        tutorial.print()
        if not isChannel() then
          local preventAddiction = require("data.preventaddiction")
          if l_1_0.identity then
            preventAddiction.init2(l_1_0.identity)
          else
            preventAddiction.init(0, 0)
          end
        end
        layer.loadUI()
      end
      end)
    schedule(layer, NET_TIMEOUT, function()
      if not isDone then
        isDone = true
        ui.popErrorDialog(i18n.global.sync_data_fail.string .. ": timeout")
      end
      end)
   end
  layer.loadUI = function()
    layer.setHint(i18n.global.load_resource.string)
    local beginTime = os.time()
    local imgList, jsonList = img.getLoadListForUI(), json.getLoadListForUI()
    local sum, num =  imgList, 0
    img.loadAsync(imgList, function()
      num = num + 1
      if layer.setPercentageForProgress then
        layer.setPercentageForProgress(num / sum * 100)
      end
      if num == sum and not tolua.isnull(layer) then
        schedule(layer, function()
        json.loadAll(jsonList)
        json.initUnits(img.initUnits())
        local delay = 0.01
        local endTime = os.time()
        if endTime - beginTime < 1.5 then
          delay = 1.5 - (endTime - beginTime)
        end
        schedule(layer, delay, function()
          replaceScene(require("ui.town.main").create())
          audio.playBackgroundMusic(audio.ui_bg)
            end)
         end)
      end
      end)
   end
  return layer
end

ui.popErrorDialog = function(l_2_0)
  popReconnectDialog(l_2_0, function()
    replaceScene(require("ui.login.update").create())
   end)
end

return ui

