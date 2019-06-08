-- Command line was: E:\github\dhgametool\scripts\dhcomponents\EditorComponent.lua 

local dhString = require("dhcomponents.tools.String")
local neverUpdateData = require("dhcomponents.NeverUpdateData")
local EditorComponent = {}
local filePath = "dhcomponents/data/NodeProperty.lua"
local modName = "dhcomponents.data.NodeProperty"
EditorComponent.fullPathForSrcFilename = function(l_1_0, l_1_1)
  local userdata = require("dhcomponents.data.userdata")
  local filepath = userdata.path
  return filepath .. "scripts_raw/" .. l_1_1
end

EditorComponent.writeStringToFile = function(l_2_0, l_2_1, l_2_2)
  local wfile = io.open(l_2_2, "wb")
  if not wfile then
    print("@@@@@create file failed:", l_2_2)
    return 
  end
  wfile:write(l_2_1)
  wfile:flush()
  io.close(wfile)
end

EditorComponent.init = function(l_3_0)
  local nativeUpdateComponent = require("dhcomponents.NativeUpdateComponent")
  local modifyFlag = nativeUpdateComponent:isModify()
  if modifyFlag and neverUpdateData.editorComponentCloneData then
    for key,value in pairs(neverUpdateData.editorComponentCloneData) do
      l_3_0[key] = value
    end
    return 
  end
  local fileListPath = "dhcomponents/data/FileList.lua"
  local fileListMap = {}
  do
    local fileListText = ""
    xpcall(function()
      fileListMap = require("dhcomponents.data.FileList")
      if modifyFlag then
        upvalue_1024 = cc.FileUtils:sharedFileUtils():getStringFromFile(fileListPath)
      end
      end, function()
      fileListMap = {}
      if modifyFlag then
        local fullPath = self:fullPathForSrcFilename(fileListPath)
        upvalue_2048 = "local FileList = {\n}\nreturn FileList\n"
        self:writeStringToFile(fileListText, fullPath)
      end
      end)
    if modifyFlag then
      local deviceId = DeviceUtil:getDeviceId()
      do
        local deviceName = DeviceUtil:getDeviceName()
        l_3_0.deviceId = deviceId
        if not fileListMap[deviceId] then
          local luaTextArray = dhString.split(fileListText, "\n")
          local line =  luaTextArray
          table.insert(luaTextArray, line - 2, string.format("[\"%s\"]=\"%s\",", deviceId, deviceName))
          local text = ""
          local count =  luaTextArray
          for line,value in ipairs(luaTextArray) do
            text = text .. value
            if line ~= count then
              text = text .. "\n"
            end
          end
          local fullPath = l_3_0:fullPathForSrcFilename(fileListPath)
          l_3_0:writeStringToFile(text, fullPath)
          fileListMap[deviceId] = deviceName
        end
      end
    end
    l_3_0.nodeData = {}
    l_3_0.nodeInfoMap = {}
    l_3_0.keyLineMap = {}
    l_3_0.keyFileNameMap = {}
    l_3_0.luaTextMapArray = {}
    for fileName,_ in pairs(fileListMap) do
      local nodeData = {}
      local fileText = ""
      local filePath = "dhcomponents/data/" .. fileName .. ".lua"
      xpcall(function()
        local modName = "dhcomponents.data." .. fileName
        upvalue_512 = require(modName)
        if modifyFlag then
          upvalue_1536 = cc.FileUtils:sharedFileUtils():getStringFromFile(filePath)
        end
         end, function()
        nodeData = {}
        if modifyFlag then
          local fullPath = self:fullPathForSrcFilename(filePath)
          upvalue_2048 = "local NodeProperty = {\n}\nreturn NodeProperty"
          self:writeStringToFile(fileText, fullPath)
        end
         end)
      if nodeData then
        for k,v in pairs(nodeData) do
          assert(l_3_0.nodeData[k] == nil, "key error")
          l_3_0.nodeData[k] = v
        end
      end
      local luaTextArray = {}
      luaTextArray = dhString.split(fileText, "\n")
      l_3_0.luaTextMapArray[fileName] = luaTextArray
      for line,text in ipairs(luaTextArray) do
        if string.find(text, "%['") == 1 then
          local nextPos = string.find(text, "%']")
          if nextPos then
            local key = string.sub(text, 3, nextPos - 1)
            l_3_0.keyLineMap[key] = line
            l_3_0.keyFileNameMap[key] = fileName
          end
        end
      end
    end
    neverUpdateData.editorComponentCloneData = {deviceId = l_3_0.deviceId, nodeData = l_3_0.nodeData, nodeInfoMap = l_3_0.nodeInfoMap, keyLineMap = l_3_0.keyLineMap, keyFileNameMap = l_3_0.keyFileNameMap, luaTextMapArray = l_3_0.luaTextMapArray}
  end
