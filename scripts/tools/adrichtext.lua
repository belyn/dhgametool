-- Command line was: E:\github\dhgametool\scripts\tools\adrichtext.lua 

local RichText = {ELEMENT_TYPE = {LABELTTF = "LabelTTF", LABELBMF = "LabelBMF", NEWLINE = "NewLine", IMAGE = "Image", IMAGEPLIST = "ImagePlist"}, HORIZONTAL_ALIGNMENT = {LEFT = 1, CENTER = 2, RIGHT = 3}, WRAP_MODE = {WRAP_PER_WORD = 1, WRAP_PER_CHAR = 2}}
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local img = require("res.img")
local ASCII_DOUBLE_QUOTATION_MARK = 34
local ASCII_NUMBER_SIGN = 35
local LABEL_TYPE_TTF = 1
local LABEL_TYPE_BMF = 2
local LABEL_TYPE_MIX = 3
local IMAGE_TYPE_LOCAL = 1
local IMAGE_TYPE_PLIST = 2
local DEFAULT_FONT_SIZE = 24
local DEFAULT_COLOR = ccc3(255, 255, 255)
local DEFAULT_OPACITY = 255
local getAttribute = function(l_1_0, l_1_1)
  local value = nil
  local startIndex = string.find(l_1_0, l_1_1)
  if startIndex then
    local endIndex = string.find(l_1_0, " ", startIndex + 1)
    if endIndex then
      value = string.sub(l_1_0, startIndex +  l_1_1 + 1, endIndex - 1)
    else
      value = string.sub(l_1_0, startIndex +  l_1_1 + 1)
    end
    if string.byte(value, 1) == ASCII_DOUBLE_QUOTATION_MARK then
      if string.byte(value, -1) == ASCII_DOUBLE_QUOTATION_MARK then
        value = string.sub(value, 2,  value - 1)
      else
        value = string.sub(value, 2,  value)
      end
    else
      if string.byte(value, -1) == ASCII_DOUBLE_QUOTATION_MARK then
        value = string.sub(value, 1,  value - 1)
      end
    end
  end
  return value
end

local colorCodeToRGBA = function(l_2_0)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

  end
  do return end
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  return not l_2_0 or l_2_0 == "" or 255, 255, not tonumber(string.sub(l_2_0, 1 + 1 + 2, 1 + 1 + 3), 16) and tonumber(string.sub(l_2_0, 1 + 1 + 4, 1 + 1 + 5), 16) or 255, tonumber(string.sub(l_2_0, 1 + 1 + 6, 1 + 1 + 7), 16) or 255
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

local stringToSize = function(l_3_0)
  local width, height = string.match(l_3_0, "(%-*%d+%.*%d*),(%-*%d+%.*%d*)")
  if width and height then
    return CCSize(tonumber(width), tonumber(height))
  else
    return CCSize(0, 0)
  end
end

local getByteCount = function(l_4_0)
  local curByte = string.byte(l_4_0)
  local byteCount = 1
  if curByte == nil then
    byteCount = 0
  elseif curByte > 240 then
    byteCount = 4
  elseif curByte > 224 then
    byteCount = 3
  elseif curByte > 192 then
    byteCount = 2
  end
  return byteCount
end

local isNumberOrLetter = function(l_5_0)
  if string.find(string.sub(l_5_0, 1, 1), "%w") then
    return true
  else
    return false
  end
end

