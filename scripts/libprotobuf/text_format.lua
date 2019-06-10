-- Command line was: E:\github\dhgametool\scripts\libprotobuf\text_format.lua 

local string = string
local math = math
local print = print
local getmetatable = getmetatable
local table = table
local ipairs = ipairs
local tostring = tostring
local descriptor = require("descriptor")
module("text_format")
format = function(l_1_0)
  local len = string.len(l_1_0)
  for i = 1, len, 16 do
    local text = ""
    for j = i, math.min(i + 16 - 1, len) do
      text = string.format("%s  %02x", text, string.byte(l_1_0, j))
    end
    print(text)
  end
end

local FieldDescriptor = descriptor.FieldDescriptor
msg_format_indent = function(l_2_0, l_2_1, l_2_2)
  for field,value in l_2_1:ListFields() do
    do
      local print_field = function(l_1_0)
        local name = field.name
        write(string.rep(" ", indent))
        if field.type == FieldDescriptor.TYPE_MESSAGE then
          local extensions = getmetatable(msg)._extensions_by_name
          if extensions[field.full_name] then
            write("[" .. name .. "] {\n")
          else
            write(name .. " {\n")
          end
          msg_format_indent(write, l_1_0, indent + 4)
          write(string.rep(" ", indent))
          write("}\n")
        else
          write(string.format("%s: %s\n", name, tostring(l_1_0)))
        end
         end
      if field.label == FieldDescriptor.LABEL_REPEATED then
        for _,k in ipairs(value) do
          print_field(k)
        end
      else
        print_field(value)
      end
    end
  end
end

msg_format = function(l_3_0)
  local out = {}
  local write = function(l_1_0)
    out[#out + 1] = l_1_0
   end
  msg_format_indent(write, l_3_0, 0)
  return table.concat(out)
end


