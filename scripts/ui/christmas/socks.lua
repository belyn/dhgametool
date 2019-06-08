-- Command line was: E:\github\dhgametool\scripts\ui\christmas\socks.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local heros = require("data.heros")
local cfgchristmas = require("config.specialactivity")
local net = require("net.netClient")
local christmas = require("data.christmas")
local ADRichText = require("tools.adrichtext")
local IDS = activityData.IDS
local vp_ids = {IDS.SOCKS_1.ID, IDS.SOCKS_2.ID, IDS.SOCKS_3.ID, IDS.SOCKS_4.ID}
ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[ vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_socks)
  local banner = img.createUISprite("socks_bg.png")
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local titlebg = img.createUISprite(img.ui.socks_biaoti)
  titlebg:setAnchorPoint(0.5, 1)
  titlebg:setPosition(board_w / 2, board_h - 5)
  board:addChild(titlebg, 1)
  local titleLab = lbl.createFont2(18, i18n.global.activity_christmas_gift_des.string, ccc3(246, 214, 108))
  titleLab:setPosition(CCPoint(board_w / 2, board_h - 20 - 2))
  board:addChild(titleLab, 1)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(525, board_h - 38)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.help_christmas_socks.string, i18n.global.help_title.string), 1000)
   end)
  local ani_container = {}
  local ani_socks = {}
  local btn_socks = {}
  local sx = 100
  local dx = 125
  do
    local json_name = {1 = json.ui.christmas_greetingcard01, 2 = json.ui.christmas_greetingcard02, 3 = json.ui.christmas_greetingcard03, 4 = json.ui.christmas_greetingcard04}
    do
      img.load(img.packedOthers.spine_ui_christmas_greetingcard)
      img.load(img.packedOthers.spine_ui_christmas_greetingcard_boom)
      json.load(json.ui.chirstmas_greetingcard_boom)
      local affix_socks = {15, -4, 0, 18}
      for i = 1,  vps do
        ani_container[i] = CCSprite:create()
        ani_container[i]:setContentSize(CCSizeMake(84, 126))
        json.load(json_name[i])
        ani_socks[i] = DHSkeletonAnimation:createWithKey(json_name[i])
        ani_socks[i]:scheduleUpdateLua()
        ani_socks[i]:setPosition(ani_container[i]:getContentSize().width / 2, ani_container[i]:getContentSize().height)
        ani_container[i]:addChild(ani_socks[i])
        local ani_boom = DHSkeletonAnimation:createWithKey(json.ui.chirstmas_greetingcard_boom)
        ani_boom:scheduleUpdateLua()
        ani_socks[i]:addChildFollowSlot("code_chirstmas_greetingcard_boom", ani_boom)
        local btn_socks_icon = SpineMenuItem:create(json.ui.button, ani_container[i])
        btn_socks_icon:setPosition(CCPoint(sx + (i - 1) * dx, 250 + affix_socks[i]))
        local menu_socks_icon = CCMenu:createWithItem(btn_socks_icon)
        menu_socks_icon:setPosition(0, 0)
        board:addChild(menu_socks_icon)
        btn_socks_icon:registerScriptTapHandler(function()
          audio.play(audio.button)
          layer:getParent():getParent():getParent():addChild(ui.unlockReward(vps[i]), 1001)
            end)
        local submit = img.createLogin9Sprite("sock_btn_bye.png")
        submit:setPreferredSize(CCSize(108, 40))
        if i == 1 then
          local submitlab = lbl.createFont2(14, i18n.global.christmas_socks_fress.string)
          submitlab:setPosition(CCPoint(submit:getContentSize().width / 2, submit:getContentSize().height / 2))
          submit:addChild(submitlab)
        elseif i == 4 then
          local icon = img.createUISprite(img.ui.icon_lock)
          icon:setPosition(CCPoint(22, submit:getContentSize().height / 2))
          submit:addChild(icon)
          local submitlab = lbl.createFont2(14, i18n.global.christmas_socks_unlock.string)
          submitlab:setPosition(CCPoint(70, submit:getContentSize().height / 2))
          submit:addChild(submitlab)
        else
          local icon = img.createItemIcon2(ITEM_ID_GEM)
          icon:setScale(0.8)
          icon:setPosition(CCPoint(22, submit:getContentSize().height / 2))
          submit:addChild(icon)
          local submitlab = lbl.createFont2(14, cfgchristmas[vps[i].id].extra[1].num)
          submitlab:setPosition(CCPoint(70, submit:getContentSize().height / 2))
          submit:addChild(submitlab)
        end
        btn_socks[i] = SpineMenuItem:create(json.ui.button, submit)
        btn_socks[i]:setPosition(sx + (i - 1) * dx, 130)
        local submitMenu = CCMenu:createWithItem(btn_socks[i])
        submitMenu:setPosition(0, 0)
        board:addChild(submitMenu)
        if vps[i].limits == 0 then
          btn_socks[i]:setVisible(false)
          ani_socks[i]:playAnimation("end", -1)
        else
          ani_socks[i]:playAnimation("start", -1)
        end
        local callfunc = function()
          local params = {sid = player.sid, id = vps[i].id}
          tbl2string(params)
          if cfgchristmas[vps[i].id].extra and bag.gem() < cfgchristmas[vps[i].id].extra[1].num then
            showToast(i18n.global.gboss_fight_st6.string)
            return 
          end
          addWaitNet()
          net:sact_sock(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            if l_1_0.reward then
              if l_1_0.reward.items then
                for i = 1,  l_1_0.reward.items do
                  bag.items.add(l_1_0.reward.items[i])
                end
              end
              if l_1_0.reward.equips then
                for i = 1,  l_1_0.reward.equips do
                  bag.equips.add(l_1_0.reward.equips[i])
                end
              end
            end
            if cfgchristmas[vps[i].id].extra then
              bag.subGem(cfgchristmas[vps[i].id].extra[1].num)
            end
            ani_boom:playAnimation("boom")
            ani_socks[i]:playAnimation("click")
            local ban = CCLayer:create()
            ban:setTouchEnabled(true)
            ban:setTouchSwallowEnabled(true)
            layer:addChild(ban, 2000)
            schedule(layer, 0.8, function()
              btn_socks[i]:setVisible(false)
              layer:getParent():getParent():getParent():addChild(ui.createGiftDialog({sockId = vps[i].id, day = vps[i].limits}), 1001)
              vps[i].limits = 0
              ani_socks[i]:playAnimation("end", -1)
              ban:removeFromParent()
              upvalue_3072 = nil
                  end)
               end)
            end
        btn_socks[i]:registerScriptTapHandler(function()
          audio.play(audio.button)
          if i == 4 then
            if layer:getParent() and layer:getParent().selectActivity then
              layer:getParent().selectActivity(activityData.IDS.CHRGIFT.ID)
            end
            return 
          end
          local sureDialog = require("ui.suredialog")
          layer:getParent():getParent():getParent():addChild(sureDialog.create(i18n.global.tips_sure_unlock.string, callfunc), 1000)
            end)
      end
      local mail0 = img.createUISprite(img.ui.socks_youxiang)
      local richText = ADRichText:create()
      richText:setAnchorPoint(CCPoint(0.5, 0))
      richText:setContentSize(CCSize(100, 100))
      richText:setPosition(CCPoint(mail0:getContentSize().width / 2, 0))
      richText:setHorizontalAlignment(ADRichText.HORIZONTAL_ALIGNMENT.CENTER)
      local maillab = {size = 16, fontIndex = 2, text = i18n.global.christmas_socks_sendcard.string}
      local element2 = richText:createLabelBMFElement(maillab)
      richText:pushBackElement(element2)
      richText:formatText()
      local renderNode = richText:getRenderNode()
      mail0:addChild(renderNode)
      local btn_mail = SpineMenuItem:create(json.ui.button, mail0)
      btn_mail:setAnchorPoint(CCPoint(0, 0))
      btn_mail:setPosition(CCPoint(-28, 4))
      local mailMenu = CCMenu:createWithItem(btn_mail)
      mailMenu:setPosition(0, 0)
      board:addChild(mailMenu)
      btn_mail:registerScriptTapHandler(function()
        audio.play(audio.button)
        if layer:getParent() and layer:getParent().selectActivity then
          layer:getParent().selectActivity(activityData.IDS.CHRISTMAS_CARD.ID)
        end
         end)
      layer:registerScriptHandler(function(l_6_0)
        if l_6_0 == "enter" then
          do return end
        end
        if l_6_0 == "exit" then
          do return end
        end
        if l_6_0 == "cleanup" then
          img.unload(img.packedOthers.ui_activity_socks)
          img.unload(img.packedOthers.spine_ui_christmas_greetingcard)
          img.unload(img.packedOthers.spine_ui_christmas_greetingcard_boom)
          json.unload(json.ui.chirstmas_greetingcard_boom)
          for i = 1,  json_name do
            json.unload(json_name[i])
          end
        end
         end)
      layer:setTouchEnabled(true)
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.createGiftDialog = function(l_2_0)
  local reward = l_2_0.reward or nil
  local sockId = l_2_0.sockId or nil
  local day = l_2_0.day or nil
  local unlock = l_2_0.unlock or nil
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  img.load(img.packedOthers.ui_activity_socks)
  local board = img.createUISprite("activity_wazi_board.png")
  board:setScale(view.minScale)
  board:setPosition(scalep(455, 288))
  layer:addChild(board)
  local lable = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    lable = img.createUISprite("activity_waz_board_cn.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      lable = img.createUISprite("activity_waz_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageRussian then
        lable = img.createUISprite("activity_waz_board_ru.png")
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          lable = img.createUISprite("activity_waz_board_kr.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            lable = img.createUISprite("activity_waz_board_pt.png")
          else
            if i18n.getCurrentLanguage() == kLanguageJapanese then
              lable = img.createUISprite("activity_waz_board_jp.png")
            else
              lable = img.createUISprite("activity_waz_board_us.png")
            end
          end
        end
      end
    end
  end
  lable:setPosition(CCPoint(444, 389))
  board:addChild(lable)
  local sx = 370
  local dis = 82
  local sy = 280
  layer.tipsTag = false
  do
    if unlock then
      if reward then
        local cloreward = clone(reward)
        if cloreward.items then
          do
            for i = 1,  cloreward.items do
              do
                local obj = cloreward.items[i]
                do
                  local item = img.createItem(obj.id, obj.num)
                  local itembtn = SpineMenuItem:create(json.ui.button, item)
                  itembtn:setScale(0.9)
                  if  cloreward.items <= 3 then
                    itembtn:setPosition(sx + (i - 1) * dis, sy - dis / 2)
                  else
                    itembtn:setPosition(sx + (i - 1) % 3 * dis, sy - math.floor(i / 4) * dis)
                  end
                  local iconMenu = CCMenu:createWithItem(itembtn)
                  iconMenu:setPosition(0, 0)
                  board:addChild(iconMenu)
                  itembtn:registerScriptTapHandler(function()
                  audio.play(audio.button)
                  if layer.tipsTag == false then
                    layer.tipsTag = true
                    local itemnum = obj.num
                    do
                      local tips = tipsitem.createForShow({id = obj.id, num = itemnum})
                      layer:getParent():getParent():getParent():addChild(tips, 1000)
                      tips.setClickBlankHandler(function()
                        tips:removeFromParent()
                        layer.tipsTag = false
                                 end)
                    end
                  end
                        end)
                end
              end
            end
          end
        end
    end
    if cloreward.equips then
      end
    end
    local show_btn = false
    for _,v in ipairs(vp_ids) do
      local tmp_status = activityData.getStatusById(v)
      if tmp_status.limits > 0 then
        show_btn = true
    else
      end
    end
    if show_btn then
      local unlockmore0 = img.createUISprite("sock_icon.png")
      local richText = ADRichText:create()
      richText:setAnchorPoint(cc.p(0.5, 0.5))
      richText:setContentSize(CCSize(100, 100))
      richText:setPosition(CCPoint(unlockmore0:getContentSize().width / 2, 20))
      richText:setHorizontalAlignment(ADRichText.HORIZONTAL_ALIGNMENT.CENTER)
      local unlockmorelab = {size = 14, fontIndex = 2, text = i18n.global.unlock_more.string}
      local element2 = richText:createLabelBMFElement(unlockmorelab)
      richText:pushBackElement(element2)
      richText:formatText()
      local renderNode = richText:getRenderNode()
      unlockmore0:addChild(renderNode)
      local btn_unlockmore = SpineMenuItem:create(json.ui.button, unlockmore0)
      btn_unlockmore:setPosition(655, 122)
      local unlockmoreMenu = CCMenu:createWithItem(btn_unlockmore)
      unlockmoreMenu:setPosition(0, 0)
      board:addChild(unlockmoreMenu)
      btn_unlockmore:registerScriptTapHandler(function()
        audio.play(audio.button)
        layer:getParent():addChild(require("ui.activityhome.main").create(1, "christmassocks"), 1000)
        layer:removeFromParentAndCleanup(true)
         end)
    else
      local unlockmore0 = img.createUISprite("sock_icon2.png")
      unlockmore0:setPosition(655, 122)
      board:addChild(unlockmore0)
    end
  else
    for i = 1,  cfgchristmas[sockId].rewards do
      local obj = cfgchristmas[sockId].rewards[i]
      local item = img.createItem(obj.id, obj.num * day)
      local itembtn = SpineMenuItem:create(json.ui.button, item)
      itembtn:setScale(0.9)
      if  cfgchristmas[sockId].rewards <= 3 then
        itembtn:setPosition(sx + (i - 1) * dis, sy - dis / 2)
      else
        itembtn:setPosition(sx + (i - 1) % 3 * dis, sy - math.floor(i / 4) * dis)
      end
      local iconMenu = CCMenu:createWithItem(itembtn)
      iconMenu:setPosition(0, 0)
      board:addChild(iconMenu)
      itembtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if layer.tipsTag == false then
          layer.tipsTag = true
          local itemnum = cfgchristmas[sockId].rewards[i].num * day
          do
            local tips = tipsitem.createForShow({id = obj.id, num = itemnum})
            layer:getParent():getParent():getParent():addChild(tips, 1000)
            tips.setClickBlankHandler(function()
              tips:removeFromParent()
              layer.tipsTag = false
                  end)
          end
        end
         end)
    end
    local unlockmore0 = img.createUISprite("sock_icon2.png")
    unlockmore0:setPosition(655, 122)
    board:addChild(unlockmore0)
  end
end
local richText = ADRichText:create()
richText:setAnchorPoint(CCPoint(0.5, 0.5))
richText:setContentSize(CCSize(300, 100))
richText:setPosition(CCPoint(454, 142))
richText:setHorizontalAlignment(ADRichText.HORIZONTAL_ALIGNMENT.CENTER)
local label2 = {size = 12, fontIndex = 2, text = i18n.global.unlock_more_tips.string}
local element2 = richText:createLabelBMFElement(label2)
richText:pushBackElement(element2)
richText:formatText()
local renderNode = richText:getRenderNode()
board:addChild(renderNode)
local sure0 = img.createLogin9Sprite(img.login.button_9_small_gold)
sure0:setPreferredSize(CCSize(160, 50))
local surelab = lbl.createFont1(16, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
surelab:setPosition(CCPoint(sure0:getContentSize().width / 2, sure0:getContentSize().height / 2))
sure0:addChild(surelab)
local btn_sure = SpineMenuItem:create(json.ui.button, sure0)
btn_sure:setPosition(452, 92)
local sureMenu = CCMenu:createWithItem(btn_sure)
sureMenu:setPosition(0, 0)
board:addChild(sureMenu)
btn_sure:registerScriptTapHandler(function()
  audio.play(audio.button)
  layer:removeFromParentAndCleanup(true)
end
)
layer:registerScriptHandler(function(l_5_0)
  if l_5_0 == "enter" then
    christmas:emptyReward()
  elseif l_5_0 == "exit" then
    do return end
  end
  if l_5_0 == "cleanup" then
    img.unload(img.packedOthers.ui_activity_socks)
  end
end
)
layer:setTouchEnabled(true)
return layer
end

ui.unlockReward = function(l_3_0)
  local tipslayer = CCLayer:create()
  local tipsbg = img.createUI9Sprite(img.ui.tips_bg)
  tipsbg:setPreferredSize(CCSize(530, 205))
  tipsbg:setScale(view.minScale)
  tipsbg:setPosition(view.physical.w / 2, view.physical.h / 2)
  tipslayer:addChild(tipsbg)
  local tipstitle = lbl.createFont1(18, i18n.global.christmas_socks_allday.string, ccc3(255, 228, 156))
  tipstitle:setPosition(tipsbg:getContentSize().width / 2, 172)
  tipsbg:addChild(tipstitle)
  if l_3_0.limits == 0 then
    tipstitle:setString(i18n.global.christmas_socks_evryday.string)
  end
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(470 / line:getContentSize().width)
  line:setPosition(CCPoint(tipsbg:getContentSize().width / 2, 148))
  tipsbg:addChild(line)
  local sockId = l_3_0.id
  tipslayer.tipsTag = false
  for i = 1,  cfgchristmas[sockId].rewards do
    do
      local item = nil
      if l_3_0.limits == 0 then
        item = img.createItem(cfgchristmas[sockId].rewards[i].id, cfgchristmas[sockId].rewards[i].num)
        local shade = img.createUISprite(img.ui.hero_head_shade)
        shade:setPosition(CCPoint(item:getContentSize().width / 2, item:getContentSize().height / 2))
        shade:setOpacity(120)
        item:addChild(shade)
        local soldout = img.createUISprite(img.ui.blackmarket_soldout)
        soldout:setPosition(CCPoint(item:getContentSize().width / 2, item:getContentSize().height / 2))
        item:addChild(soldout)
      else
        item = img.createItem(cfgchristmas[sockId].rewards[i].id, cfgchristmas[sockId].rewards[i].num * l_3_0.limits)
      end
      local itembtn = SpineMenuItem:create(json.ui.button, item)
      itembtn:setPosition(tipsbg:getContentSize().width / 2 - ( cfgchristmas[sockId].rewards - 1) * 53 + (i - 1) * 106, 78)
      local iconMenu = CCMenu:createWithItem(itembtn)
      iconMenu:setPosition(0, 0)
      tipsbg:addChild(iconMenu)
      itembtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if tipslayer.tipsTag == false then
          tipslayer.tipsTag = true
          local tipsitem = require("ui.tips.item")
          local itemnum = cfgchristmas[sockId].rewards[i].num
          if vpObj.limits > 0 then
            itemnum = cfgchristmas[sockId].rewards[i].num * vpObj.limits
          end
          tips = tipsitem.createForShow({id = cfgchristmas[sockId].rewards[i].id, num = itemnum})
          tipslayer:addChild(tips, 200)
          tips.setClickBlankHandler(function()
            tips:removeFromParent()
            tipslayer.tipsTag = false
               end)
        end
         end)
    end
  end
  local clickBlankHandler = nil
  tipslayer.setClickBlankHandler = function(l_2_0)
    clickBlankHandler = l_2_0
   end
  tipslayer.setClickBlankHandler(function()
    tipslayer:removeFromParent()
   end)
  local onTouch = function(l_4_0, l_4_1, l_4_2)
    if l_4_0 == "began" then
      return true
    elseif l_4_0 == "moved" then
      return 
    else
      if not tipsbg:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
        tipslayer.onAndroidBack()
      end
    end
   end
  addBackEvent(tipslayer)
  tipslayer.onAndroidBack = function()
    if clickBlankHandler then
      clickBlankHandler()
    else
      tipslayer:removeFromParent()
    end
   end
  tipslayer:setTouchEnabled(true)
  tipslayer:setTouchSwallowEnabled(true)
  tipslayer:registerScriptTouchHandler(onTouch)
  return tipslayer
end

return ui