local isUTF8CharWrappable = function(l_6_0)
  return (getByteCount(l_6_0) <= 1 and #isNumberOrLetter(l_6_0))
end

local getNextWordPos = function(l_7_0, l_7_1)
  if  l_7_0 <= l_7_1 + 1 then
    return  l_7_0
  end
  for i = l_7_1 + 1,  l_7_0 do
    if isUTF8CharWrappable(l_7_0[i]) then
      return i
    end
  end
  return  l_7_0
end

local getPrevWordPos = function(l_8_0, l_8_1)
  if l_8_1 <= 0 then
    return -1
  end
  for i = l_8_1 - 1, 1, -1 do
    if isUTF8CharWrappable(l_8_0[i]) then
      return i
    end
  end
  return -1
end

local isWrappable = function(l_9_0)
  local success = false
  for k,v in ipairs(l_9_0) do
    if isUTF8CharWrappable(v) then
      success = true
  else
    end
  end
  return success
end

local findSplitPositionForWord = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  if l_10_4 <= 0 then
    return  l_10_1
  end
  local startingNewLine = l_10_4 == l_10_3
  return isWrappable(l_10_1) or (startingNewLine and  l_10_1) or 0
  local idx = getNextWordPos(l_10_1, l_10_2)
  local leftStr = table.concat(l_10_1, "", 1, idx)
  l_10_0:setString(leftStr)
  local scale = l_10_0:getScale()
  do
    local textRendererWidth = l_10_0:getContentSize().width * scale
    if l_10_3 < textRendererWidth then
      repeat
        local newidx = getPrevWordPos(l_10_1, idx)
        if newidx >= 0 then
          leftStr = table.concat(l_10_1, "", 1, newidx)
          l_10_0:setString(leftStr)
          textRendererWidth = l_10_0:getContentSize().width * scale
          if textRendererWidth <= l_10_3 then
            return newidx
          end
          idx = newidx
        elseif not startingNewLine or not idx then
           -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

        end
        return 0
      end
    elseif textRendererWidth < l_10_3 then
      repeat
        local newidx = getNextWordPos(l_10_1, idx)
        leftStr = table.concat(l_10_1, "", 1, newidx)
        l_10_0:setString(leftStr)
        textRendererWidth = l_10_0:getContentSize().width * scale
        if textRendererWidth < l_10_3 then
          if newidx ==  l_10_1 then
            return newidx
          end
          idx = newidx
        elseif l_10_3 >= textRendererWidth or not idx then
           -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

        end
        return newidx
      else
        return idx
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local findSplitPositionForChar = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4)
  if l_11_4 <= 0 then
    return  l_11_1
  end
  local startingNewLine = l_11_4 == l_11_3
  local stringLength =  l_11_1
  local leftLength = l_11_2
  local leftStr = table.concat(l_11_1, "", 1, leftLength)
  l_11_0:setString(leftStr)
  local scale = l_11_0:getScale()
  local textRendererWidth = l_11_0:getContentSize().width * scale
  if l_11_3 < textRendererWidth then
    repeat
      if leftLength > 0 then
        leftLength = leftLength - 1
        leftStr = table.concat(l_11_1, "", 1, leftLength)
        l_11_0:setString(leftStr)
        textRendererWidth = l_11_0:getContentSize().width * scale
      until textRendererWidth <= l_11_3
      do return end
    end
  elseif textRendererWidth < l_11_3 then
    repeat
      repeat
        if leftLength < stringLength then
          leftLength = leftLength + 1
          leftStr = table.concat(l_11_1, "", 1, leftLength)
          l_11_0:setString(leftStr)
          textRendererWidth = l_11_0:getContentSize().width * scale
          if l_11_3 < textRendererWidth then
            leftLength = leftLength - 1
            do return end
        until l_11_3 == textRendererWidth
        else
          do return end
        end
    end
  end
  if not startingNewLine or not 1 then
    return leftLength > 0 or 0
    return leftLength
  end
end

RichText.create = function(l_12_0)
  local instance = {}
  setmetatable(instance, l_12_0)
  l_12_0.__index = l_12_0
  instance:ctor()
  return instance
end

RichText.ctor = function(l_13_0)
  l_13_0.renderNode = CCNode:create()
  l_13_0.customSize = CCSize(0, 0)
  l_13_0.richElements = {}
  l_13_0.elementRenders = {}
  l_13_0.lineHeights = {}
  l_13_0.formatTextDirty = false
  l_13_0.leftSpaceWidth = 0
  l_13_0.wrapMode = RichText.WRAP_MODE.WRAP_PER_WORD
  l_13_0.verticalSpace = 0
  l_13_0.fontSize = DEFAULT_FONT_SIZE
  l_13_0.alignment = RichText.HORIZONTAL_ALIGNMENT.LEFT
