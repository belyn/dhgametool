-- Command line was: E:\github\dhgametool\scripts\libprotobuf\encoder.lua 

local string = string
local table = table
local ipairs = ipairs
local assert = assert
local pb = require("pb")
require("libprotobuf.proto_func")
require("libprotobuf.wire_format")
local wire_format = wire_format
module("encoder")
_VarintSize = function(l_1_0)
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

_SignedVarintSize = function(l_2_0)
  if l_2_0 < 0 then
    return 10
  end
  if l_2_0 <= 127 then
    return 1
  end
  if l_2_0 <= 16383 then
    return 2
  end
  if l_2_0 <= 2097151 then
    return 3
  end
  if l_2_0 <= 268435455 then
    return 4
  end
  return 5
end

_TagSize = function(l_3_0)
  return _VarintSize(wire_format.PackTag(l_3_0, 0))
end

_SimpleSizer = function(l_4_0)
  return function(l_1_0, l_1_1, l_1_2)
    local tag_size = _TagSize(l_1_0)
    if l_1_2 then
      local VarintSize = _VarintSize
      do
        return function(l_1_0)
          local result = 0
          for _,element in ipairs(l_1_0) do
            result = result + compute_value_size(element)
          end
          return result + VarintSize(result) + tag_size
            end
      end
    elseif l_1_1 then
      return function(l_2_0)
      local result = tag_size * #l_2_0
      for _,element in ipairs(l_2_0) do
        result = result + compute_value_size(element)
      end
      return result
      end
    else
      return function(l_3_0)
      return tag_size + compute_value_size(l_3_0)
      end
    end
   end
end

_ModifiedSizer = function(l_5_0, l_5_1)
  return function(l_1_0, l_1_1, l_1_2)
    local tag_size = _TagSize(l_1_0)
    if l_1_2 then
      local VarintSize = _VarintSize
      do
        return function(l_1_0)
          local result = 0
          for _,element in ipairs(l_1_0) do
            result = result + compute_value_size(modify_value(element))
          end
          return result + VarintSize(result) + tag_size
            end
      end
    elseif l_1_1 then
      return function(l_2_0)
      local result = tag_size * #l_2_0
      for _,element in ipairs(l_2_0) do
        result = result + compute_value_size(modify_value(element))
      end
      return result
      end
    else
      return function(l_3_0)
      return tag_size + compute_value_size(modify_value(l_3_0))
      end
    end
   end
end

_FixedSizer = function(l_6_0)
  return function(l_1_0, l_1_1, l_1_2)
    local tag_size = _TagSize(l_1_0)
    if l_1_2 then
      local VarintSize = _VarintSize
      do
        return function(l_1_0)
          local result = #l_1_0 * value_size
          return result + VarintSize(result) + tag_size
            end
      end
    elseif l_1_1 then
      local element_size = value_size + tag_size
      return function(l_2_0)
        return #l_2_0 * element_size
         end
    else
      local field_size = value_size + tag_size
      return function(l_3_0)
        return field_size
         end
    end
   end
end

Int32Sizer = _SimpleSizer(_SignedVarintSize)
Int64Sizer = Int32Sizer
EnumSizer = Int32Sizer
UInt32Sizer = _SimpleSizer(_VarintSize)
UInt64Sizer = UInt32Sizer
SInt32Sizer = _ModifiedSizer(_SignedVarintSize, wire_format.ZigZagEncode)
SInt64Sizer = SInt32Sizer
Fixed32Sizer = _FixedSizer(4)
SFixed32Sizer = Fixed32Sizer
FloatSizer = Fixed32Sizer
Fixed64Sizer = _FixedSizer(8)
SFixed64Sizer = Fixed64Sizer
DoubleSizer = Fixed64Sizer
BoolSizer = _FixedSizer(1)
StringSizer = function(l_7_0, l_7_1, l_7_2)
  local tag_size = _TagSize(l_7_0)
  local VarintSize = _VarintSize
  assert( l_7_2)
  if l_7_1 then
    return function(l_1_0)
    local result = tag_size * #l_1_0
    for _,element in ipairs(l_1_0) do
      local l = #element
      result = result + VarintSize(l) + l
    end
    return result
   end
  else
    return function(l_2_0)
    local l = #l_2_0
    return tag_size + VarintSize(l) + l
   end
  end
end

