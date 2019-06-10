-- Command line was: E:\github\dhgametool\scripts\ui\activitylimit\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local activityData = require("data.activity")
local activitylimitData = require("data.activitylimit")
local cfglimitgift = require("config.limitgift")
local shopData = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = activityData.IDS
local LIMITIDS = activitylimitData.IDS
local refreshSelf = function(l_1_0)
  local parent_obj = l_1_0:getParent()
  l_1_0:removeFromParentAndCleanup(true)
end

local getItems = function()
  return {IDS.FIRST_PAY.ID = {id = IDS.FIRST_PAY.ID, group = IDS.FIRST_PAY.ID, name = "FIRST_PAY", icon = img.ui.limit_first_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_1_0)
    l_1_0:removeAllChildrenWithCleanup(true)
    l_1_0:runAction(CCCallFunc:create(function()
      local firstpayrewardlayer = require("ui.firstpay.main")
      local pop = firstpayrewardlayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.GRADE_24.ID = {id = LIMITIDS.GRADE_24.ID, group = LIMITIDS.GRADE_24.ID, name = "GRADE_24", icon = img.ui.limit_grade_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_2_0)
    l_2_0:removeAllChildrenWithCleanup(true)
    l_2_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.grade")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.GRADE_24.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.GRADE_32.ID = {id = LIMITIDS.GRADE_32.ID, group = LIMITIDS.GRADE_32.ID, name = "GRADE_32", icon = img.ui.limit_grade_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_3_0)
    l_3_0:removeAllChildrenWithCleanup(true)
    l_3_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.grade")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.GRADE_32.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.GRADE_48.ID = {id = LIMITIDS.GRADE_48.ID, group = LIMITIDS.GRADE_48.ID, name = "GRADE_48", icon = img.ui.limit_grade_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_4_0)
    l_4_0:removeAllChildrenWithCleanup(true)
    l_4_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.grade")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.GRADE_48.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.GRADE_58.ID = {id = LIMITIDS.GRADE_58.ID, group = LIMITIDS.GRADE_58.ID, name = "GRADE_58", icon = img.ui.limit_grade_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_5_0)
    l_5_0:removeAllChildrenWithCleanup(true)
    l_5_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.grade")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.GRADE_58.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.GRADE_78.ID = {id = LIMITIDS.GRADE_78.ID, group = LIMITIDS.GRADE_78.ID, name = "GRADE_78", icon = img.ui.limit_grade_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_6_0)
    l_6_0:removeAllChildrenWithCleanup(true)
    l_6_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.grade")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.GRADE_78.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.LEVEL_3_15.ID = {id = LIMITIDS.LEVEL_3_15.ID, group = LIMITIDS.LEVEL_3_15.ID, name = "LEVEL_3_15", icon = img.ui.limit_level_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_7_0)
    l_7_0:removeAllChildrenWithCleanup(true)
    l_7_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.level")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.LEVEL_3_15.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.SUMMON_4.ID = {id = LIMITIDS.SUMMON_4.ID, group = LIMITIDS.SUMMON_4.ID, name = "SUMMON_4", icon = img.ui.limit_summon_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_8_0)
    l_8_0:removeAllChildrenWithCleanup(true)
    l_8_0:runAction(CCCallFunc:create(function()
      local summonlayer = require("ui.activitylimit.summon")
      local pop = summonlayer.create(cfglimitgift[LIMITIDS.SUMMON_4.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, LIMITIDS.SUMMON_5.ID = {id = LIMITIDS.SUMMON_5.ID, group = LIMITIDS.SUMMON_5.ID, name = "SUMMON_5", icon = img.ui.limit_summon_icon, description = i18n.global.limitactivity_limitgift.string, tapFunc = function(l_9_0)
    l_9_0:removeAllChildrenWithCleanup(true)
    l_9_0:runAction(CCCallFunc:create(function()
      local gradelayer = require("ui.activitylimit.summon")
      local pop = gradelayer.create(cfglimitgift[LIMITIDS.SUMMON_5.ID].parameter, function()
        refreshSelf(parent_obj)
         end)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_CASINO.ID = {id = IDS.SCORE_CASINO.ID, group = IDS.SCORE_CASINO.ID, name = "SCORE_CASINO", icon = img.ui.activity_icon_casino, description = i18n.global.activity_des_casino.string, tapFunc = function(l_10_0)
    l_10_0:removeAllChildrenWithCleanup(true)
    l_10_0:runAction(CCCallFunc:create(function()
      local scorecasinolayer = require("ui.activity.scoreCasino")
      local pop = scorecasinolayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_FIGHT.ID = {id = IDS.SCORE_FIGHT.ID, group = IDS.SCORE_FIGHT.ID, icon = img.ui.activity_icon_fight, description = i18n.global.activity_des_fight.string, tapFunc = function(l_11_0)
    l_11_0:removeAllChildrenWithCleanup(true)
    l_11_0:runAction(CCCallFunc:create(function()
      local scorefightlayer = require("ui.activity.scoreFight")
      local pop = scorefightlayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.VP_1.ID = {id = IDS.VP_1.ID, group = IDS.VP_1.ID, icon = img.ui.activity_icon_vp, description = i18n.global.activity_des_vp.string, tapFunc = function(l_12_0)
    l_12_0:removeAllChildrenWithCleanup(true)
    l_12_0:runAction(CCCallFunc:create(function()
      local valuepacklayer = require("ui.activity.valuePack")
      local pop = valuepacklayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.BLACKBOX_1.ID = {id = IDS.BLACKBOX_1.ID, group = IDS.BLACKBOX_1.ID, icon = img.ui.activity_icon_summer, description = i18n.global.activity_des_secbox.string, tapFunc = function(l_13_0)
    l_13_0:removeAllChildrenWithCleanup(true)
    l_13_0:runAction(CCCallFunc:create(function()
      local pplayer = require("ui.activity.blackbox")
      local pop = pplayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_TARVEN_4.ID = {id = IDS.SCORE_TARVEN_4.ID, group = IDS.SCORE_TARVEN_4.ID, icon = img.ui.activity_icon_tarven, description = i18n.global.activity_des_tarven.string, tapFunc = function(l_14_0)
    l_14_0:removeAllChildrenWithCleanup(true)
    l_14_0:runAction(CCCallFunc:create(function()
      local scoretarvenlayer = require("ui.activity.scoreTarven")
      local pop = scoretarvenlayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FORGE_1.ID = {id = IDS.FORGE_1.ID, group = IDS.FORGE_1.ID, icon = img.ui.activity_icon_forge, description = i18n.global.activity_des_forge.string, tapFunc = function(l_15_0)
    l_15_0:removeAllChildrenWithCleanup(true)
    l_15_0:runAction(CCCallFunc:create(function()
      local forgelayer = require("ui.activity.forge")
      local pop = forgelayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SUMMON_HERO_1.ID = {id = IDS.SUMMON_HERO_1.ID, group = IDS.SUMMON_HERO_1.ID, icon = img.ui.acticity_icon_summonmimu, description = i18n.global.activity_des_summon.string, tapFunc = function(l_16_0)
    l_16_0:removeAllChildrenWithCleanup(true)
    l_16_0:runAction(CCCallFunc:create(function()
      local activity_summon = require("ui.activity.summon")
      local pop = activity_summon.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_SUMMON.ID = {id = IDS.SCORE_SUMMON.ID, group = IDS.SCORE_SUMMON.ID, icon = img.ui.activity_icon_summon_score, description = i18n.global.activity_des_summon_score.string, tapFunc = function(l_17_0)
    l_17_0:removeAllChildrenWithCleanup(true)
    l_17_0:runAction(CCCallFunc:create(function()
      local scoresummon = require("ui.activity.scoreSummon")
      local pop = scoresummon.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.CRUSHING_SPACE_1.ID = {id = IDS.CRUSHING_SPACE_1.ID, group = IDS.CRUSHING_SPACE_1.ID, icon = img.ui.activity_icon_crush1, description = i18n.global.broken_space_name1.string, tapFunc = function(l_18_0)
    l_18_0:removeAllChildrenWithCleanup(true)
    l_18_0:runAction(CCCallFunc:create(function()
      local crushboss1 = require("ui.activity.crushboss1")
      local pop = crushboss1.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.CRUSHING_SPACE_2.ID = {id = IDS.CRUSHING_SPACE_2.ID, group = IDS.CRUSHING_SPACE_2.ID, icon = img.ui.activity_icon_crush2, description = i18n.global.broken_space_name2.string, tapFunc = function(l_19_0)
    l_19_0:removeAllChildrenWithCleanup(true)
    l_19_0:runAction(CCCallFunc:create(function()
      local crushboss2 = require("ui.activity.crushboss2")
      local pop = crushboss2.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.CRUSHING_SPACE_3.ID = {id = IDS.CRUSHING_SPACE_3.ID, group = IDS.CRUSHING_SPACE_3.ID, icon = img.ui.activity_icon_crush3, description = i18n.global.broken_space_name3.string, tapFunc = function(l_20_0)
    l_20_0:removeAllChildrenWithCleanup(true)
    l_20_0:runAction(CCCallFunc:create(function()
      local crushboss3 = require("ui.activity.crushboss3")
      local pop = crushboss3.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FISHBABY_1.ID = {id = IDS.FISHBABY_1.ID, group = IDS.FISHBABY_1.ID, icon = img.ui.activity_icon_element, description = i18n.global.activity_des_element.string, tapFunc = function(l_21_0)
    l_21_0:removeAllChildrenWithCleanup(true)
    l_21_0:runAction(CCCallFunc:create(function()
      local fish = require("ui.activity.elementAltar")
      local pop = fish.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.CHRISTMAS_1.ID = {id = IDS.CHRISTMAS_1.ID, group = IDS.CHRISTMAS_1.ID, icon = img.ui.acticity_icon_anniversary, description = i18n.global.activity_des_flowercake.string, tapFunc = function(l_22_0)
    l_22_0:removeAllChildrenWithCleanup(true)
    l_22_0:runAction(CCCallFunc:create(function()
      local tinysnowman = require("ui.activity.tinysnowman")
      local pop = tinysnowman.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.ICEBABY_1.ID = {id = IDS.ICEBABY_1.ID, group = IDS.ICEBABY_1.ID, icon = img.ui.activity_icon_tinyhome, description = i18n.global.activity_des_sweethome.string, tapFunc = function(l_23_0)
    l_23_0:removeAllChildrenWithCleanup(true)
    l_23_0:runAction(CCCallFunc:create(function()
      local fish = require("ui.activity.pumpkin")
      local pop = fish.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FOLLOW.ID = {id = IDS.FOLLOW.ID, group = IDS.FOLLOW.ID, icon = img.ui.activity_icon_fb, description = i18n.global.follow_reward.string, tapFunc = function(l_24_0)
    l_24_0:removeAllChildrenWithCleanup(true)
    l_24_0:runAction(CCCallFunc:create(function()
      local follow = require("ui.activity.follow")
      local pop = follow.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_SPESUMMON.ID = {id = IDS.SCORE_SPESUMMON.ID, group = IDS.SCORE_SPESUMMON.ID, icon = img.ui.activity_icon_spesummon, description = i18n.global.activity_des_spesummon.string, tapFunc = function(l_25_0)
    l_25_0:removeAllChildrenWithCleanup(true)
    l_25_0:runAction(CCCallFunc:create(function()
      local spesummon = require("ui.activity.scoreSpesummon")
      local pop = spesummon.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.EXCHANGE.ID = {id = IDS.EXCHANGE.ID, group = IDS.EXCHANGE.ID, icon = img.ui.activity_icon_exchange, description = i18n.global.activity_des_exchange.string, tapFunc = function(l_26_0)
    l_26_0:removeAllChildrenWithCleanup(true)
    l_26_0:runAction(CCCallFunc:create(function()
      local exchange = require("ui.activity.exchange")
      local pop = exchange.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.AWAKING_GLORY_1.ID = {id = IDS.AWAKING_GLORY_1.ID, group = IDS.AWAKING_GLORY_1.ID, icon = img.ui.activity_icon_awaking_glory, description = i18n.global.activity_des_awaking_glory.string, tapFunc = function(l_27_0)
    l_27_0:removeAllChildrenWithCleanup(true)
    l_27_0:runAction(CCCallFunc:create(function()
      local awakinglayer = require("ui.activity.awakingGlory")
      local pop = awakinglayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.HERO_SUMMON_1.ID = {id = IDS.HERO_SUMMON_1.ID, group = IDS.HERO_SUMMON_1.ID, icon = img.ui.activity_icon_hero_summon, description = i18n.global.activity_des_hero_summon.string, tapFunc = function(l_28_0)
    l_28_0:removeAllChildrenWithCleanup(true)
    l_28_0:runAction(CCCallFunc:create(function()
      local heroSummonlayer = require("ui.activity.heroSummon")
      local pop = heroSummonlayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.TENCHANGE.ID = {id = IDS.TENCHANGE.ID, group = IDS.TENCHANGE.ID, icon = img.ui.activity_icon_change, description = i18n.global.activity_des_tenplace.string, tapFunc = function(l_29_0)
    l_29_0:removeAllChildrenWithCleanup(true)
    l_29_0:runAction(CCCallFunc:create(function()
      local tenchangelayer = require("ui.activity.tenchange")
      local pop = tenchangelayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.BLACKCARD.ID = {id = IDS.BLACKCARD.ID, group = IDS.BLACKCARD.ID, icon = img.ui.acticity_icon_anniversarycard, description = i18n.global.activity_des_anniversarycard.string, tapFunc = function(l_30_0)
    l_30_0:removeAllChildrenWithCleanup(true)
    l_30_0:runAction(CCCallFunc:create(function()
      local blackcardlayer = require("ui.activity.blackcard")
      local pop = blackcardlayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.ASYLUM_1.ID = {id = IDS.ASYLUM_1.ID, group = IDS.ASYLUM_1.ID, icon = img.ui.activity_icon_asylum, description = i18n.global.activity_asylum_title.string, tapFunc = function(l_31_0)
    l_31_0:removeAllChildrenWithCleanup(true)
    l_31_0:runAction(CCCallFunc:create(function()
      local asylum = require("ui.activity.asylum")
      local pop = asylum.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.NEWYEAR.ID = {id = IDS.NEWYEAR.ID, group = IDS.NEWYEAR.ID, icon = img.ui.activity_icon_stonetablet, description = i18n.global.activity_des_hallowmas_sugar.string, tapFunc = function(l_32_0)
    l_32_0:removeAllChildrenWithCleanup(true)
    l_32_0:runAction(CCCallFunc:create(function()
      local newyear = require("ui.activity.newyear")
      local pop = newyear.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.WEEKYEARBOX_1.ID = {id = IDS.WEEKYEARBOX_1.ID, group = IDS.WEEKYEARBOX_1.ID, icon = img.ui.acticity_icon_weekbox, description = i18n.global.activity_des_weekyearbox.string, tapFunc = function(l_33_0)
    l_33_0:removeAllChildrenWithCleanup(true)
    l_33_0:runAction(CCCallFunc:create(function()
      local newyear = require("ui.activity.weekbox")
      local pop = newyear.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.DWARF_1.ID = {id = IDS.DWARF_1.ID, group = IDS.DWARF_1.ID, icon = img.ui.acticity_icon_dwarf, description = i18n.global.activity_des_dwarf.string, tapFunc = function(l_34_0)
    l_34_0:removeAllChildrenWithCleanup(true)
    l_34_0:runAction(CCCallFunc:create(function()
      local dwarf = require("ui.activity.dwarf")
      local pop = dwarf.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.DWARF_1.ID = {id = IDS.DWARF_1.ID, group = IDS.DWARF_1.ID, icon = img.ui.acticity_icon_dwarf, description = i18n.global.activity_des_dwarf.string, tapFunc = function(l_35_0)
    l_35_0:removeAllChildrenWithCleanup(true)
    l_35_0:runAction(CCCallFunc:create(function()
      local dwarf = require("ui.activity.dwarf")
      local pop = dwarf.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.MID_AUTUMN.ID = {id = IDS.MID_AUTUMN.ID, group = IDS.MID_AUTUMN.ID, icon = img.ui.activity_mid_autumn_icon, description = i18n.global.mid_autumn.string, tapFunc = function(l_36_0)
    l_36_0:removeAllChildrenWithCleanup(true)
    l_36_0:runAction(CCCallFunc:create(function()
      local midautumn = require("ui.activity.midautumn").create()
      midautumn:setTouchEnabled(true)
      midautumn:setTouchSwallowEnabled(false)
      parent_obj:addChild(midautumn, 1000)
      end))
   end}, IDS.MID_AUTUMN_GIFT.ID = {id = IDS.MID_AUTUMN_GIFT.ID, group = IDS.MID_AUTUMN_GIFT.ID, icon = img.ui.activity_mid_autumn_gift_icon, description = i18n.global.mid_autumn_gift.string, tapFunc = function(l_37_0)
    l_37_0:removeAllChildrenWithCleanup(true)
    l_37_0:runAction(CCCallFunc:create(function()
      local midautumngift = require("ui.activity.midautumngift").create()
      midautumngift:setTouchEnabled(true)
      midautumngift:setTouchSwallowEnabled(false)
      parent_obj:addChild(midautumngift, 1000)
      end))
   end}, IDS.MID_AUTUMN_LOGIN_1.ID = {id = IDS.MID_AUTUMN_LOGIN_1.ID, group = IDS.MID_AUTUMN_LOGIN_1.ID, icon = img.ui.activity_mid_autumn_login_icon, description = i18n.global.mid_autumn_login.string, tapFunc = function(l_38_0)
    l_38_0:removeAllChildrenWithCleanup(true)
    l_38_0:runAction(CCCallFunc:create(function()
      local midautumnlogin = require("ui.activity.midautumnlogin").create()
      midautumnlogin:setTouchEnabled(true)
      midautumnlogin:setTouchSwallowEnabled(false)
      parent_obj:addChild(midautumnlogin, 1000)
      end))
   end}, IDS.NATIONAL_DAY_LOGIN.ID = {id = IDS.NATIONAL_DAY_LOGIN.ID, group = IDS.NATIONAL_DAY_LOGIN.ID, icon = img.ui.activity_national_day_login_icon, description = i18n.global.national_day_login.string, tapFunc = function(l_39_0)
    l_39_0:removeAllChildrenWithCleanup(true)
    l_39_0:runAction(CCCallFunc:create(function()
      local midautumnlogin = require("ui.activity.nationaldaylogin").create()
      midautumnlogin:setTouchEnabled(true)
      midautumnlogin:setTouchSwallowEnabled(false)
      parent_obj:addChild(midautumnlogin, 1000)
      end))
   end}, IDS.HALLOWMAS_PARTY_1.ID = {id = IDS.HALLOWMAS_PARTY_1.ID, group = IDS.HALLOWMAS_PARTY_1.ID, icon = img.ui.acticity_icon_hallowmas_party, description = i18n.global.activity_des_hallowmas_party.string, tapFunc = function(l_40_0)
    l_40_0:removeAllChildrenWithCleanup(true)
    l_40_0:runAction(CCCallFunc:create(function()
      local pplayer = require("ui.activity.hallowmasparty")
      local pop = pplayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.TREASURES.ID = {id = IDS.TREASURES.ID, group = IDS.TREASURES.ID, name = "TREASURES", icon = img.ui.acticity_icon_treasure, description = i18n.global.activity_des_treasure.string, tapFunc = function(l_41_0)
    l_41_0:removeAllChildrenWithCleanup(true)
    l_41_0:runAction(CCCallFunc:create(function()
      local treasurelayer = require("ui.activity.treasures")
      local pop = treasurelayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.DINNER.ID = {id = IDS.DINNER.ID, group = IDS.DINNER.ID, name = "DINNER", icon = img.ui.activity_icon_dinner, description = i18n.global.activity_des_dinner.string, tapFunc = function(l_42_0)
    l_42_0:removeAllChildrenWithCleanup(true)
    l_42_0:runAction(CCCallFunc:create(function()
      local dinner = require("ui.activity.dinner")
      local pop = dinner.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.THANKSGIVINGGIFT.ID = {id = IDS.THANKSGIVINGGIFT.ID, group = IDS.THANKSGIVINGGIFT.ID, name = "THANKSGIVINGGIFT", icon = img.ui.activity_icon_thansgiving, description = i18n.global.activity_des_thanksgiving.string, tapFunc = function(l_43_0)
    l_43_0:removeAllChildrenWithCleanup(true)
    l_43_0:runAction(CCCallFunc:create(function()
      local thankslayer = require("ui.activity.thanksgift")
      local pop = thankslayer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FRIDAY_CARD.ID = {id = IDS.FRIDAY_CARD.ID, group = IDS.FRIDAY_CARD.ID, icon = img.ui.activity_icon_friday_card, description = i18n.global.activity_des_friday_card.string, tapFunc = function(l_44_0)
    l_44_0:removeAllChildrenWithCleanup(true)
    l_44_0:runAction(CCCallFunc:create(function()
      local layer = require("ui.activity.fridaycard")
      local pop = layer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FRIDAY_HAPPY_1.ID = {id = IDS.FRIDAY_HAPPY_1.ID, group = IDS.FRIDAY_HAPPY_1.ID, icon = img.ui.activity_icon_friday_happy, description = i18n.global.activity_des_friday_happy.string, tapFunc = function(l_45_0)
    l_45_0:removeAllChildrenWithCleanup(true)
    l_45_0:runAction(CCCallFunc:create(function()
      local layer = require("ui.activity.fridayhappy")
      local pop = layer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FRIDAY_VIP_1.ID = {id = IDS.FRIDAY_VIP_1.ID, group = IDS.FRIDAY_VIP_1.ID, icon = img.ui.activity_icon_friday_vip, description = i18n.global.activity_des_friday_vip.string, tapFunc = function(l_46_0)
    l_46_0:removeAllChildrenWithCleanup(true)
    l_46_0:runAction(CCCallFunc:create(function()
      local layer = require("ui.activity.fridayvip")
      local pop = layer.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}}
end

ui.create = function(l_3_0)
  local all_items = getItems()
  local activity_items = {}
  local touch_items = {}
  local item_count = 0
  local padding = 5
  local item_width = 100
  local item_height = 120
  local init = function()
    do
      local groups = {}
      for _,tmp_item in pairs(all_items) do
        if tmp_item.group ~= IDS.FIRST_PAY.ID and ((tmp_item.group == IDS.FOLLOW.ID and not isChannel()) or tmp_item.group == IDS.SOCKS_1.ID) then
          if groups[tmp_item.group] then
            for _,tmp_item in (for generator) do
            end
            groups[tmp_item.group] = tmp_item.group
            do
              local item_status = activityData.getStatusById(tmp_item.id)
              if item_status and item_status.status ~= 2 and item_status.cd and os.time() - activityData.pull_time < item_status.cd then
                upvalue_1536 = item_count + 1
                activity_items[item_count] = tmp_item
                activity_items[item_count].status = item_status
                for _,tmp_item in (for generator) do
                end
                if item_status and item_status.status ~= 2 and tmp_item.nocd then
                  upvalue_1536 = item_count + 1
                  activity_items[item_count] = tmp_item
                  activity_items[item_count].status = item_status
                  for _,tmp_item in (for generator) do
                  end
                  print("======================================if 3")
                end
                for _,tmp_item in (for generator) do
                end
                if groups[tmp_item.group] then
                  for _,tmp_item in (for generator) do
                  end
                  groups[tmp_item.group] = tmp_item.group
                  local item_status = activitylimitData.getStatusById(tmp_item.id)
                  if item_status and item_status.status == 0 and item_status.cd and os.time() - activityData.pull_time < item_status.cd then
                    upvalue_1536 = item_count + 1
                    activity_items[item_count] = tmp_item
                    activity_items[item_count].status = item_status
                    for _,tmp_item in (for generator) do
                    end
                    if item_status and item_status.status == 0 and tmp_item.nocd then
                      upvalue_1536 = item_count + 1
                      activity_items[item_count] = tmp_item
                      activity_items[item_count].status = item_status
                      for _,tmp_item in (for generator) do
                      end
                      print("======================================if 3")
                    end
                    table.sort(activity_items, function(l_1_0, l_1_1)
                    return l_1_0.id < l_1_1.id
                           end)
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  init()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY * 0.8))
  layer:addChild(darkbg)
  local moneybar = require("ui.moneybar")
  layer:addChild(moneybar.create(), 101)
  local content_layer = CCLayer:create()
  content_layer:setTouchEnabled(true)
  content_layer:setTouchSwallowEnabled(false)
  layer:addChild(content_layer, 100)
  local board = img.createUISprite(img.ui.activity_board)
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(scalep(480, 0))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local backEvent = function()
    layer:removeFromParent()
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setScale(view.minScale)
  btn_close:setPosition(scalep(928, 506))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  layer:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  local bar_icon = img.createUISprite(img.ui.activity_bar_icon)
  bar_icon:setAnchorPoint(CCPoint(0.5, 0))
  bar_icon:setPosition(CCPoint(200, 484))
  board:addChild(bar_icon)
  local lbl_bar = lbl.createFont2(22, i18n.global.limitactivity_board_title.string, ccc3(250, 216, 105))
  lbl_bar:setPosition(CCPoint(200, 471))
  board:addChild(lbl_bar)
  local createItem = function(l_4_0)
    local tmp_item = img.createUISprite(img.ui.activity_item_bg)
    local tmp_item_w = tmp_item:getContentSize().width
    local tmp_item_h = tmp_item:getContentSize().height
    local tmp_item_sel = img.createUISprite(img.ui.activity_item_bg_sel)
    tmp_item_sel:setPosition(CCPoint(tmp_item_w / 2, tmp_item_h / 2))
    tmp_item:addChild(tmp_item_sel)
    tmp_item.sel = tmp_item_sel
    tmp_item_sel:setVisible(false)
    if l_4_0.id == IDS.FOLLOW.ID and (APP_CHANNEL == "IAS" or i18n.getCurrentLanguage() == kLanguageChinese) then
      l_4_0.icon = img.ui.activity_icon_weibo
    end
    local item_icon = img.createUISprite(l_4_0.icon)
    item_icon:setPosition(CCPoint(40, tmp_item_h / 2))
    tmp_item:addChild(item_icon, 1)
    local lbl_description = lbl.create({font = 1, size = 12, text = l_4_0.description, color = ccc3(115, 59, 5), cn = {size = 16}, us = {size = 14}, tw = {size = 16}})
    if l_4_0.nocd then
      lbl_description:setAnchorPoint(CCPoint(0, 0.5))
      lbl_description:setPosition(CCPoint(94, tmp_item_h / 2))
    else
      lbl_description:setAnchorPoint(CCPoint(0, 0))
      lbl_description:setPosition(CCPoint(94, tmp_item_h / 2))
    end
    tmp_item:addChild(lbl_description, 2)
    local lbl_cd = lbl.create({font = 2, size = 10, text = "", color = ccc3(181, 244, 59), cn = {size = 14}, us = {size = 12}, tw = {size = 14}})
    lbl_cd:setAnchorPoint(CCPoint(0, 1))
    lbl_cd:setPosition(CCPoint(94, tmp_item_h / 2 - 2))
    tmp_item:addChild(lbl_cd, 1)
    tmp_item.lbl_cd = lbl_cd
    addRedDot(tmp_item, {px = tmp_item:getContentSize().width - 5, py = tmp_item:getContentSize().height - 10})
    delRedDot(tmp_item)
    return tmp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 290, height = 359}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(53, 74))
  board:addChild(scroll)
  layer.scroll = scroll
  local showList = function(l_5_0)
    for ii = 1, #l_5_0 do
      if ii == 1 then
        scroll.addSpace(4)
      end
      local tmp_item = createItem(l_5_0[ii])
      touch_items[#touch_items + 1] = tmp_item
      tmp_item.obj = l_5_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 145
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(padding - 3)
      end
    end
   end
  showList(activity_items)
  scroll.setOffsetBegin()
  layer.onAndroidBack = function()
    backEvent()
   end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
    if item_count == 0 then
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  local last_touch_sprite, last_sel_sprite = nil, nil
  local clearShaderForItem = function(l_10_0)
    if l_10_0 and not tolua.isnull(l_10_0) then
      clearShader(l_10_0, true)
      l_10_0 = nil
    end
   end
  local setShaderForItem = function(l_11_0)
    setShader(l_11_0, SHADER_HIGHLIGHT, true)
    last_touch_sprite = l_11_0
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_12_0, l_12_1)
    touchbeginx, upvalue_512 = l_12_0, l_12_1
    upvalue_1024 = true
    if not scroll or tolua.isnull(scroll) then
      return true
    end
    local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_12_0, l_12_1))
    for ii = 1, #touch_items do
      if touch_items[ii]:boundingBox():containsPoint(p1) then
        upvalue_2560 = touch_items[ii]
      end
    end
    return true
   end
  local onTouchMoved = function(l_13_0, l_13_1)
    if isclick and (math.abs(touchbeginx - l_13_0) > 10 or math.abs(touchbeginy - l_13_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_14_0, l_14_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      last_touch_sprite = nil
    end
    local p0 = layer:convertToNodeSpace(ccp(l_14_0, l_14_1))
    if isclick and not board:boundingBox():containsPoint(p0) then
      backEvent()
    elseif isclick then
      local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_14_0, l_14_1))
      for ii = 1, #touch_items do
        if touch_items[ii]:boundingBox():containsPoint(p1) then
          if last_sel_sprite and last_sel_sprite == touch_items[ii] then
            return 
          elseif last_sel_sprite and not tolua.isnull(last_sel_sprite) and last_sel_sprite.sel and not tolua.isnull(last_sel_sprite.sel) then
            last_sel_sprite.sel:setVisible(false)
          end
          audio.play(audio.button)
          touch_items[ii].sel:setVisible(true)
          touch_items[ii].obj.tapFunc(content_layer)
          upvalue_3584 = touch_items[ii]
          if touch_items[ii].obj.status then
            touch_items[ii].obj.status.read = 1
          end
        end
      end
    end
   end
  local onTouch = function(l_15_0, l_15_1, l_15_2)
    if l_15_0 == "began" then
      return onTouchBegan(l_15_1, l_15_2)
    elseif l_15_0 == "moved" then
      return onTouchMoved(l_15_1, l_15_2)
    else
      return onTouchEnded(l_15_1, l_15_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  local last_check_time = 0
  local updateCountDown = function()
    if os.time() - last_check_time < 1 then
      return 
    end
    last_check_time = os.time()
    for ii = 1, #touch_items do
      local item_status = touch_items[ii].obj.status
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if item_status.id == IDS.FIRST_PAY.ID and item_status.status ~= 2 then
        if item_status.cd and item_status.cd < os.time() - activityData.pull_time then
          item_status.status = 2
          refreshSelf(layer)
        elseif item_status.cd then
          local count_down = item_status.cd - (os.time() - activityData.pull_time)
          do
            local time_str = time2string(count_down)
            if count_down <= 2592000 then
              touch_items[ii].lbl_cd:setString(time_str)
            end
            do return end
            if item_status.status == 0 then
              if item_status.cd and item_status.cd < os.time() - activityData.pull_time then
                item_status.status = 1
                refreshSelf(layer)
              elseif item_status.cd then
                local count_down = item_status.cd - (os.time() - activityData.pull_time)
                local time_str = time2string(count_down)
                if count_down <= 2592000 then
                  touch_items[ii].lbl_cd:setString(time_str)
                end
              end
            end
          end
        end
      end
      local tmp_status = item_status
      if touch_items[ii].obj.redFunc then
        if touch_items[ii].obj.redFunc() then
          addRedDot(touch_items[ii], {px = touch_items[ii]:getContentSize().width - 5, py = touch_items[ii]:getContentSize().height - 10})
        else
          delRedDot(touch_items[ii])
        end
      elseif tmp_status and tmp_status.read and tmp_status.read == 0 then
        addRedDot(touch_items[ii], {px = touch_items[ii]:getContentSize().width - 5, py = touch_items[ii]:getContentSize().height - 10})
      else
        delRedDot(touch_items[ii])
      end
    end
   end
  local onUpdate = function(l_17_0)
    updateCountDown()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local showActivity = function(l_18_0)
    if touch_items[l_18_0].sel and not tolua.isnull(touch_items[l_18_0].sel) then
      touch_items[l_18_0].sel:setVisible(true)
    end
    touch_items[l_18_0].obj.tapFunc(content_layer)
    upvalue_1024 = touch_items[l_18_0]
    if touch_items[l_18_0].obj.status then
      touch_items[l_18_0].obj.status.read = 1
    end
   end
  if #touch_items > 0 then
    if l_3_0 then
      for i = 1, #touch_items do
        if l_3_0 == "brokenboss" and touch_items[i].obj.id == IDS.CRUSHING_SPACE_1.ID then
          showActivity(i)
        end
      end
    else
      showActivity(1)
    end
  end
  return layer
end

return ui

