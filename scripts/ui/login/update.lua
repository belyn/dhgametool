-- Command line was: E:\github\dhgametool\scripts\ui\login\update.lua 

local ui = {}
local cjson = json
require("config")
require("framework.init")
require("common.const")
require("common.func")
local view = require("common.view")
local fileOpt = require("common.fileOpt")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local userdata = require("data.userdata")
local heartbeat = require("data.heartbeat")
ui.create = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local layer = CCLayer:create()
  img.loadAll(img.packedLogin.common)
  img.loadAll(img.packedLogin.home)
  audio.stopBackgroundMusic()
  CCDirector:sharedDirector():getScheduler():setTimeScale(1)
  local suffix = "_us"
  if isAmazon() then
    suffix = "_us"
  else
    if isOnestore() then
      suffix = "_us"
    elseif APP_CHANNEL and APP_CHANNEL ~= "" then
      suffix = "_cn"
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        suffix = "_cn"
      else
        if i18n.getCurrentLanguage() == kLanguageChineseTW then
          suffix = "_cn"
        end
      end
    end
  end
  layer:addChild(require("ui.login.accelerometer").create())
  local hintBg = img.createLogin9Sprite(img.login.text_border_2)
  local hintWidth = view.physical.w
  hintBg:setPreferredSize(CCSize(hintWidth, 38 * view.minScale))
  hintBg:setAnchorPoint(ccp(0, 0))
  hintBg:setPosition(0, 0)
  layer:addChild(hintBg)
  local hint = lbl.createMixFont2(18, "", ccc3(255, 247, 229), true)
  hint:setPosition(view.midX, scaley(17))
  layer:addChild(hint)
  autoLayoutShift(hint)
  layer.setHint = function(l_1_0)
    if not tolua.isnull(hint) then
      hint:setString(l_1_0)
    end
   end
  local progressBg = img.createLogin9Sprite(img.login.login_bar_bg)
  progressBg:setPreferredSize(CCSizeMake(960, 4))
  progressBg:setScaleX(view.xScale)
  progressBg:setScaleY(view.minScale)
  progressBg:setAnchorPoint(ccp(0.5, 0))
  progressBg:setPosition(view.midX, 0)
  layer:addChild(progressBg)
  local progress0 = img.createLoginSprite(img.login.login_bar_fg)
  local progress = createProgressBar(progress0)
  progress:setScaleX(view.xScale)
  progress:setScaleY(view.minScale)
  progress:setPosition(view.midX, progressBg:boundingBox():getMidY())
  layer:addChild(progress)
  layer.setPercentageForProgress = function(l_2_0)
    if not tolua.isnull(progress) then
      progress:setPercentage(l_2_0)
    end
   end
  local vlabel = lbl.createFont2(16, getVersion(), ccc3(255, 251, 217), true)
  vlabel:setAnchorPoint(ccp(1, 0))
  vlabel:setPosition(view.maxX, scaley(2))
  layer:addChild(vlabel, 1)
  autoLayoutShift(vlabel)
  net:close()
  net:setDialogEnable(false)
  heartbeat.stop()
  schedule(layer, function()
    local isDone = false
    local isSwitchServer = sid ~= nil
    require("ui.login.auth").start({sid = sid, extra = extra}, function(l_1_0, l_1_1, l_1_2)
      if not isDone then
        isDone = true
        if l_1_0 == "ok" then
          if isSwitchServer then
            userdata.clearWhenSwitchAccount()
          end
          ui.check(layer, checkFile, l_1_1, l_1_2)
        else
          ui.popErrorDialog(l_1_0, checkFile)
        end
      end
      end, layer.setHint)
    schedule(layer, NET_TIMEOUT, function()
      if not isDone then
        isDone = true
        ui.popErrorDialog(i18n.global.error_network_timeout.string, checkFile)
      end
      end)
   end)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      do return end
    end
    if l_4_0 == "exit" then
      img.unload("spine_ui_gyro_1")
      img.unload("spine_ui_gyro_2")
    end
   end)
  return layer
end