end

RichText.setAnchorPoint = function(l_14_0, l_14_1)
  l_14_0.renderNode:setAnchorPoint(l_14_1)
end

RichText.setContentSize = function(l_15_0, l_15_1)
  l_15_0.customSize = l_15_1
  l_15_0.renderNode:setContentSize(l_15_1)
end

RichText.setPosition = function(l_16_0, l_16_1)
  l_16_0.renderNode:setPosition(l_16_1)
end

RichText.addChild = function(l_17_0, l_17_1)
  l_17_0.renderNode:addChild(l_17_1)
end

RichText.getRenderNode = function(l_18_0)
  return l_18_0.renderNode
end

RichText.setWrapMode = function(l_19_0, l_19_1)
  l_19_0.wrapMode = l_19_1
end

RichText.getWrapMode = function(l_20_0, l_20_1)
  return l_20_0.wrapMode
end

RichText.setVerticalSpace = function(l_21_0, l_21_1)
  l_21_0.verticalSpace = l_21_1
end

RichText.getVerticalSpace = function(l_22_0)
  return l_22_0.verticalSpace
end

RichText.setScale = function(l_23_0, l_23_1)
  if l_23_0.renderNode then
    l_23_0.renderNode:setScale(l_23_1)
  end
end

RichText.runAction = function(l_24_0, l_24_1)
  if l_24_0.renderNode then
    l_24_0.renderNode:runAction(l_24_1)
  end
end

RichText.getContentSize = function(l_25_0)
  if l_25_0.renderNode then
    return l_25_0.renderNode:getContentSize()
  else
    return CCSize(0, 0)
  end
end

RichText.setCascadeOpacityEnabled = function(l_26_0, l_26_1)
  if l_26_0.renderNode then
    l_26_0.renderNode:setCascadeOpacityEnabled(l_26_1)
  end
end

RichText.isCascadeOpacityEnabled = function(l_27_0)
  if l_27_0.renderNode then
    return l_27_0.renderNode:isCascadeOpacityEnabled()
  end
  return false
end

RichText.createLabelTTFElement = function(l_28_0, l_28_1)
  l_28_1.type = RichText.ELEMENT_TYPE.LABELTTF
  l_28_1.scale = l_28_1.scale or 1
  l_28_1.color = l_28_1.color or DEFAULT_COLOR
  l_28_1.opacity = l_28_1.opacity or DEFAULT_OPACITY
  return l_28_1
end

RichText.createLabelBMFElement = function(l_29_0, l_29_1)
  if not l_29_1.lang then
    local lang = i18n.getLanguageShortName()
  end
  if lbl.isHaveBMFontRes(lang, l_29_1.fontIndex) then
    l_29_1.type = RichText.ELEMENT_TYPE.LABELBMF
    l_29_1.fontName = lbl.getFontName(lang, l_29_1.fontIndex)
    local bmfSize = lbl.getFontSize(l_29_1.fontIndex)
    local scale = l_29_1.scale or 1
    local fontSize = l_29_1.size
    if fontSize and bmfSize > 0 then
      scale = scale * fontSize / bmfSize
    else
      l_29_1.size = bmfSize
    end
    l_29_1.scale = scale
  else
    l_29_1.type = RichText.ELEMENT_TYPE.LABELTTF
    l_29_1.fontName = ""
    l_29_1.scale = l_29_1.scale or 1
  end
  l_29_1.color = l_29_1.color or DEFAULT_COLOR
  l_29_1.opacity = l_29_1.opacity or DEFAULT_OPACITY
  return l_29_1
end

RichText.createLabelMixElement = function(l_30_0, l_30_1)
  local labelType = getAttribute(fontParamStr, "type")
  if not l_30_1.lang then
    local lang = i18n.getLanguageShortName()
  end
  if lbl.getMixFontType(lang) == "ttf" then
    return l_30_0:createLabelTTFElement(l_30_1)
  else
    return l_30_0:createLabelBMFElement(l_30_1)
  end
