-- Command line was: E:\github\dhgametool\scripts\libprotobuf\proto_func.lua 

pb = require("pb")
varint_encoder = function(l_1_0)
  local status, result = pcall(pb.varint_encoder, l_1_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

signed_varint_encoder = function(l_2_0)
  local status, result = pcall(pb.signed_varint_encoder, l_2_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

read_tag = function(l_3_0)
  local status, result = pcall(pb.read_tag, l_3_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

struct_pack = function(l_4_0)
  local status, result = pcall(pb.struct_pack, l_4_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

struct_unpack = function(l_5_0)
  local status, result = pcall(pb.struct_unpack, l_5_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

varint_decoder = function(l_6_0)
  local status, result = pcall(pb.varint_decoder, l_6_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

signed_varint_decoder = function(l_7_0)
  local status, result = pcall(pb.signed_varint_decoder, l_7_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

zig_zag_decode32 = function(l_8_0)
  local status, result = pcall(pb.zig_zag_decode32, l_8_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

zig_zag_encode32 = function(l_9_0)
  local status, result = pcall(pb.zig_zag_encode32, l_9_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

zig_zag_decode64 = function(l_10_0)
  local status, result = pcall(pb.zig_zag_decode64, l_10_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

zig_zag_encode64 = function(l_11_0)
  local status, result = pcall(pb.zig_zag_encode64, l_11_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end

new_iostring = function(l_12_0)
  local status, result = pcall(pb.new_iostring, l_12_0)
  if status then
    return result
  end
  if DEBUG > 1 then
    echoError("error:------can't decode")
  end
end


