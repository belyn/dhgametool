-- Command line was: E:\github\dhgametool\scripts\res\lbl.lua 

local lbl = {}
require("common.const")
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local fontDir = "fonts/"
local fontFileConfig = {1 = {size = 28, name = "font_1.fnt"}, 2 = {size = 28, name = "font_2.fnt"}, 3 = {size = 32, name = "font_3.fnt"}}
local fontLanguageConfig = {us = {prefix = "us", fonts = {1, 2, 3}}, es = {prefix = "us", fonts = {1, 2, 3}}, pt = {prefix = "us", fonts = {1, 2, 3}}, fr = {prefix = "us", fonts = {1, 2, 3}}, tr = {prefix = "us", fonts = {1, 2, 3}}, de = {prefix = "us", fonts = {1, 2, 3}}, it = {prefix = "us", fonts = {1, 2, 3}}, ru = {prefix = "ru", fonts = {1, 2, 3}}, ms = {prefix = "us", fonts = {1, 2, 3}}, cn = {prefix = "cn", fonts = {1, 2, 3}}, tw = {prefix = "tw", fonts = {1, 2, 3}}, jp = {prefix = "jp", fonts = {1, 2, 3}}, kr = {prefix = "kr", fonts = {1, 2, 3}}, th = {prefix = "th", fonts = {2}}, vi = {prefix = "vi", fonts = {1, 2, 3}}, ar = {prefix = "ar", fonts = {1, 2, 3}}}
local USE_TTF_LANGUAGES = {"cn", "tw", "jp", "kr"}
local fontNames = {}
local initFontNames = function()
  for lang,langConfig in pairs(fontLanguageConfig) do
    fontNames[lang] = {}
    for _,font in ipairs(fontLanguageConfig[lang].fonts) do
      fontNames[lang][font] = string.format("%s%s_%s", fontDir, fontLanguageConfig[lang].prefix, fontFileConfig[font].name)
    end
  end
end

initFontNames()
lbl.create = function(l_2_0)
  if not l_2_0.lang then
    local lang = i18n.getLanguageShortName()
  end
  local font = l_2_0.font or 1
  local size = l_2_0.size or 20
  local kind = l_2_0.kind or "bmf"
  local minScale = l_2_0.minScale
  local text = l_2_0.text or ""
  local color = l_2_0.color
  local bmfColor = l_2_0.bmfColor
  local ttfColor = l_2_0.ttfColor
  local gray = l_2_0.gray
  local opacity = l_2_0.opacity
  local width = l_2_0.width
  local align = l_2_0.align
  if l_2_0[lang] then
    if l_2_0[lang].font ~= nil then
      font = l_2_0[lang].font
    end
    if l_2_0[lang].size ~= nil then
      size = l_2_0[lang].size
    end
    if l_2_0[lang].kind ~= nil then
      kind = l_2_0[lang].kind
    end
    if l_2_0[lang].minScale ~= nil then
      minScale = l_2_0[lang].minScale
    end
    if l_2_0[lang].text ~= nil then
      text = l_2_0[lang].text
    end
    if l_2_0[lang].color ~= nil then
      color = l_2_0[lang].color
    end
    if l_2_0[lang].bmfColor ~= nil then
      bmfColor = l_2_0[lang].bmfColor
    end
    if l_2_0[lang].ttfColor ~= nil then
      ttfColor = l_2_0[lang].ttfColor
    end
    if l_2_0[lang].gray ~= nil then
      gray = l_2_0[lang].gray
    end
    if l_2_0[lang].opacity ~= nil then
      opacity = l_2_0[lang].opacity
    end
    if l_2_0[lang].width ~= nil then
      width = l_2_0[lang].width
    end
    if l_2_0[lang].align ~= nil then
      align = l_2_0[lang].align
    end
  end
  if kind == "bmf" and not arraycontains(fontLanguageConfig[lang].fonts, font) then
    kind = "ttf"
  end
  local label = nil
  if kind == "bmf" then
    label = CCLabelBMFont:create(text, fontNames[lang][font])
    label:setScale(size / fontFileConfig[font].size)
    if not bmfColor then
      label:setColor(not bmfColor and not color or color)
  else
    end
    label = CCLabelTTF:create(text, "", size)
    label:setColor((not ttfColor and not color) or ttfColor or color)
  end
  if minScale then
    label:setScale(label:getScale() * view.minScale)
  end
  if gray then
    setShader(label, SHADER_GRAY, true)
  end
  if opacity then
    label:setCascadeOpacityEnabled(true)
    label:setOpacity(opacity)
  end
  if width then
    if kind == "bmf" then
      if minScale then
        label:setWidth(width * view.minScale)
      else
        label:setWidth(width)
      end
    else
      label:setDimensions(CCSize(width, 0))
    end
  end
  if align then
    if kind == "bmf" then
      label:setAlignment(align)
    else
      label:setHorizontalAlignment(align)
    end
  end
  return label