end

RichText.createImageElement = function(l_31_0, l_31_1)
  l_31_1.type = RichText.ELEMENT_TYPE.IMAGE
  l_31_1.scale = l_31_1.scale or 1
  return l_31_1
end

RichText.createImagePlistElement = function(l_32_0, l_32_1)
  l_32_1.type = RichText.ELEMENT_TYPE.IMAGEPLIST
  l_32_1.scale = l_32_1.scale or 1
  if not CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(l_32_1.name) and l_32_1.filePath and l_32_1.filePath ~= "" then
    img.load(l_32_1.filePath)
  end
  return l_32_1
end

RichText.createNewLineElement = function(l_33_0)
  return {type = RichText.ELEMENT_TYPE.NEWLINE}
end

RichText.pushBackElement = function(l_34_0, l_34_1)
  table.insert(l_34_0.richElements, l_34_1)
  l_34_0.formatTextDirty = true
end

RichText.insertElement = function(l_35_0, l_35_1, l_35_2)
  table.insert(l_35_0.richElements, l_35_2, l_35_1)
  l_35_0.formatTextDirty = true
end

RichText.removeElement = function(l_36_0, l_36_1)
  table.remove(l_36_0.richElements, l_36_1)
end

RichText.removeAllElement = function(l_37_0)
  l_37_0.richElements = {}
end

RichText.removeAllChildren = function(l_38_0)
  l_38_0.renderNode:removeAllChildren()
end

RichText.addNewLine = function(l_39_0)
  l_39_0.leftSpaceWidth = l_39_0.customSize.width
  table.insert(l_39_0.elementRenders, {})
  table.insert(l_39_0.lineHeights, 0)
end

RichText.formatText = function(l_40_0)
  if l_40_0.formatTextDirty then
    l_40_0:removeAllChildren()
    l_40_0.elementRenders = {}
    l_40_0.lineHeights = {}
    l_40_0:addNewLine()
    for i = 1,  l_40_0.richElements do
      local element = l_40_0.richElements[i]
      if element.type == RichText.ELEMENT_TYPE.LABELTTF then
        l_40_0:handleTextRenderer(element)
      else
        if element.type == RichText.ELEMENT_TYPE.LABELBMF then
          l_40_0:handleTextRenderer(element)
        else
          if element.type == RichText.ELEMENT_TYPE.IMAGE then
            local imageRenderer = CCSprite:create(element.filePath)
            imageRenderer:setScale(element.scale)
            l_40_0:handleImageRenderer(element, imageRenderer)
          else
            if element.type == RichText.ELEMENT_TYPE.IMAGEPLIST then
              local imageRenderer = CCSprite:createWithSpriteFrameName(element.name)
              imageRenderer:setScale(element.scale)
              l_40_0:handleImageRenderer(element, imageRenderer)
            else
              if element.type == RichText.ELEMENT_TYPE.NEWLINE then
                l_40_0:addNewLine()
              end
            end
          end
        end
      end
    end
    l_40_0:formatRenderers()
    l_40_0.formatTextDirty = false
  end
end

RichText.pushToContainer = function(l_41_0, l_41_1)
  if  l_41_0.elementRenders <= 0 then
    return 
  end
  table.insert(l_41_0.elementRenders[ l_41_0.elementRenders], l_41_1)
end