end

EditorComponent.syncTextState = function(l_4_0)
  for _,info in pairs(l_4_0.nodeInfoMap) do
    local key = info.key
    if not l_4_0.nodeData[key] then
      l_4_0.nodeData[key] = {orgInfo = {}}
    end
    local keyInfo = l_4_0.nodeData[key]
    local text = string.format("['%s']={", key)
    local line = l_4_0.keyLineMap[key]
    if info.pos then
      keyInfo.pos = clone(info.pos)
      text = text .. string.format("pos={x=%.3f,y=%.3f}", info.pos.x, info.pos.y)
    end
    if info.angleX then
      keyInfo.angleX = info.angleX
      text = text .. string.format(",angleX=%.3f", info.angleX)
    end
    if info.angleY then
      keyInfo.angleY = info.angleY
      text = text .. string.format(",angleY=%.3f", info.angleY)
    end
    if info.scaleX then
      keyInfo.scaleX = info.scaleX
      text = text .. string.format(",scaleX=%.3f", info.scaleX)
    end
    if info.scaleY then
      keyInfo.scaleY = info.scaleY
      text = text .. string.format(",scaleY=%.3f", info.scaleY)
    end
    if info.anchor then
      keyInfo.anchor = clone(info.anchor)
      text = text .. string.format(",anchor={x=%.3f,y=%.3f}", info.anchor.x, info.anchor.y)
    end
    if info.color then
      keyInfo.color = clone(info.color)
      text = text .. string.format(",color={r=%d,g=%d,b=%d}", info.color.r, info.color.g, info.color.b)
    end
    if info.opacity then
      keyInfo.opacity = info.opacity
      keyInfo.orgInfo.opacity = info.opacity
      text = text .. string.format(",opacity=%d", info.opacity)
    end
    text = text .. "},"
    local fileName = l_4_0.keyFileNameMap[key]
    l_4_0.luaTextMapArray[fileName][line] = text
    for k,value in pairs(keyInfo) do
      if k ~= "orgInfo" then
        keyInfo.orgInfo[k] = clone(value)
      end
    end
  end
end

EditorComponent.writeToFile = function(l_5_0)
  for fileName,luaTextArray in pairs(l_5_0.luaTextMapArray) do
    local text = ""
    local count =  luaTextArray
    for line,value in ipairs(luaTextArray) do
      text = text .. value
      if line ~= count then
        text = text .. "\n"
      end
    end
    local filePath = "dhcomponents/data/" .. fileName .. ".lua"
    local fullPath = cc.FileUtils:sharedFileUtils():fullPathForFilename(filePath)
    if not fullPath or fullPath == "" then
      fullPath = l_5_0:fullPathForSrcFilename(filePath)
    end
    l_5_0:writeStringToFile(text, fullPath)
  end
end

