-- Command line was: E:\github\dhgametool\scripts\common\fileOpt.lua 

local fileOpt = {}
local lfs = require("lfs")
fileOpt.mkdir = function(l_1_0)
  local wpath = CCFileUtils:sharedFileUtils():getWritablePath()
  local relative_name = string.sub(l_1_0,  wpath + 1, -1)
  fileOpt.mkRelativeDir(relative_name)
  return 
  if not lfs.chdir(l_1_0) then
    lfs.mkdir(l_1_0)
  end
end

fileOpt.split = function(l_2_0, l_2_1)
  if l_2_1 == "" then
    return false
  end
  local pos, arr = 0, {}
  for st,sp in function()
    return string.find(str, delimiter, pos, true)
   end do
    table.insert(arr, string.sub(l_2_0, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(l_2_0, pos))
  return arr
end

fileOpt.mkRelativeDir = function(l_3_0)
  local wpath = CCFileUtils:sharedFileUtils():getWritablePath()
  local arr = fileOpt.split(l_3_0, "/")
  for ii = 1,  arr do
    wpath = wpath .. arr[ii] .. "/"
    if not lfs.chdir(wpath) then
      lfs.mkdir(wpath)
    end
  end
end

fileOpt.readFile = function(l_4_0)
  local rfile = io.open(l_4_0, "rb")
  if not rfile then
    print("open file failed:", l_4_0)
    return nil
  end
  local content = rfile:read("*all")
  io.close(rfile)
  return content
end

fileOpt.writeFile = function(l_5_0, l_5_1)
  local pos =  l_5_1
  repeat
    repeat
      if string.sub(l_5_1, pos, pos) ~= "/" then
        pos = pos - 1
      until pos <= 1
      print("path have no char / :", l_5_1)
      return false
    else
      local fpath = string.sub(l_5_1, 1, pos)
      fileOpt.mkdir(fpath)
      if not lfs.chdir(fpath) then
        print("path not existed, create dir:", fpath)
        if not lfs.mkdir(fpath) then
          print("create " .. fpath .. " failed!")
          return false
        end
      end
      do
        local wfile = io.open(l_5_1, "wb")
        if not wfile then
          print("create file failed:", l_5_1)
          return false
        end
        wfile:write(l_5_0)
        wfile:flush()
        io.close(wfile)
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

fileOpt.cpfile = function(l_6_0, l_6_1)
  local content = fileOpt.readFile(l_6_0)
  if content then
    local ret = fileOpt.writeFile(content, l_6_1)
    return ret
  end
  return false
end

fileOpt.rmfile = function(l_7_0)
  local attr = lfs.attributes(l_7_0)
  if attr == nil then
    return 
  end
  if attr.mode == "file" then
    os.remove(l_7_0)
    return true
  elseif attr.mode == "directory" then
    return fileOpt.rmdir(l_7_0)
  end
  return false
end

fileOpt.cpdir = function(l_8_0, l_8_1)
  if not lfs.chdir(l_8_0) then
    print("cp src_dir is not existed!")
    return 
  end
  if not lfs.chdir(l_8_1) then
    fileOpt.mkdir(l_8_1)
  end
  for file in lfs.dir(l_8_0) do
    if file ~= "." and file ~= ".." then
      local f = l_8_0 .. "/" .. file
      local attr = lfs.attributes(f)
      do
        if attr.mode == "directory" then
          local tmp_dst_dir = l_8_1 .. "/" .. file
          if not lfs.chdir(tmp_dst_dir) then
            lfs.mkdir(tmp_dst_dir)
          end
          fileOpt.cpdir(f, tmp_dst_dir)
        end
        for file in (for generator) do
        end
        local dst_file = l_8_1 .. "/" .. file
        if not fileOpt.cpfile(f, dst_file) then
          print("cp file failed:", f, dst_file)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

fileOpt.rmdir = function(l_9_0)
  if lfs.chdir(l_9_0) then
    local _rmdir = function(l_1_0)
    local iter, dir_obj = lfs.dir(l_1_0)
    repeat
      repeat
        repeat
          repeat
            repeat
              local dir = iter(dir_obj)
              if dir == nil then
                do return end
              end
            until dir ~= "."
          until dir ~= ".."
          local curDir = l_1_0 .. "/" .. dir
          do
            local attr = lfs.attributes(curDir)
            if attr.mode == "directory" then
              print("step into:", curDir)
              _rmdir(curDir)
          until attr.mode == "file"
          else
            print("os.remove:", curDir)
            os.remove(curDir)
          end
          do return end
          do
            local succ, des = os.remove(l_1_0)
            if des then
              print(des)
            end
            return succ
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
    do
      _rmdir(l_9_0)
    end
  end
  return true
end

fileOpt.exists = function(l_10_0)
  return lfs.attributes(l_10_0, "mode") ~= nil
end

fileOpt.isFile = function(l_11_0)
  return lfs.attributes(l_11_0, "mode") == "file"
end

fileOpt.isDir = function(l_12_0)
  return lfs.attributes(l_12_0, "mode") == "directory"
end

return fileOpt