RichText.formatRenderers = function(l_42_0)
  local verticalSpace = l_42_0.verticalSpace
  local fontSize = l_42_0.fontSize
  local newContentSizeHeight = 0
  local maxHeights = {}
  for i = 1,  l_42_0.elementRenders do
    local row = l_42_0.elementRenders[i]
    local maxHeight = 0
    for j = 1,  row do
      if maxHeight < row[j]:getContentSize().height * row[j]:getScale() then
        maxHeight = row[j]:getContentSize().height * row[j]:getScale()
      end
    end
    maxHeight =  row > 0 or (l_42_0.lineHeights[i] ~= 0 and l_42_0.lineHeights[i]) or fontSize
    maxHeights[i] = maxHeight
    newContentSizeHeight = newContentSizeHeight + (i > 1 and (maxHeight) + verticalSpace or maxHeight)
  end
  l_42_0.customSize.height = newContentSizeHeight
  local nextPosY = l_42_0.customSize.height
  for i = 1,  l_42_0.elementRenders do
    local row = l_42_0.elementRenders[i]
    local nextPosX = 0
    if i <= 1 or not maxHeights[i] + verticalSpace then
      nextPosY = nextPosY - maxHeights[i]
    end
    for j = 1,  row do
      row[j]:setAnchorPoint(CCPoint(0, 0))
      row[j]:setPosition(nextPosX, nextPosY)
      l_42_0.renderNode:addChild(row[j])
      nextPosX = nextPosX + row[j]:getContentSize().width * row[j]:getScale()
    end
    l_42_0:doHorizontalAlignment(row, nextPosX)
  end
  l_42_0.elementRenders = {}
  l_42_0.lineHeights = {}
  l_42_0:setContentSize(l_42_0.customSize)
end

RichText.stripTrailingWhitespace = function(l_43_0, l_43_1)
  if  l_43_1 > 0 then
    local node = l_43_1[ l_43_1]
    local nodeType = tolua.type(node)
    if nodeType == "CCLabelTTF" or nodeType == "CCLabelBMFont" then
      local scale = node:getScale()
      local width = node:getContentSize().width * scale
      local text = node:getString()
      local trimmedString = string.rtrim(text)
      if text ~= trimmedString then
        node:setString(trimmedString)
        return node:getContentSize().width * scale - width
      end
    end
  end
  return 0
end

RichText.getPaddingAmount = function(l_44_0, l_44_1, l_44_2)
  if l_44_1 == RichText.HORIZONTAL_ALIGNMENT.CENTER then
    return l_44_2 / 2
  else
    if l_44_1 == RichText.HORIZONTAL_ALIGNMENT.RIGHT then
      return l_44_2
    else
      return 0
    end
  end
end

RichText.setHorizontalAlignment = function(l_45_0, l_45_1)
  l_45_0.alignment = l_45_1
end

RichText.getHorizontalAlignment = function(l_46_0)
  return l_46_0.alignment
end

RichText.doHorizontalAlignment = function(l_47_0, l_47_1, l_47_2)
  if l_47_0.alignment ~= RichText.HORIZONTAL_ALIGNMENT.LEFT then
    local diff = l_47_0:stripTrailingWhitespace(l_47_1)
    local leftOver = l_47_0.customSize.width - (l_47_2 + diff)
    local leftPadding = l_47_0:getPaddingAmount(l_47_0.alignment, leftOver)
    for i = 1,  l_47_1 do
      l_47_1[i]:setPositionX(l_47_1[i]:getPositionX() + leftPadding)
    end
  end
end