EditorComponent.resetNode = function(l_6_0, l_6_1, l_6_2)
  if l_6_2.pos then
    l_6_1:setPosition(l_6_2.pos)
  end
  if l_6_2.angleX then
    l_6_1:setRotationX(l_6_2.angleX)
  end
  if l_6_2.angleY then
    l_6_1:setRotationY(l_6_2.angleY)
  end
  if l_6_2.scaleX then
    l_6_1:setScaleX(l_6_2.scaleX)
  end
  if l_6_2.scaleY then
    l_6_1:setScaleY(l_6_2.scaleY)
  end
  if l_6_2.anchor then
    l_6_1:setAnchorPoint(cc.p(l_6_2.anchor.x, l_6_2.anchor.y))
  end
  if l_6_2.color then
    l_6_1:setColor(l_6_2.color)
  end
  if l_6_2.opacity then
    l_6_1:setOpacity(l_6_2.opacity)
  end
end

EditorComponent.mandateNode = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if type(l_7_2) == "number" then
    l_7_2 = tostring(l_7_2)
  end
  local info = l_7_0.nodeData[l_7_2]
  if info then
    l_7_0:resetNode(l_7_1, info)
  else
    local luaTextArray = l_7_0.luaTextMapArray[l_7_0.deviceId]
    if not luaTextArray then
      return 
    end
    local line =  luaTextArray
    local x, y = nil, nil
    if l_7_3 then
      x, y = l_7_3.x, l_7_3.y
    else
      local rdMinX = 60
      local rdMaxX = 180
      local rdMinY = 60
      local rdMaxY = 150
      local contentSize = l_7_1:getContentSize()
      if l_7_1:getParent() then
        contentSize = l_7_1:getParent():getContentSize()
      end
      if contentSize.width > 0 then
        rdMaxX = math.max(rdMaxX, contentSize.width - rdMaxX + rdMinX)
      end
      if contentSize.height > 0 then
        rdMaxY = math.max(rdMaxY, contentSize.height - rdMaxY + rdMinY)
      end
      x, y = math.random(rdMinX, rdMaxX), math.random(rdMinY, rdMaxY)
    end
    info = {pos = cc.p(x, y)}
    local value = string.format("['%s']={pos={x=%d,y=%d}},", l_7_2, x, y)
    l_7_0.keyLineMap[l_7_2] = line - 1
    l_7_0.keyFileNameMap[l_7_2] = l_7_0.deviceId
    l_7_1:setPosition(x, y)
    table.insert(luaTextArray, line - 1, value)
    l_7_0:writeToFile()
    l_7_0.nodeData[l_7_2] = info
  end
  info.orgInfo = {pos = cc.p(l_7_1:getPosition()), angleX = l_7_1:getRotationX(), angleY = l_7_1:getRotationY(), scaleX = l_7_1:getScaleX(), scaleY = l_7_1:getScaleY(), anchor = l_7_1:getAnchorPoint(), color = l_7_1:getColor(), opacity = l_7_1:getOpacity()}
  info.key = l_7_2
  l_7_0.nodeInfoMap[l_7_1] = info
end

EditorComponent.endEditor = function(l_8_0)
  if l_8_0.editorLayer then
    l_8_0.editorLayer:runAction(cc.RemoveSelf:create())
    l_8_0.editorLayer = nil
  end
end

EditorComponent.startEditor = function(l_9_0, l_9_1)
  if tolua.isnull(l_9_0.editorLayer) then
    l_9_0.editorLayer = nil
  end
  if not l_9_0.editorLayer then
    l_9_0.editorLayer = require("dhcomponents.layers.EditorLayer").new(l_9_1)
    cc.Director:sharedDirector():getRunningScene():addChild(l_9_0.editorLayer, 10086)
    l_9_0:initOperation()
  end
end

EditorComponent.switchEditorMode = function(l_10_0)
  if l_10_0.editorLayer and not tolua.isnull(l_10_0.editorLayer) then
    l_10_0.editorLayer:removeFromParent()
    l_10_0.editorLayer = nil
  else
    l_10_0.editorLayer = require("dhcomponents.layers.EditorLayer").new()
    cc.Director:sharedDirector():getRunningScene():addChild(l_10_0.editorLayer, 10086)
  end
end

EditorComponent.getAllActiveNode = function(l_11_0)
  for node,_ in pairs(l_11_0.nodeInfoMap) do
    if tolua.isnull(node) then
      l_11_0.nodeInfoMap[node] = nil
    end
  end
  return l_11_0.nodeInfoMap
