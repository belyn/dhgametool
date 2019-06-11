-- Command line was: E:\github\dhgametool\scripts\ui\hero\karma.lua 

local karma = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfglink = require("config.link")
local cfgequip = require("config.equip")
local cfgexphero = require("config.exphero")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
karma.create = function(l_1_0)
  local layer = CCLayer:create()
  local board = img.createUI9Sprite(img.ui.hero_bg)
  board:setAnchorPoint(ccp(0, 0))
  board:setPreferredSize(CCSize(428, 503))
  board:setPosition(465, 35)
  layer:addChild(board)
  local title = lbl.createFont3(24, "FETTERS", ccc3(230, 208, 174))
  title:setPosition(214, 474)
  board:addChild(title)
  local height = 970
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(32, 42)
  scroll:setViewSize(CCSize(368, 394))
  scroll:setContentSize(CCSize(368, height))
  scroll:setContentOffset(ccp(0, 394 - height))
  board:addChild(scroll)
  local link = {}
  if cfghero[l_1_0.id].linkId then
    link[#link + 1] = cfghero[l_1_0.id].linkId
  end
  for i = 1, 10 do
    local showKarmaBg = img.createUI9Sprite(img.ui.botton_fram_2)
    showKarmaBg:setPreferredSize(CCSize(363, 87))
    showKarmaBg:setAnchorPoint(ccp(0, 0))
    showKarmaBg:setPosition(1, height - i * 97)
    scroll:getContainer():addChild(showKarmaBg)
    local showSkill = img.createSkill(101)
    showSkill:setAnchorPoint(ccp(0, 0))
    showSkill:setPosition(18, 9)
    showKarmaBg:addChild(showSkill)
    local showSkillName = lbl.createFont1(18, "Tiger Heros:", ccc3(90, 50, 30))
    showSkillName:setAnchorPoint(ccp(0, 0))
    showSkillName:setPosition(95, 57)
    showKarmaBg:addChild(showSkillName)
    for j = 1, 3 do
      local showHero = img.createHeroHead(1101)
      showHero:setScale(0.5)
      showHero:setAnchorPoint(ccp(0, 0))
      showHero:setPosition(95 + 51 * (j - 1), 10)
      showKarmaBg:addChild(showHero)
    end
  end
  return layer
end

return karma