RichText.handleTextRenderer = function(l_48_0, l_48_1)
  local realLines = 0
  local currentText = nil
  local startIndex = 1
  local findNewLine = true
  repeat
    repeat
      repeat
        if findNewLine then
          local newLineIndex = string.find(l_48_1.text, "\n", startIndex)
          if newLineIndex then
            currentText = string.sub(l_48_1.text, startIndex, newLineIndex - 1)
            startIndex = newLineIndex + 1
          elseif startIndex <= 1 then
            currentText = l_48_1.text
          else
            currentText = string.sub(l_48_1.text, startIndex)
          end
          findNewLine = false
          if realLines > 0 then
            l_48_0:addNewLine()
            l_48_0.lineHeights[ l_48_0.lineHeights] = l_48_1.size
          end
          realLines = realLines + 1
          local splitParts = 0
          local utf8 = require("common.utf8")
          if not utf8.chars(currentText) then
            local utf8Text = {}
          end
          repeat
          until currentText ~= ""
          if splitParts > 0 then
            l_48_0:addNewLine()
            l_48_0.lineHeights[ l_48_0.lineHeights] = l_48_1.size
          end
          splitParts = splitParts + 1
          local textRenderer = nil
          if l_48_1.type == RichText.ELEMENT_TYPE.LABELBMF then
            textRenderer = CCLabelBMFont:create(currentText, l_48_1.fontName)
          else
            textRenderer = CCLabelTTF:create(currentText, l_48_1.fontName, l_48_1.size)
          end
          textRenderer:setColor(l_48_1.color)
          textRenderer:setOpacity(l_48_1.opacity)
          textRenderer:setScale(l_48_1.scale)
          local textRendererWidth = textRenderer:getContentSize().width * l_48_1.scale
          if textRendererWidth > 0 and textRendererWidth <= l_48_0.leftSpaceWidth then
            l_48_0.leftSpaceWidth = l_48_0.leftSpaceWidth - textRendererWidth
            l_48_0:pushToContainer(textRenderer)
          else
            local estimatedIdx = 0
            if textRendererWidth > 0 then
              estimatedIdx = math.floor(l_48_0.leftSpaceWidth / textRendererWidth *  utf8Text)
            else
              estimatedIdx = math.floor(l_48_0.leftSpaceWidth / l_48_1.size)
            end
            local leftLength = 0
            if l_48_0.wrapMode == RichText.WRAP_MODE.WRAP_PER_WORD then
              leftLength = findSplitPositionForWord(textRenderer, utf8Text, estimatedIdx, l_48_0.leftSpaceWidth, l_48_0.customSize.width)
            else
              leftLength = findSplitPositionForChar(textRenderer, utf8Text, estimatedIdx, l_48_0.leftSpaceWidth, l_48_0.customSize.width)
            end
            if leftLength > 0 then
              textRenderer:setString(table.concat(utf8Text, "", 1, leftLength))
              l_48_0:pushToContainer(textRenderer)
            end
            do
              local newText = {}
              if leftLength <  utf8Text then
                for i = leftLength + 1,  utf8Text do
                  table.insert(newText, utf8Text[i])
                end
              end
              utf8Text = newText
              currentText = table.concat(utf8Text, "")
            end
            do return end
          else
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

RichText.handleImageRenderer = function(l_49_0, l_49_1, l_49_2)
  if l_49_2 then
    if l_49_1.width or l_49_1.height then
      local size = l_49_2:getContentSize()
      local width = l_49_1.width or 0
      local height = l_49_1.height or 0
      l_49_2:setContentSize(CCSize(size.width + width, size.height + height))
    end
    l_49_0:handleCustomRenderer(l_49_2)
  end
end

RichText.handleCustomRenderer = function(l_50_0, l_50_1)
  local size = l_50_1:getContentSize()
  local scale = l_50_1:getScale()
  l_50_0.leftSpaceWidth = l_50_0.leftSpaceWidth - size.width * scale
  if l_50_0.leftSpaceWidth < 0 then
    l_50_0:addNewLine()
    l_50_0:pushToContainer(l_50_1)
    l_50_0.leftSpaceWidth = l_50_0.leftSpaceWidth - size.width * scale
  else
    l_50_0:pushToContainer(l_50_1)
  end
end