BytesSizer = function(l_8_0, l_8_1, l_8_2)
  local tag_size = _TagSize(l_8_0)
  local VarintSize = _VarintSize
  assert( l_8_2)
  if l_8_1 then
    return function(l_1_0)
    local result = tag_size * #l_1_0
    for _,element in ipairs(l_1_0) do
      local l = #element
      result = result + VarintSize(l) + l
    end
    return result
   end
  else
    return function(l_2_0)
    local l = #l_2_0
    return tag_size + VarintSize(l) + l
   end
  end
end

MessageSizer = function(l_9_0, l_9_1, l_9_2)
  local tag_size = _TagSize(l_9_0)
  local VarintSize = _VarintSize
  assert( l_9_2)
  if l_9_1 then
    return function(l_1_0)
    local result = tag_size * #l_1_0
    for _,element in ipairs(l_1_0) do
      local l = element:ByteSize()
      result = result + VarintSize(l) + l
    end
    return result
   end
  else
    return function(l_2_0)
    local l = l_2_0:ByteSize()
    return tag_size + VarintSize(l) + l
   end
  end
end

local _EncodeVarint = pb.varint_encoder
local _EncodeSignedVarint = pb.signed_varint_encoder
_VarintBytes = function(l_10_0)
  local out = {}
  local write = function(l_1_0)
    out[#out + 1] = l_1_0
   end
  _EncodeSignedVarint(write, l_10_0)
  return table.concat(out)
end

TagBytes = function(l_11_0, l_11_1)
  return _VarintBytes(wire_format.PackTag(l_11_0, l_11_1))
end

_SimpleEncoder = function(l_12_0, l_12_1, l_12_2)
  return function(l_1_0, l_1_1, l_1_2)
    if l_1_2 then
      local tag_bytes = TagBytes(l_1_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
      do
        local EncodeVarint = _EncodeVarint
        return function(l_1_0, l_1_1)
          l_1_0(tag_bytes)
          local size = 0
          for _,element in ipairs(l_1_1) do
            size = size + compute_value_size(element)
          end
          EncodeVarint(l_1_0, size)
          for element in l_1_1 do
            encode_value(l_1_0, element)
          end
            end
      end
    elseif l_1_1 then
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_2_0, l_2_1)
        for _,element in ipairs(l_2_1) do
          l_2_0(tag_bytes)
          encode_value(l_2_0, element)
        end
         end
    else
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_3_0, l_3_1)
        l_3_0(tag_bytes)
        encode_value(l_3_0, l_3_1)
         end
    end
   end
end

_ModifiedEncoder = function(l_13_0, l_13_1, l_13_2, l_13_3)
  return function(l_1_0, l_1_1, l_1_2)
    if l_1_2 then
      local tag_bytes = TagBytes(l_1_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
      do
        local EncodeVarint = _EncodeVarint
        return function(l_1_0, l_1_1)
          l_1_0(tag_bytes)
          local size = 0
          for _,element in ipairs(l_1_1) do
            size = size + compute_value_size(modify_value(element))
          end
          EncodeVarint(l_1_0, size)
          for _,element in ipairs(l_1_1) do
            encode_value(l_1_0, modify_value(element))
          end
            end
      end
    elseif l_1_1 then
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_2_0, l_2_1)
        for _,element in ipairs(l_2_1) do
          l_2_0(tag_bytes)
          encode_value(l_2_0, modify_value(element))
        end
         end
    else
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_3_0, l_3_1)
        l_3_0(tag_bytes)
        encode_value(l_3_0, modify_value(l_3_1))
         end
    end
   end
end

