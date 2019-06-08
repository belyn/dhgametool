-- Command line was: E:\github\dhgametool\scripts\net\protoGenerator.lua 

local generator = {}
require("protocol.dr2_comm_pb")
require("protocol.dr2_login_pb")
require("protocol.dr2_logic_pb")
local _base_module_name = "dr2_comm_pb"
local modules = {}
modules[_base_module_name] = dr2_comm_pb
modules.dr2_login_pb = dr2_login_pb
modules.dr2_logic_pb = dr2_logic_pb
generator.genEchoData = function(l_1_0)
  local _obj = dr2_login_pb.pbreq_echo()
  _obj.echo = l_1_0.echo
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

generator.genRegData = function(l_2_0)
  local _obj = dr2_login_pb.pbreq_reg()
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

generator.genSaltData = function(l_3_0)
  local _obj = dr2_login_pb.pbreq_salt()
  _obj.account = l_3_0.account
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

generator.genLoginData = function(l_4_0)
  local _obj = dr2_login_pb.pbreq_login()
  _obj.checksum = l_4_0.checksum
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

generator.genAuthData = function(l_5_0)
  l_5_0.module_name = "dr2_logic_pb"
  l_5_0.class_name = "pbreq_auth"
  return generator.genProtoData(l_5_0)
end

generator.genSyncData = function(l_6_0)
  local _obj = dr2_logic_pb.pbreq_sync()
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

generator.genGachaData = function(l_7_0)
  l_7_0.module_name = "dr2_logic_pb"
  l_7_0.class_name = "pbreq_gacha"
  return generator.genProtoData(l_7_0)
end

generator.genOpMailData = function(l_8_0)
  local _obj = dr2_logic_pb.pbreq_op_mail()
  if l_8_0.reads then
    for ii = 1,  l_8_0.reads do
      _obj.reads:append(l_8_0.reads[ii])
    end
  end
  if l_8_0.deletes then
    for ii = 1,  l_8_0.deletes do
      _obj.deletes:append(l_8_0.deletes[ii])
    end
  end
  if l_8_0.affix then
    _obj.affix = l_8_0.affix
  end
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

local objAssign = function(l_9_0, l_9_1, l_9_2, l_9_3)
  local fields = modules[l_9_0][string.upper(l_9_1)].fields
  for ii = 1,  fields do
    if type(fields[ii].default_value) == "table" and fields[ii].message_type and l_9_3[fields[ii].name] then
      local _module_name = _base_module_name
      do
        local _class_name = fields[ii].message_type.name
        for jj = 1,  l_9_3[fields[ii].name] do
          local tmp_obj = l_9_2[fields[ii].name]:add(modules[_module_name][_class_name]())
          objAssign(_module_name, _class_name, tmp_obj, l_9_3[fields[ii].name][jj])
        end
      end
      do return end
      do
        if type(fields[ii].default_value) == "table" and l_9_3[fields[ii].name] then
          local _module_name = _base_module_name
          for jj = 1,  l_9_3[fields[ii].name] do
            l_9_2[fields[ii].name]:append(l_9_3[fields[ii].name][jj])
          end
        end
        do return end
        if fields[ii].message_type and l_9_3[fields[ii].name] then
          local _module_name = _base_module_name
          do
            local _class_name = fields[ii].message_type.name
            objAssign(_module_name, _class_name, l_9_2[fields[ii].name], l_9_3[fields[ii].name])
          end
          do return end
          if l_9_3[fields[ii].name] then
            l_9_2[fields[ii].name] = l_9_3[fields[ii].name]
          end
        end
      end
    end
  end
end

generator.genProtoData = function(l_10_0)
  local module_name = l_10_0.module_name
  local class_name = l_10_0.class_name
  local _obj = modules[module_name][class_name]()
  objAssign(module_name, class_name, _obj, l_10_0)
  local _proto_data = _obj:SerializeToString()
  return _proto_data
end

return generator

