-- Command line was: E:\github\dhgametool\scripts\ui\progressbar.lua 

local bar = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
bar.create = function(l_1_0)
  local progress = (createProgressBar(l_1_0))
  local curLv, curPct, aimLv, aimPct = nil, nil, nil, nil
  progress.setLvAndPercentage = function(l_1_0, l_1_1)
    curLv = l_1_0
    upvalue_512 = l_1_1
    upvalue_1024 = l_1_0
    upvalue_1536 = l_1_1
    progress:setPercentage(l_1_1)
   end
  progress.scaleLvAndPercentage = function(l_2_0, l_2_1)
    aimLv = l_2_0
    upvalue_512 = l_2_1
   end
  progress.setPercentageOnly = function(l_3_0)
    progress.setLvAndPercentage(0, l_3_0)
   end
  progress.scalePercentageOnly = function(l_4_0)
    progress.scaleLvAndPercentage(0, l_4_0)
   end
  local lvHander = nil
  progress.setLvHandler = function(l_5_0)
    lvHander = l_5_0
   end
  local pctHander = nil
  progress.setPercentageHandler = function(l_6_0)
    pctHander = l_6_0
   end
  local onUpdate = function(l_7_0)
    local step = l_7_0 * 60
    if curLv and curPct and (not floateq(curLv, aimLv) or not floateq(curPct, aimPct)) then
      local lvChange = nil
      if aimLv < curLv then
        upvalue_512 = curPct - 5 * step
        if curPct < 0 then
          curLv = curLv - 1
          upvalue_512 = 100 + curPct
          lvChange = true
        else
          if curLv < aimLv then
            upvalue_512 = curPct + 5 * step
            if curPct >= 100 then
              curLv = curLv + 1
              upvalue_512 = curPct - 100
              lvChange = true
            else
              if math.abs(curPct - aimPct) > 50 then
                step = step * 5
              else
                if math.abs(curPct - aimPct) > 20 then
                  step = step * 2
              end
              if aimPct < curPct then
                upvalue_512 = curPct - step
                if curPct < aimPct then
                  upvalue_512 = aimPct
                else
                  if curPct < aimPct then
                    upvalue_512 = curPct + step
                    if aimPct < curPct then
                      upvalue_512 = aimPct
                    end
                  end
                end
              end
            end
          end
        end
      end
      if lvChange and lvHander then
        lvHander(curLv)
      end
      if progress:getPercentage() ~= curPct then
        progress:setPercentage(curPct)
        if pctHander then
          pctHander(curPct)
        end
      end
    end
   end
  progress:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return progress
end

return bar