_StructPackEncoder = function(l_14_0, l_14_1, l_14_2)
  return function(l_1_0, l_1_1, l_1_2)
    local struct_pack = struct_pack
    if l_1_2 then
      local tag_bytes = TagBytes(l_1_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
      do
        local EncodeVarint = _EncodeVarint
        return function(l_1_0, l_1_1)
          l_1_0(tag_bytes)
          EncodeVarint(l_1_0, #l_1_1 * value_size)
          for _,element in ipairs(l_1_1) do
            struct_pack(l_1_0, format, element)
          end
            end
      end
    elseif l_1_1 then
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_2_0, l_2_1)
        for _,element in ipairs(l_2_1) do
          l_2_0(tag_bytes)
          struct_pack(l_2_0, format, element)
        end
         end
    else
      local tag_bytes = TagBytes(l_1_0, wire_type)
      return function(l_3_0, l_3_1)
        l_3_0(tag_bytes)
        struct_pack(l_3_0, format, l_3_1)
         end
    end
   end
end

Int32Encoder = _SimpleEncoder(wire_format.WIRETYPE_VARINT, _EncodeSignedVarint, _SignedVarintSize)
Int64Encoder = Int32Encoder
EnumEncoder = Int32Encoder
UInt32Encoder = _SimpleEncoder(wire_format.WIRETYPE_VARINT, _EncodeVarint, _VarintSize)
UInt64Encoder = UInt32Encoder
SInt32Encoder = _ModifiedEncoder(wire_format.WIRETYPE_VARINT, _EncodeVarint, _VarintSize, wire_format.ZigZagEncode32)
SInt64Encoder = _ModifiedEncoder(wire_format.WIRETYPE_VARINT, _EncodeVarint, _VarintSize, wire_format.ZigZagEncode64)
Fixed32Encoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("I"))
Fixed64Encoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("Q"))
SFixed32Encoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("i"))
SFixed64Encoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("q"))
FloatEncoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("f"))
DoubleEncoder = _StructPackEncoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("d"))
BoolEncoder = function(l_15_0, l_15_1, l_15_2)
  local false_byte = "\0"
  local true_byte = "\1"
  if l_15_2 then
    local tag_bytes = TagBytes(l_15_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
    do
      local EncodeVarint = _EncodeVarint
      return function(l_1_0, l_1_1)
        l_1_0(tag_bytes)
        EncodeVarint(l_1_0, #l_1_1)
        for _,element in ipairs(l_1_1) do
          if element then
            l_1_0(true_byte)
            for _,element in (for generator) do
            end
            l_1_0(false_byte)
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    end
  elseif l_15_1 then
    local tag_bytes = TagBytes(l_15_0, wire_format.WIRETYPE_VARINT)
    return function(l_2_0, l_2_1)
      for _,element in ipairs(l_2_1) do
        l_2_0(tag_bytes)
        if element then
          l_2_0(true_byte)
          for _,element in (for generator) do
          end
          l_2_0(false_byte)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
  else
    local tag_bytes = TagBytes(l_15_0, wire_format.WIRETYPE_VARINT)
    return function(l_3_0, l_3_1)
      l_3_0(tag_bytes)
      if l_3_1 then
        return l_3_0(true_byte)
      end
      return l_3_0(false_byte)
      end
  end
end

StringEncoder = function(l_16_0, l_16_1, l_16_2)
  local tag = TagBytes(l_16_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
  local EncodeVarint = _EncodeVarint
  assert( l_16_2)
  if l_16_1 then
    return function(l_1_0, l_1_1)
    for _,element in ipairs(l_1_1) do
      l_1_0(tag)
      EncodeVarint(l_1_0, #element)
      l_1_0(element)
    end
   end
  else
    return function(l_2_0, l_2_1)
    l_2_0(tag)
    EncodeVarint(l_2_0, #l_2_1)
    return l_2_0(l_2_1)
   end
  end
end

BytesEncoder = function(l_17_0, l_17_1, l_17_2)
  local tag = TagBytes(l_17_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
  local EncodeVarint = _EncodeVarint
  assert( l_17_2)
  if l_17_1 then
    return function(l_1_0, l_1_1)
    for _,element in ipairs(l_1_1) do
      l_1_0(tag)
      EncodeVarint(l_1_0, #element)
      l_1_0(element)
    end
   end
  else
    return function(l_2_0, l_2_1)
    l_2_0(tag)
    EncodeVarint(l_2_0, #l_2_1)
    return l_2_0(l_2_1)
   end
  end
end

MessageEncoder = function(l_18_0, l_18_1, l_18_2)
  local tag = TagBytes(l_18_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
  local EncodeVarint = _EncodeVarint
  assert( l_18_2)
  if l_18_1 then
    return function(l_1_0, l_1_1)
    for _,element in ipairs(l_1_1) do
      l_1_0(tag)
      EncodeVarint(l_1_0, element:ByteSize())
      element:_InternalSerialize(l_1_0)
    end
   end
  else
    return function(l_2_0, l_2_1)
    l_2_0(tag)
    EncodeVarint(l_2_0, l_2_1:ByteSize())
    return l_2_1:_InternalSerialize(l_2_0)
   end
  end
end