RichText.parseHTMLText = function(l_51_0, l_51_1)
  local startIndex = 0
  local length =  l_51_1
  repeat
    repeat
      repeat
        repeat
          if startIndex < length then
            startIndex = string.find(l_51_1, "<", startIndex + 1)
            if startIndex == nil then
              print("parse text error:can not find \"<\"")
            else
              if string.sub(l_51_1, startIndex + 1, startIndex + 4) == "font" then
                local paramEndIndex = string.find(l_51_1, ">", startIndex + 4)
                if paramEndIndex == nil then
                  print("parse font error:can not find \">\"")
                else
                  local fontEndIndex = string.find(l_51_1, "</font>", paramEndIndex + 1)
                  if fontEndIndex == nil then
                    print("parse font error:can not find \"</font>\"")
                  else
                    local content = string.sub(l_51_1, paramEndIndex + 1, fontEndIndex - 1)
                    local fontParamStr = string.sub(l_51_1, startIndex + 5, paramEndIndex - 1)
                    startIndex = fontEndIndex + 6
                    local fontColor = getAttribute(fontParamStr, "color")
                    local r, g, b, a = colorCodeToRGBA(fontColor)
                    local fontName = getAttribute(fontParamStr, "name") or ""
                    local fontIndex = getAttribute(fontParamStr, "index")
                    local fontSize = getAttribute(fontParamStr, "size")
                    if fontSize then
                      fontSize = tonumber(fontSize)
                    else
                      fontSize = DEFAULT_FONT_SIZE
                    end
                    local labelType = getAttribute(fontParamStr, "type")
                    local scale = getAttribute(fontParamStr, "scale")
                    local labelObj = {size = fontSize, text = content, fontName = fontName, color = ccc3(r, g, b), opacity = a}
                    if fontIndex then
                      labelObj.fontIndex = tonumber(fontIndex)
                    end
                    if scale then
                      labelObj.scale = tonumber(scale)
                    end
                    local element = nil
                    if labelType then
                      if tonumber(labelType) == LABEL_TYPE_MIX then
                        if not getAttribute(fontParamStr, "lang") then
                          local lang = i18n.getLanguageShortName()
                        end
                        labelObj.lang = lang
                        element = l_51_0:createLabelMixElement(labelObj)
                      else
                        if tonumber(labelType) == LABEL_TYPE_BMF then
                          element = l_51_0:createLabelBMFElement(labelObj)
                        else
                          element = l_51_0:createLabelTTFElement(labelObj)
                        end
                      else
                        element = l_51_0:createLabelTTFElement(labelObj)
                      end
                    end
                    l_51_0:pushBackElement(element)
                  else
                    if string.sub(l_51_1, startIndex + 1, startIndex + 3) == "img" then
                      local paramEndIndex = string.find(l_51_1, "/>", startIndex + 3)
                      if paramEndIndex == nil then
                        print("parse img error:can not find \"/>\"")
                      else
                        local imgParamStr = string.sub(l_51_1, startIndex + 4, paramEndIndex - 1)
                        startIndex = paramEndIndex + 1
                        local imageType = getAttribute(imgParamStr, "type")
                        if imageType then
                          imageType = tonumber(imageType)
                        else
                          imageType = 1
                        end
                        local filePath = getAttribute(imgParamStr, "src") or ""
                        local name = getAttribute(imgParamStr, "name") or ""
                        local imageObj = {filePath = filePath}
                        if name ~= "" then
                          imageObj.name = name
                        end
                        local scale = getAttribute(imgParamStr, "scale")
                        if scale then
                          imageObj.scale = tonumber(scale)
                        end
                        local element = nil
                        if imageType == IMAGE_TYPE_PLIST then
                          element = l_51_0:createImagePlistElement(imageObj)
                        elseif imageType == IMAGE_TYPE_LOCAL then
                          element = l_51_0:createImageElement(imageObj)
                        else
                          element = l_51_0:createImageElement(imageObj)
                        end
                        l_51_0:pushBackElement(element)
                      else
                        if string.sub(l_51_1, startIndex + 1, startIndex + 2) == "br" then
                          local paramEndIndex = string.find(l_51_1, ">", startIndex + 2)
                          if paramEndIndex == nil then
                            print("parse br error:can not find \">\"")
                          else
                            startIndex = paramEndIndex
                            local element = l_51_0:createNewLineElement()
                            l_51_0:pushBackElement(element)
                          end
                        else
                          local paramEndIndex = string.find(l_51_1, ">", startIndex + 1)
                          if paramEndIndex == nil then
                            print("parse other error:can not find \">\"")
                          else
                            startIndex = paramEndIndex
                          end
                      end
                    end
                  end
                end
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

return RichText

