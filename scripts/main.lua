-- Command line was: scripts\main.lua 

tracebackex = function()
  local ret = ""
  do
    local level = 3
    repeat
      do
        local info = debug.getinfo(level, "Sln")
        if not info then
          do return end
        end
        if info.what == "C" then
          ret = ret .. tostring(level) .. "\tC function\n"
        else
          ret = ret .. string.format("\t[%s]:%d `%s`\n", info.source, info.currentline, info.name or "")
        end
        level = level + 1
      end
      do return end
      return ret
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local getBigVersion = function()
  require("version")
  return VERSION_CODE
end

local getUserVersion = function()
  local version = CCUserDefault:sharedUserDefault():getStringForKey("aaVersion")
  return version
end

local str_split = function(l_4_0, l_4_1)
  l_4_0 = tostring(l_4_0)
  l_4_1 = tostring(l_4_1)
  if l_4_0 == "" then
    return false
  end
  if l_4_1 == "" then
    return false
  end
  local pos, arr = 0, {}
  for st,sp in function()
    return string.find(input, delimiter, pos, true)
   end do
    table.insert(arr, string.sub(l_4_0, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(l_4_0, pos))
  return arr
end

local math_round = function(l_5_0)
  return math.floor(l_5_0 + 0.5)
end

local uVersion = getUserVersion()
local bVersion = getBigVersion()
local mgetVersion = function()
  if not uVersion then
    CCUserDefault:sharedUserDefault():setStringForKey("aaVersion", bVersion)
    CCUserDefault:sharedUserDefault():flush()
    uVersion = bVersion
    return bVersion
  end
  local o_arr = str_split(uVersion, ".")
  local v_arr = str_split(bVersion, ".")
  for ii = 1,  v_arr do
    if o_arr and v_arr and o_arr[ii] and v_arr[ii] then
      if math_round(o_arr[ii]) < math_round(v_arr[ii]) then
        return bVersion
      else
        if math_round(v_arr[ii]) < math_round(o_arr[ii]) then
          return uVersion
        end
      end
    end
  end
  return bVersion
end

local cmpVersion = function()
  local mVersion = mgetVersion()
  if uVersion ~= mVersion then
    print("code_version > user version")
    if uVersion and uVersion ~= "" then
      local fUtil = CCFileUtils:sharedFileUtils()
      local upDir = fUtil:getWritablePath() .. uVersion
      local fileOpt = require("common.fileOpt")
      if fileOpt.isDir(upDir) then
        fileOpt.rmdir(upDir)
      end
    end
    CCUserDefault:sharedUserDefault():setStringForKey("aaVersion", mVersion)
    CCUserDefault:sharedUserDefault():flush()
  end
end

cmpVersion()
__G__TRACKBACK__ = function(l_8_0)
  local traceback_str = tracebackex()
  print("----------------------------------------")
  print("LUA ERROR: " .. tostring(l_8_0))
  print(traceback_str)
  print("----------------------------------------")
  require("common.func")
  reportException(tostring(l_8_0), tostring(l_8_0) .. "\n" .. traceback_str)
end

local getAppDir = function()
  local prefix = "scripts/"
  if not HHUtils:isCryptoEnabled() then
    prefix = "scripts_raw/"
  end
  local file = prefix .. "shop.lua"
  local path = CCFileUtils:sharedFileUtils():fullPathForFilename(file)
  return path:sub(1, not  file - 1)
end

local refreshSearchPaths = function(l_10_0)
  local fileOpt = require("common.fileOpt")
  local fUtil = CCFileUtils:sharedFileUtils()
  fUtil:removeAllPaths()
  local appDir = getAppDir()
  local suffix = "/"
  if not HHUtils:isCryptoEnabled() then
    suffix = "_raw/"
  end
  if l_10_0 and l_10_0 ~= "" then
    local upDir = fUtil:getWritablePath() .. l_10_0
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

local version = CCUserDefault:sharedUserDefault():getStringForKey("aaVersion")
refreshSearchPaths(version)
local main = function()
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
  CCDirector:sharedDirector():setDisplayStats(false)
  DHPayment:getInstance():init(PAYMENT_GOOGLE)
  local scene = CCScene:create()
  scene:addChild(require("ui.login.logo").create())
  if CCDirector:sharedDirector():getRunningScene() then
    CCDirector:sharedDirector():replaceScene(scene)
  else
    CCDirector:sharedDirector():runWithScene(scene)
  end
end

xpcall(main, __G__TRACKBACK__)