end

EditorComponent.generateNewKey = function(l_12_0)
  if not EditorComponent.recordKeyMap then
    EditorComponent.recordKeyCount = 0
    EditorComponent.recordKeyMap = {}
  end
  do
    local prevKey = ""
    for i = 1, 4 do
      local rdNum = math.random(1, 7)
      if rdNum == 1 or rdNum == 2 or rdNum == 3 then
        prevKey = prevKey .. string.char(string.byte("a") + math.random(0, 25))
      elseif rdNum == 4 or rdNum == 5 or rdNum == 6 then
        prevKey = prevKey .. string.char(string.byte("A") + math.random(0, 25))
      else
        prevKey = prevKey .. string.char(string.byte("0") + math.random(0, 9))
      end
    end
    print("-----------new key-----------")
    for i = 1, 6 do
      local resKey = nil
      repeat
        repeat
          repeat
            do
              local key = prevKey .. "_"
              for j = 1, 6 do
                local rdNum = math.random(1, 7)
                if rdNum == 1 or rdNum == 2 or rdNum == 3 then
                  key = key .. string.char(string.byte("a") + math.random(0, 25))
                elseif rdNum == 4 or rdNum == 5 or rdNum == 6 then
                  key = key .. string.char(string.byte("A") + math.random(0, 25))
                else
                  key = key .. string.char(string.byte("0") + math.random(0, 9))
                end
              end
            until not l_12_0.keyLineMap[key]
          until not EditorComponent.recordKeyMap[key]
          resKey = key
          EditorComponent.recordKeyMap[key] = true
          EditorComponent.recordKeyCount = EditorComponent.recordKeyCount + 1
          do return end
        end
        do return end
        print(string.format("key(%d) : ", EditorComponent.recordKeyCount), resKey)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EditorComponent.initOperation = function(l_13_0)
  l_13_0.optIndex = 1
  l_13_0.optDataArray = {}
  local cloneNodeInfoMap = {}
  for node,info in pairs(l_13_0.nodeInfoMap) do
    cloneNodeInfoMap[node] = clone(info)
  end
  table.insert(l_13_0.optDataArray, cloneNodeInfoMap)
end

EditorComponent.pushOperation = function(l_14_0, l_14_1)
  for i = l_14_0.optIndex + 1,  l_14_0.optDataArray do
    l_14_0.optDataArray[i] = nil
  end
  local cloneNodeInfoMap = {}
  for node,info in pairs(l_14_1) do
    cloneNodeInfoMap[node] = clone(info.info)
  end
  table.insert(l_14_0.optDataArray, cloneNodeInfoMap)
  l_14_0.optIndex =  l_14_0.optDataArray
  for node,info in pairs(l_14_1) do
    l_14_0.nodeInfoMap[node] = info.info
  end
  l_14_0:syncTextState()
  l_14_0:writeToFile()
end

EditorComponent.resumeOperation = function(l_15_0)
  do
    local nodeInfoMap = l_15_0.optDataArray[l_15_0.optIndex]
    for node,info in pairs(nodeInfoMap) do
      l_15_0.nodeInfoMap[node] = info
    end
    for node,info in pairs(l_15_0.nodeInfoMap) do
      if tolua.isnull(node) then
        l_15_0.nodeInfoMap[node] = nil
        for node,info in (for generator) do
        end
        l_15_0:resetNode(node, info)
      end
      l_15_0:syncTextState()
      l_15_0:writeToFile()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EditorComponent.undoOperation = function(l_16_0)
  if l_16_0.optIndex <= 1 then
    return 
  end
  l_16_0.optIndex = l_16_0.optIndex - 1
  l_16_0:resumeOperation()
end

EditorComponent.redoOperation = function(l_17_0)
  if  l_17_0.optDataArray <= l_17_0.optIndex then
    return 
  end
  l_17_0.optIndex = l_17_0.optIndex + 1
  l_17_0:resumeOperation()
end

EditorComponent:init()
return EditorComponent