end

lbl.createFont1 = function(l_3_0, l_3_1, l_3_2, l_3_3)
  return lbl.create({font = 1, size = l_3_0, text = l_3_1, color = l_3_2, minScale = l_3_3})
end

lbl.createFont2 = function(l_4_0, l_4_1, l_4_2, l_4_3)
  return lbl.create({font = 2, size = l_4_0, text = l_4_1, color = l_4_2, minScale = l_4_3})
end

lbl.createFont3 = function(l_5_0, l_5_1, l_5_2, l_5_3)
  return lbl.create({font = 3, size = l_5_0, text = l_5_1, color = l_5_2, minScale = l_5_3})
end

lbl.createMix = function(l_6_0)
  for _,lang in ipairs(USE_TTF_LANGUAGES) do
    if not l_6_0[lang] then
      l_6_0[lang] = {}
    end
    if not l_6_0[lang].kind then
      l_6_0[lang].kind = "ttf"
    end
  end
  return lbl.create(l_6_0)
end

lbl.createMixFont1 = function(l_7_0, l_7_1, l_7_2, l_7_3)
  return lbl.createMix({font = 1, size = l_7_0, text = l_7_1, color = l_7_2, minScale = l_7_3})
end

lbl.createMixFont2 = function(l_8_0, l_8_1, l_8_2, l_8_3)
  return lbl.createMix({font = 2, size = l_8_0, text = l_8_1, color = l_8_2, minScale = l_8_3})
end

lbl.createMixFont3 = function(l_9_0, l_9_1, l_9_2, l_9_3)
  return lbl.createMix({font = 3, size = l_9_0, text = l_9_1, color = l_9_2, minScale = l_9_3})
end

lbl.createFontTTF = function(l_10_0, l_10_1, l_10_2, l_10_3)
  return lbl.create({kind = "ttf", size = l_10_0, text = l_10_1, color = l_10_2, minScale = l_10_3})
end

lbl.qualityColors = {QUALITY_1 = ccc3(26, 145, 255), QUALITY_2 = ccc3(220, 194, 19), QUALITY_3 = ccc3(219, 63, 255), QUALITY_4 = ccc3(57, 230, 58), QUALITY_5 = ccc3(255, 64, 64), QUALITY_6 = ccc3(250, 142, 26)}
lbl.buttonColor = ccc3(115, 59, 5)
lbl.whiteColor = ccc3(255, 246, 223)
lbl.isHaveBMFontRes = function(l_11_0, l_11_1)
  return arraycontains(fontLanguageConfig[l_11_0].fonts, l_11_1)
end

lbl.getMixFontType = function(l_12_0)
  for k,v in ipairs(USE_TTF_LANGUAGES) do
    if v == l_12_0 then
      return "ttf"
    end
  end
  return "bmf"
end

lbl.getFontSize = function(l_13_0)
  if fontFileConfig[l_13_0] then
    return fontFileConfig[l_13_0].size
  else
    return 0
  end
end

lbl.getFontName = function(l_14_0, l_14_1)
  if fontNames[l_14_0] and fontNames[l_14_0][l_14_1] then
    return fontNames[l_14_0][l_14_1]
  else
    return ""
  end
end

lbl.getFontIndex = function(l_15_0)
  for k,v in ipairs(fontFileConfig) do
    if v == l_15_0 then
      return k
    end
  end
  return 0
end

return lbl