ui.check = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local v, uv, cv, compare = getVersionDetail()
  print("ui.login.update version", v, "userVersion", uv, "codeVersion", cv, compare)
  if compare < 0 then
    fileOpt.rmfile(CCFileUtils:sharedFileUtils():getWritablePath() .. uv)
    userdata.setString(userdata.keys.version, v)
  end
  if l_2_1 then
    l_2_0.setHint(i18n.global.filecheck_list.string)
  else
    l_2_0.setHint(i18n.global.update_check.string)
  end
  local isDone = false
  local upName = ui.getPackageName()
  net:up({sid = l_2_3, vsn = op3(l_2_1, cv, v), packagename = upName}, function(l_1_0)
    if isDone then
      return 
    end
    isDone = true
    if l_1_0.status ~= 0 then
      if checkFile then
        layer.setHint(i18n.global.filecheck_fail.string .. " net:up " .. l_1_0.status)
      else
        layer.setHint(i18n.global.update_fail.string .. " net:up " .. l_1_0.status)
        return 
      end
      if compareVersion(l_1_0.vsn, op3(checkFile, cv, v)) <= 0 then
        print("ui.login.update latest")
        layer:addChild(require("ui.login.loading").create(uid, sid))
        return 
      end
      if l_1_0.lv == 2 then
        print("ui.login.update gotoAppStore")
        net:close()
        gotoAppStore(l_1_0.vsn)
        return 
      end
      if l_1_0.lv == 0 then
        print("ui.login.update needUpdate")
        net:close()
        ui.update(layer, checkFile, op3(checkFile, cv, v), l_1_0)
        return 
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  schedule(l_2_0, NET_TIMEOUT * 20, function()
    if not isDone then
      isDone = true
      ui.popErrorDialog(i18n.global.error_network_timeout.string, checkFile)
    end
   end)
end

ui.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local newV = l_3_3.vsn
  local oldDir = CCFileUtils:sharedFileUtils():getWritablePath() .. l_3_2 .. "/"
  local newDir = CCFileUtils:sharedFileUtils():getWritablePath() .. newV .. "/"
  local onSuccess = function()
    fileOpt.rmfile(CCFileUtils:sharedFileUtils():getWritablePath() .. oldV)
    userdata.setString(userdata.keys.version, newV)
    if not tolua.isnull(layer) then
      schedule(layer, function()
      ui.refresh(newV)
      local tscene = require("ui.login.update").create(false, nil, time)
      tscene.nocheck = true
      replaceScene(tscene)
      end)
    end
   end
  local progressCb = function(l_2_0)
    local percent = l_2_0 or 0
    if checkFile then
      layer.setHint(i18n.global.filechecking.string .. " " .. percent .. "%")
    else
      layer.setHint(i18n.global.updating.string .. " " .. percent .. "%")
    end
    if layer.setPercentageForProgress then
      layer.setPercentageForProgress(percent)
    end
   end
  local updateFile = function(l_3_0)
    local info = upInfo.files[l_3_0]
    local percent = math.floor(l_3_0 / #upInfo.files * 100)
    if checkFile then
      layer.setHint(i18n.global.filechecking.string .. " " .. percent .. "%")
    else
      layer.setHint(i18n.global.updating.string .. " " .. percent .. "%")
    end
    if layer.setPercentageForProgress then
      layer.setPercentageForProgress(percent)
    end
    local goNext = function(l_1_0)
      if l_1_0 < #upInfo.files then
        updateFile(l_1_0 + 1)
      else
        onSuccess()
      end
      end
    if ui.checkFile(newDir, info) then
      goNext(l_3_0)
    else
      if ui.checkFile(oldDir, info) and ui.copyFile(oldDir, newDir, info) then
        goNext(l_3_0)
      else
        ui.downFile(newDir, upInfo.prefix, info, function(l_2_0)
        if l_2_0 == "ok" then
          goNext(i)
        else
          local err = nil
          if checkFile then
            err = i18n.global.filecheck_fail.string
          else
            err = i18n.global.update_fail.string
          end
          layer.setHint(err)
          ui.popErrorDialog(err, checkFile)
        end
         end)
      end
    end
   end
  if l_3_3.upList and l_3_3.upList ~= "" then
    local listfile = l_3_3.prefix .. l_3_3.upList
    ui.getHttpContent(listfile, function(l_4_0)
      if not l_4_0 then
        local err = nil
        if checkFile then
          err = i18n.global.filecheck_fail.string
        else
          err = i18n.global.update_fail.string
        end
        layer.setHint(err)
        ui.popErrorDialog(err, checkFile)
        return 
      end
      local tfiles = cjson.decode(l_4_0)
      upInfo.files = tfiles
      if upInfo.files and #upInfo.files > 0 then
        ui.thDownload({layer = layer, newDir = newDir, oldDir = oldDir, upInfo = upInfo, progressCb = progressCb, successCb = onSuccess, checkFile = checkFile})
      else
        onSuccess()
      end
      end)
  elseif l_3_3.files and #l_3_3.files > 0 then
    ui.thDownload({layer = l_3_0, newDir = newDir, oldDir = oldDir, upInfo = l_3_3, progressCb = progressCb, successCb = onSuccess, checkFile = l_3_1})
  else
    onSuccess()
  end
end

ui.checkFile = function(l_4_0, l_4_1)
  local file = l_4_0 .. l_4_1.path
  return not fileOpt.isFile(file) or crypto.md5file(file) == l_4_1.md5
end

ui.copyFile = function(l_5_0, l_5_1, l_5_2)
  if fileOpt.cpfile(l_5_0 .. l_5_2.path, l_5_1 .. l_5_2.path) and ui.checkFile(l_5_1, l_5_2) then
    return true
  end
  return false
end

ui.getHttpContent = function(l_6_0, l_6_1)
  local sendRequest = function(l_1_0)
    local request = CCHTTPRequest:createWithUrl(function(l_1_0)
      if l_1_0.name ~= "inprogress" then
        if l_1_0.name == "completed" and l_1_0.request:getResponseStatusCode() == 200 then
          local data = l_1_0.request:getResponseData()
          handler(data)
          return 
        end
        if count == 2 then
          handler()
        else
          sendRequest(count + 1)
        end
      end
      end, url, kCCHTTPRequestMethodGET)
    request:setTimeout(180 * l_1_0)
    request:start()
   end
  sendRequest(1)
end

ui.downFile = function(l_7_0, l_7_1, l_7_2, l_7_3)
  local sendRequest = function(l_1_0)
    local request = CCHTTPRequest:createWithUrl(function(l_1_0)
      if l_1_0.name ~= "inprogress" then
        if l_1_0.name == "completed" and l_1_0.request:getResponseStatusCode() == 200 then
          local data = l_1_0.request:getResponseData()
          if fileOpt.writeFile(data, dir .. info.path) and ui.checkFile(dir, info) then
            handler("ok")
            return 
          end
        end
        if count == 2 then
          handler("error")
        else
          sendRequest(count + 1)
        end
      end
      end, prefix .. info.md5, kCCHTTPRequestMethodGET)
    request:setTimeout(180 * l_1_0)
    request:start()
   end
  sendRequest(1)
end

ui.refresh = function(l_8_0)
  local nativeUpdateComponent = require("dhcomponents.NativeUpdateComponent")
  if not nativeUpdateComponent:isModify() then
    ui.refreshSearchPaths(l_8_0)
  end
  ui.clearLoaded()
  ui.loadBasic()
end

ui.refreshSearchPaths = function(l_9_0)
  local fUtil = CCFileUtils:sharedFileUtils()
  fUtil:removeAllPaths()
  local appDir = ui.getAppDir()
  local suffix = op3(HHUtils:isCryptoEnabled(), "/", "_raw/")
  if l_9_0 then
    local upDir = fUtil:getWritablePath() .. l_9_0
    if fileOpt.isDir(upDir) then
      fUtil:addSearchPath(upDir .. "/scripts" .. suffix)
      fUtil:addSearchPath(upDir .. "/res" .. suffix)
    end
  end
  fUtil:addSearchPath(appDir .. "scripts" .. suffix)
  fUtil:addSearchPath(appDir .. "res" .. suffix)
  if HHUtils.initCN then
    HHUtils:initCN("spinejson", "spinejson/zh")
  end
  fUtil:printSearchPaths()
end

ui.getAppDir = function()
  local file = "scripts/shop.lua"
  local path = CCFileUtils:sharedFileUtils():fullPathForFilename(file)
  return path:sub(1, not #file - 1)
end

ui.clearLoaded = function()
  net:close()
  DHSkeletonDataCache:getInstance():purgeCache()
  CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
  CCTextureCache:sharedTextureCache():removeAllTextures()
  CCLabelBMFont:purgeCachedData()
  local whitelist = {"string", "io", "pb", "bit", "os", "debug", "table", "math", "package", "coroutine", "pack", "jit", "jit.util", "jit.opt", "main"}
  for p,_ in pairs(package.loaded) do
    if not arraycontains(whitelist, p) then
      package.loaded[p] = nil
    end
  end
end

ui.loadBasic = function()
  require("config")
  require("framework.init")
  require("version")
  require("common.const")
  require("common.func")
end

ui.popErrorDialog = function(l_13_0, l_13_1)
  popReconnectDialog(l_13_0, function()
    local tscene = require("ui.login.update").create(checkFile)
    tscene.nocheck = true
    replaceScene(tscene)
   end)
end

ui.getPackageName = function()
  if not isChannel() then
    if APP_CHANNEL and APP_CHANNEL == "IAS" then
      return "adtt"
    else
      if not HHUtils:isReleaseMode() then
        return "ad"
      else
        if device.platform == "android" then
          return "ad_google"
        else
          if device.platform == "ios" then
            return "ad_ios"
          end
        end
      end
      return 
    end
    do
      local sdkcfg = require("common.sdkcfg")
      if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].upName then
        return sdkcfg[APP_CHANNEL].upName
      end
      return 
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.thDownload = function(l_15_0)
  local layer = l_15_0.layer
  local newDir = l_15_0.newDir
  local oldDir = l_15_0.oldDir
  local upInfo = l_15_0.upInfo
  local progressCb = l_15_0.progressCb
  local successCb = l_15_0.successCb
  local checkFile = l_15_0.checkFile
  local total = #upInfo.files
  local workers = 8
  if upInfo.thcount and upInfo.thcount > 1 then
    workers = upInfo.thcount
  end
  local createWorker = function(l_1_0)
    local worker = {}
    worker.id = l_1_0
    local status = 0
    worker.assignTask = function(l_1_0)
      status = 1
      if ui.checkFile(newDir, l_1_0) then
        status = 2
      else
        if ui.checkFile(oldDir, l_1_0) and ui.copyFile(oldDir, newDir, l_1_0) then
          status = 2
        else
          ui.downFile(newDir, upInfo.prefix, l_1_0, function(l_1_0)
          if l_1_0 == "ok" then
            status = 2
          else
            status = -1
            local err = nil
            if checkFile then
              err = i18n.global.filecheck_fail.string
            else
              err = i18n.global.update_fail.string
            end
            local eventInfo = {event_type = "update", event_name = "down file error", silence = "1", event_value = {file = upInfo.prefix .. (info.md5 or ""), path = newDir .. (info.path or "")}}
            reportEvent(eventInfo)
            layer.setHint(err)
            ui.popErrorDialog(err, checkFile)
          end
            end)
        end
      end
      end
    worker.status = function(l_2_0)
      if l_2_0 then
        status = l_2_0
      end
      return status
      end
    return worker
   end
  local idle_workers = {}
  for i = 1, workers do
    idle_workers[i] = createWorker(i)
  end
  local running_workers = {}
  local findIdleWorker = function()
    if #idle_workers <= 0 then
      return 
    end
    return idle_workers[#idle_workers]
   end
  local run2idle = function(l_3_0)
    for k,v in pairs(running_workers) do
      if v == l_3_0 then
        table.remove(running_workers, k)
      end
    end
    table.insert(idle_workers, l_3_0)
   end
  local idle2running = function(l_4_0)
    for k,v in pairs(idle_workers) do
      if v == l_4_0 then
        table.remove(idle_workers, k)
      end
    end
    table.insert(running_workers, l_4_0)
   end
  local dlSchedule = function()
    local finish = 0
    local current = 0
    local dlCheck = function()
      if total <= finish then
        progressCb(100)
        successCb()
        return 
      end
      if current < total then
        local _w = findIdleWorker()
        if _w then
          idle2running(_w)
          _w.assignTask(upInfo.files[current + 1])
          upvalue_2048 = current + 1
        end
      end
      do
        local finish_workers = {}
        for k,v in pairs(running_workers) do
          if v.status() == 2 then
            table.insert(finish_workers, v)
            for k,v in (for generator) do
            end
            if v.status() < 0 then
              return 
            end
          end
          for k,v in pairs(finish_workers) do
            v.status(0)
            run2idle(v)
            finish = finish + 1
            progressCb(math.floor(finish * 100 / total))
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    local sublayer = CCLayer:create()
    sublayer:setTouchEnabled(true)
    sublayer:setTouchSwallowEnabled(false)
    sublayer:scheduleUpdateWithPriorityLua(function()
      dlCheck()
      end)
    layer:addChild(sublayer)
   end
  dlSchedule()
end

return ui

