-- Command line was: E:\github\dhgametool\scripts\data\appsflyer.lua 

local m = {}
m.eventName = {10_4_star = "10_4_star", 20_4_star = "20_4_star", s1lv3_map = "s1lv3_map", s1lv4_map = "s1lv4_map", 10_hs = "10_hs", lv5_to = "lv5_to", lv10_to = "lv10_to", lv15_to = "lv15_to", lv5_bt = "lv5_bt", lv10_bt = "lv10_bt", 2_5_star = "2_5_star", 10_altar = "10_altar", 20_altar = "20_altar", 5_lv31 = "5_lv31", 10_cc = "10_cc", 10_bs = "10_bs", 1200p_ccl = "1200p_ccl", 10_ccl = "10_ccl", 20_Green_equip = "20_Green_equip", 10_4_star_Tavern = "10_4_star_Tavern", 5_Marauders = "5_Marauders", 5_star_cc = "5_star_cc"}
local achieveMap = {101 = m.eventName["10_4_star"], 102 = m.eventName["20_4_star"], 403 = m.eventName.s1lv3_map, 404 = m.eventName.s1lv4_map}
m.report = function(l_1_0)
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  if not l_1_0 or l_1_0 == "" then
    return 
  end
  HHUtils:trackDHAppsFlyer(l_1_0, "1", "1")
end

m.addAchieve = function(l_2_0, l_2_1)
  local achieveData = require("data.achieve")
  local count = 0
  if achieveData.achieveInfos[l_2_0] and achieveData.achieveInfos[l_2_0].num then
    count = achieveData.achieveInfos[l_2_0].num
  end
  local pre_num = count - l_2_1
  local ename = ""
  if l_2_0 == ACHIEVE_TYPE_GET_HERO_STAR4 then
    if pre_num < 10 and count >= 10 then
      ename = m.eventName["10_4_star"]
    elseif pre_num < 20 and count >= 20 then
      ename = m.eventName["20_4_star"]
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif l_2_0 == ACHIEVE_TYPE_GET_HERO_STAR5 and pre_num < 2 and count >= 2 then
      ename = m.eventName["2_5_star"]
      do return end
      if l_2_0 == ACHIEVE_TYPE_DECOMPOSE_HERO then
        if pre_num < 10 and count >= 10 then
          ename = m.eventName["10_altar"]
        elseif pre_num < 20 and count >= 20 then
          ename = m.eventName["20_altar"]
         -- DECOMPILER ERROR: unhandled construct in 'if'

        elseif l_2_0 == ACHIEVE_TYPE_ARENA_ATTACK and pre_num < 10 and count >= 10 then
          ename = m.eventName["10_ccl"]
          do return end
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if l_2_0 == ACHIEVE_TYPE_GET_EQUIP_GREEN and pre_num < 20 and count >= 20 then
            ename = m.eventName["20_Green_equip"]
            do return end
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if l_2_0 == ACHIEVE_TYPE_COMPLETE_HEROTASK4 and pre_num < 10 and count >= 10 then
              ename = m.eventName["10_4_star_Tavern"]
              do return end
               -- DECOMPILER ERROR: unhandled construct in 'if'

              if l_2_0 == ACHIEVE_TYPE_CASINO and pre_num < 1 and count >= 1 then
                ename = m.eventName["5_star_cc"]
                do return end
                if l_2_0 == ACHIEVE_TYPE_BRAVE then
                  if pre_num < 5 and count >= 5 then
                    ename = m.eventName.lv5_bt
                  elseif pre_num < 10 and count >= 10 then
                    ename = m.eventName.lv10_bt
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if ename and ename ~= "" then
    m.report(ename)
  end
end

m.setAchieve = function(l_3_0, l_3_1)
  local ename = ""
  if l_3_0 == ACHIEVE_TYPE_PASS_FORT then
    if l_3_1 == 3 then
      ename = m.eventName.s1lv3_map
    elseif l_3_1 == 4 then
      ename = m.eventName.s1lv4_map
    elseif l_3_0 == 6001 then
      if l_3_1 == 5 then
        ename = m.eventName.lv5_to
      elseif l_3_1 == 10 then
        ename = m.eventName.lv10_to
      elseif l_3_1 == 15 then
        ename = m.eventName.lv15_to
      end
    end
  end
  if ename and ename ~= "" then
    m.report(ename)
  end
end

return m

