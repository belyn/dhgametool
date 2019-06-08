-- Command line was: E:\github\dhgametool\scripts\ui\shop\privacy.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local shop = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local ltext = "Terms Of Service & Privacy Policy##\n--------------------------------------------------##\nDroidhang respects and protects the privacy of all users who use the service. In order to provide you with more accurate and personalized service, Droidhang will use and disclose your personal information in accordance with this Privacy Policy. But Droidhang will be a high degree of diligence, prudent duty to treat this information. Except as otherwise provided in this Privacy Policy, Droidhang will not disclose or provide such information to third parties without your prior permission. Droidhang will update this privacy policy from time to time. When you agree to the Droidhang Service Agreement, you are deemed to have agreed to the entire contents of this Privacy Policy. This Privacy Policy is an integral part of the Droidhang Service Agreement.##\n1. Applicable scope##\na) when you register Droidhang account, you are required to provide personal registration information according to Droidhang;##\nb) Droidhang automatically receives and records information on your browser and computer when you use the Droidhang web service or access the Droidhang platform web pages, including but not limited to your IP address, the type of browser, the language used, Access date and time, hardware and software feature information and web page records of your needs;##\nc) User personal data obtained by Droidhang from a business partner through legal means.##\nYou understand and agree that the following information does not apply to this Privacy Policy:##\na) the keyword information you entered when using the search service provided by the Droidhang platform;##\nb) Droidhang collected information on your information released by Droidhang, including but not limited to participation in activities, transaction information and evaluation details;##\nc) Violation of legal requirements or violation of Droidhang rules and Droidhang has taken action on you.##\n2. Information use##\na) Droidhang will not provide, sell, rent, share or trade your personal information to any unrelated third party unless you have received your permission, or the third party and the Droidhang (including Droidhang affiliates), either individually or jointly, , And after the end of the service, it will be prohibited from accessing all of the information that it has previously been able to access.##\nb) Droidhang does not allow any third party to collect, edit, sell or distribute your personal information in any way. Any Droidhang platform users such as engaged in the above activities, once discovered, Droidhang has the right to immediately terminate the service agreement with the user.##\nc) For the purpose of serving the user, Droidhang may use your personal information to provide you with information of interest, including but not limited to sending you product and service information, or sharing information with Droidhang partners so that they may send you Information about its products and services (the latter requires your prior consent).##\n3. Information disclosure##\nDroidhang will disclose your personal information in whole or in part on your personal or legal requirements in the following cases:##\na) disclose to third parties with your prior consent;##\nb) to share your personal information with third parties to provide the products and services you require;##\nc) disclosure to a third party or administrative or judicial body in accordance with the relevant provisions of the law or at the request of the administrative or judicial body;##\nd) if you appear in violation of China's relevant laws, regulations or Droidhang service agreement or the relevant rules, the need to disclose to a third party;##\ne) If you are a qualified IP Complainant and have filed a complaint, the Respondent shall be required to disclose it to the Respondent so that both parties may handle possible rights disputes;##\nf) In a transaction created on the Droidhang platform, if any party fulfills or partially fulfills the transaction obligation and makes a request for information disclosure, Droidhang has the right to decide to provide the user with the necessary information such as the contact information of the other party To facilitate the completion of the transaction or the settlement of the dispute.##\ng) other Droidhang deemed appropriate disclosure under the laws, regulations or website policies.##\n4. Information storage and exchange##\nDroidhang's information and information about you will be kept on Droidhang and  or its affiliated servers. These information and materials may be sent to your country, region or Droidhang to collect information and information from and outside of the country , Storage and display.##\n5. Use of cookies##\na) Droidhang will set or access cookies on your computer if you do not accept cookies##\nSo that you can log in or use Droidhang platform services or features that rely on cookies. Droidhang uses cookies to provide you with a more thoughtful personalized service, including promotion services. b) You have the right to accept or refuse to accept cookies. You can refuse to accept cookies by modifying your browser settings. However, if you choose to accept cookies, you may not be able to log in or use Droidhang web services or features that rely on cookies.##\nc) The information provided by Droidhang will be subject to this policy.##\n6. Information security##\na) Droidhang account has security features, please keep your user name and password information. Droidhang will be through the user password encryption and other security measures to ensure that your information is not lost, not to be abused and altered. In spite of the foregoing safety measures, please also note that there is no sound security measures on the information network.##\nb) When using the Droidhang web service for online trading, you will inevitably disclose your personal information, such as contact information or postal address, to the counterparty or potential counterparty. Please protect your personal information and provide it to others only if necessary. If you find your personal information leak, especially Droidhang user name and password leak, please contact Droidhang customer service, so that Droidhang take appropriate measures."
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(255, 255, 255, 255))
  layer:addChild(darkbg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local backEvent = function()
    layer:removeFromParent()
   end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    backEvent()
   end)
  local scroll_params = {width = 900, height = 500}
  local lineScroll = require("ui.lineScroll")
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(30, 10))
  bg:addChild(scroll, 100)
  local createItem = function(l_3_0)
    l_3_0 = string.trim(l_3_0)
    local msg = lbl.create({kind = "ttf", size = 18, text = l_3_0, color = ccc3(0, 0, 0), width = 880, align = kCCTextAlignmentLeft})
    local item = CCSprite:create()
    local msg_h = msg:getContentSize().height
    item:setContentSize(CCSizeMake(880, msg_h + 5))
    msg:setAnchorPoint(CCPoint(0, 0))
    msg:setPosition(CCPoint(0, 0))
    item:addChild(msg)
    item.height = msg_h + 5
    return item
   end
  local blocks = string.split(ltext, "##")
  for ii = 1,  blocks do
    local tmp_item = createItem(blocks[ii])
    scroll.addItem(tmp_item)
  end
  scroll.setOffsetBegin()
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

