-- Command line was: E:\github\dhgametool\scripts\dhcomponents\tools\UIHelper.lua 

local UIHelper = {}
UIHelper.hasVisibleParents = function(l_1_0)
  repeat
    if l_1_0 then
      if not l_1_0:isVisible() then
        return false
      end
      l_1_0 = l_1_0:getParent()
    else
      return true
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return UIHelper

