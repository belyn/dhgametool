-- Command line was: E:\github\dhgametool\scripts\dhcomponents\NativeUpdateComponent.lua 

local NativeUpdateComponent = {}
NativeUpdateComponent.EVENT_RESTART = "DHCOM_EVENT_RESTART"
NativeUpdateComponent.EVENT_RESTART_CLEAN_UP = "DHCOM_EVENT_RESTART_CLEAN_UP"
NativeUpdateComponent.init = function(l_1_0)
  local app = cc.Application:sharedApplication()
  local target = app:getTargetPlatform()
  if target == 2 then
    l_1_0.modifyFlag = true
    local userdata = require("dhcomponents.data.userdata")
    local filepath = userdata.path
    cc.FileUtils:getInstance():removeAllPaths()
    cc.FileUtils:getInstance():addSearchPath(filepath .. "scripts_raw/")
    cc.FileUtils:getInstance():addSearchPath(filepath .. "res_raw/")
  end
end

NativeUpdateComponent.isModify = function(l_2_0)
  return l_2_0.modifyFlag == true
end

NativeUpdateComponent.restart = function(l_3_0, l_3_1)
  if not l_3_0:isModify() then
    return 
  end
  if l_3_1 then
    local textureCache = CCTextureCache:sharedTextureCache()
    textureCache:removeAllTextures()
    CCNotificationCenter:sharedNotificationCenter():postNotification(NativeUpdateComponent.EVENT_RESTART_CLEAN_UP)
  end
  CCNotificationCenter:sharedNotificationCenter():postNotification(NativeUpdateComponent.EVENT_RESTART)
  local schedulerUtil = require("dhcomponents.tools.SchedulerUtil")
  schedulerUtil:unscheduleAll()
  l_3_0:clearModules()
  cc.Director:sharedDirector():popToRootScene()
  if netClient then
    netClient:close()
  end
  if l_3_1 then
    require("main")
  else
    replaceScene(require("ui.login.update").create(nil, nil))
  end
end

NativeUpdateComponent.clearModules = function(l_4_0)
  local __g = _G
  setmetatable(__g, {})
  local whitelist = {string = true, io = true, pb = true, bit = true, os = true, debug = true, table = true, math = true, package = true, coroutine = true, pack = true, jit = true, jit.util = true, jit.opt = true, dhcomponents.NeverUpdateData = true}
  for p,_ in pairs(package.loaded) do
    if not whitelist[p] then
      package.loaded[p] = nil
    end
  end
end

NativeUpdateComponent:init()
return NativeUpdateComponent

