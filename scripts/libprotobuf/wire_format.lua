-- Command line was: E:\github\dhgametool\scripts\libprotobuf\wire_format.lua 

local zig_zag_encode32 = zig_zag_encode32
local zig_zag_decode32 = zig_zag_decode32
local zig_zag_encode64 = zig_zag_encode64
local zig_zag_decode64 = zig_zag_decode64
module("wire_format")
WIRETYPE_VARINT = 0
WIRETYPE_FIXED64 = 1
WIRETYPE_LENGTH_DELIMITED = 2
WIRETYPE_START_GROUP = 3
WIRETYPE_END_GROUP = 4
WIRETYPE_FIXED32 = 5
_WIRETYPE_MAX = 5
local _VarUInt64ByteSizeNoTag = function(l_1_0)
  if l_1_0 <= 127 then
    return 1
  end
  if l_1_0 <= 16383 then
    return 2
  end
  if l_1_0 <= 2097151 then
    return 3
  end
  if l_1_0 <= 268435455 then
    return 4
  end
  return 5
end

PackTag = function(l_2_0, l_2_1)
  return l_2_0 * 8 + l_2_1
end

UnpackTag = function(l_3_0)
  local wire_type = l_3_0 % 8
  return (l_3_0 - wire_type) / 8, wire_type
end

ZigZagEncode32 = zig_zag_encode32
ZigZagDecode32 = zig_zag_decode32
ZigZagEncode64 = zig_zag_encode64
ZigZagDecode64 = zig_zag_decode64
Int32ByteSize = function(l_4_0, l_4_1)
  return Int64ByteSize(l_4_0, l_4_1)
end

Int32ByteSizeNoTag = function(l_5_0)
  return _VarUInt64ByteSizeNoTag(l_5_0)
end

Int64ByteSize = function(l_6_0, l_6_1)
  return UInt64ByteSize(l_6_0, l_6_1)
end

UInt32ByteSize = function(l_7_0, l_7_1)
  return UInt64ByteSize(l_7_0, l_7_1)
end

UInt64ByteSize = function(l_8_0, l_8_1)
  return TagByteSize(l_8_0) + _VarUInt64ByteSizeNoTag(l_8_1)
end

SInt32ByteSize = function(l_9_0, l_9_1)
  return UInt32ByteSize(l_9_0, ZigZagEncode(l_9_1))
end

SInt64ByteSize = function(l_10_0, l_10_1)
  return UInt64ByteSize(l_10_0, ZigZagEncode(l_10_1))
end

Fixed32ByteSize = function(l_11_0, l_11_1)
  return TagByteSize(l_11_0) + 4
end

Fixed64ByteSize = function(l_12_0, l_12_1)
  return TagByteSize(l_12_0) + 8
end

SFixed32ByteSize = function(l_13_0, l_13_1)
  return TagByteSize(l_13_0) + 4
end

SFixed64ByteSize = function(l_14_0, l_14_1)
  return TagByteSize(l_14_0) + 8
end

FloatByteSize = function(l_15_0, l_15_1)
  return TagByteSize(l_15_0) + 4
end

DoubleByteSize = function(l_16_0, l_16_1)
  return TagByteSize(l_16_0) + 8
end

BoolByteSize = function(l_17_0, l_17_1)
  return TagByteSize(l_17_0) + 1
end

EnumByteSize = function(l_18_0, l_18_1)
  return UInt32ByteSize(l_18_0, l_18_1)
end

StringByteSize = function(l_19_0, l_19_1)
  return BytesByteSize(l_19_0, l_19_1)
end

BytesByteSize = function(l_20_0, l_20_1)
  return TagByteSize(l_20_0) + _VarUInt64ByteSizeNoTag( l_20_1) +  l_20_1
end

MessageByteSize = function(l_21_0, l_21_1)
  return TagByteSize(l_21_0) + _VarUInt64ByteSizeNoTag(l_21_1.ByteSize()) + l_21_1.ByteSize()
end

MessageSetItemByteSize = function(l_22_0, l_22_1)
  local total_size = 2 * TagByteSize(1) + TagByteSize(2) + TagByteSize(3)
  total_size = total_size + _VarUInt64ByteSizeNoTag(l_22_0)
  local message_size = l_22_1.ByteSize()
  total_size = total_size + _VarUInt64ByteSizeNoTag(message_size)
  total_size = total_size + message_size
  return total_size
end

TagByteSize = function(l_23_0)
  return _VarUInt64ByteSizeNoTag(PackTag(l_23_0, 0))
end


