-- Command line was: E:\github\dhgametool\scripts\libprotobuf\decoder.lua 

local string = string
local table = table
local assert = assert
local ipairs = ipairs
local error = error
local print = print
local pb = require("pb")
local encoder = require("encoder")
local wire_format = require("wire_format")
module("decoder")
local _DecodeVarint = pb.varint_decoder
local _DecodeSignedVarint = pb.signed_varint_decoder
local _DecodeVarint32 = pb.varint_decoder
local _DecodeSignedVarint32 = pb.signed_varint_decoder
ReadTag = pb.read_tag
local _SimpleDecoder = function(l_1_0, l_1_1)
  return function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
    if l_1_2 then
      local DecodeVarint = _DecodeVarint
      do
        return function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
          local value = l_1_4[key]
          if value == nil then
            value = new_default(l_1_3)
            l_1_4[key] = value
          end
          local endpoint = nil
          endpoint, l_1_1 = DecodeVarint(l_1_0, l_1_1)
          endpoint = endpoint + l_1_1
          if l_1_2 < endpoint then
            error("Truncated message.")
          end
          do
            local element = nil
            repeat
              if l_1_1 < endpoint then
                element, l_1_1 = decode_value(l_1_0, l_1_1)
                value[#value + 1] = element
              elseif endpoint < l_1_1 then
                value:remove(#value)
                error("Packed element was truncated.")
              end
              return l_1_1
            end
             -- Warning: missing end command somewhere! Added here
          end
            end
      end
    elseif l_1_1 then
      local tag_bytes = encoder.TagBytes(l_1_0, wire_type)
      local tag_len = #tag_bytes
      local sub = string.sub
      return function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
        do
          local value = l_2_4[key]
          if value == nil then
            value = new_default(l_2_3)
            l_2_4[key] = value
          end
          repeat
            repeat
              do
                local element, new_pos = decode_value(l_2_0, l_2_1)
                value:append(element)
                l_2_1 = new_pos + tag_len
              until sub(l_2_0, new_pos + 1, l_2_1) ~= tag_bytes or l_2_2 <= new_pos
              if l_2_2 < new_pos then
                error("Truncated message.")
              end
              return new_pos
            end
            do return end
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    else
      return function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
      l_3_4[key], l_3_1 = decode_value(l_3_0, l_3_1)
      if l_3_2 < l_3_1 then
        l_3_4[key] = nil
        error("Truncated message.")
      end
      return l_3_1
      end
    end
   end
end

local _ModifiedDecoder = function(l_2_0, l_2_1, l_2_2)
  local InnerDecode = function(l_1_0, l_1_1)
    local result, new_pos = decode_value(l_1_0, l_1_1)
    return modify_value(result), new_pos
   end
  return _SimpleDecoder(l_2_0, InnerDecode)
end

local _StructPackDecoder = function(l_3_0, l_3_1, l_3_2)
  local struct_unpack = pb.struct_unpack
  InnerDecode = function(l_1_0, l_1_1)
    local new_pos = l_1_1 + value_size
    local result = struct_unpack(format, l_1_0, l_1_1)
    return result, new_pos
   end
  return _SimpleDecoder(l_3_0, InnerDecode)
end

local _Boolean = function(l_4_0)
  return l_4_0 ~= 0
end

Int32Decoder = _SimpleDecoder(wire_format.WIRETYPE_VARINT, _DecodeSignedVarint32)
EnumDecoder = Int32Decoder
Int64Decoder = _SimpleDecoder(wire_format.WIRETYPE_VARINT, _DecodeSignedVarint)
UInt32Decoder = _SimpleDecoder(wire_format.WIRETYPE_VARINT, _DecodeVarint32)
UInt64Decoder = _SimpleDecoder(wire_format.WIRETYPE_VARINT, _DecodeVarint)
SInt32Decoder = _ModifiedDecoder(wire_format.WIRETYPE_VARINT, _DecodeVarint32, wire_format.ZigZagDecode32)
SInt64Decoder = _ModifiedDecoder(wire_format.WIRETYPE_VARINT, _DecodeVarint, wire_format.ZigZagDecode64)
Fixed32Decoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("I"))
Fixed64Decoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("Q"))
SFixed32Decoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("i"))
SFixed64Decoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("q"))
FloatDecoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED32, 4, string.byte("f"))
DoubleDecoder = _StructPackDecoder(wire_format.WIRETYPE_FIXED64, 8, string.byte("d"))
BoolDecoder = _ModifiedDecoder(wire_format.WIRETYPE_VARINT, _DecodeVarint, _Boolean)
StringDecoder = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  local DecodeVarint = _DecodeVarint
  local sub = string.sub
  assert( l_5_2)
  if l_5_1 then
    local tag_bytes = encoder.TagBytes(l_5_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
    do
      local tag_len = #tag_bytes
      return function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
        do
          local value = l_1_4[key]
          if value == nil then
            value = new_default(l_1_3)
            l_1_4[key] = value
          end
          repeat
            repeat
              do
                local size, new_pos = nil, nil
                size, l_1_1 = DecodeVarint(l_1_0, l_1_1)
                new_pos = l_1_1 + size
                if l_1_2 < new_pos then
                  error("Truncated string.")
                end
                value:append(sub(l_1_0, l_1_1 + 1, new_pos))
                l_1_1 = new_pos + tag_len
              until sub(l_1_0, new_pos + 1, l_1_1) ~= tag_bytes or new_pos == l_1_2
              return new_pos
            end
            do return end
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    end
  else
    return function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
    local size, new_pos = nil, nil
    size, l_2_1 = DecodeVarint(l_2_0, l_2_1)
    new_pos = l_2_1 + size
    if l_2_2 < new_pos then
      error("Truncated string.")
    end
    l_2_4[key] = sub(l_2_0, l_2_1 + 1, new_pos)
    return new_pos
   end
  end
end

BytesDecoder = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local DecodeVarint = _DecodeVarint
  local sub = string.sub
  assert( l_6_2)
  if l_6_1 then
    local tag_bytes = encoder.TagBytes(l_6_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
    do
      local tag_len = #tag_bytes
      return function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
        do
          local value = l_1_4[key]
          if value == nil then
            value = new_default(l_1_3)
            l_1_4[key] = value
          end
          repeat
            repeat
              do
                local size, new_pos = nil, nil
                size, l_1_1 = DecodeVarint(l_1_0, l_1_1)
                new_pos = l_1_1 + size
                if l_1_2 < new_pos then
                  error("Truncated string.")
                end
                value:append(sub(l_1_0, l_1_1 + 1, new_pos))
                l_1_1 = new_pos + tag_len
              until sub(l_1_0, new_pos + 1, l_1_1) ~= tag_bytes or new_pos == l_1_2
              return new_pos
            end
            do return end
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    end
  else
    return function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
    local size, new_pos = nil, nil
    size, l_2_1 = DecodeVarint(l_2_0, l_2_1)
    new_pos = l_2_1 + size
    if l_2_2 < new_pos then
      error("Truncated string.")
    end
    l_2_4[key] = sub(l_2_0, l_2_1 + 1, new_pos)
    return new_pos
   end
  end
end

MessageDecoder = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  local DecodeVarint = _DecodeVarint
  local sub = string.sub
  assert( l_7_2)
  if l_7_1 then
    local tag_bytes = encoder.TagBytes(l_7_0, wire_format.WIRETYPE_LENGTH_DELIMITED)
    do
      local tag_len = #tag_bytes
      return function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
        do
          local value = l_1_4[key]
          if value == nil then
            value = new_default(l_1_3)
            l_1_4[key] = value
          end
          repeat
            repeat
              do
                local size, new_pos = nil, nil
                size, l_1_1 = DecodeVarint(l_1_0, l_1_1)
                new_pos = l_1_1 + size
                if l_1_2 < new_pos then
                  error("Truncated message.")
                end
                if value:add():_InternalParse(l_1_0, l_1_1, new_pos) ~= new_pos then
                  error("Unexpected end-group tag.")
                end
                l_1_1 = new_pos + tag_len
              until sub(l_1_0, new_pos + 1, l_1_1) ~= tag_bytes or new_pos == l_1_2
              return new_pos
            end
            do return end
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    end
  else
    return function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
    local value = l_2_4[key]
    if value == nil then
      value = new_default(l_2_3)
      l_2_4[key] = value
    end
    local size, new_pos = nil, nil
    size, l_2_1 = DecodeVarint(l_2_0, l_2_1)
    new_pos = l_2_1 + size
    if l_2_2 < new_pos then
      error("Truncated message.")
    end
    if value:_InternalParse(l_2_0, l_2_1, new_pos) ~= new_pos then
      error("Unexpected end-group tag.")
    end
    return new_pos
   end
  end
end

_SkipVarint = function(l_8_0, l_8_1, l_8_2)
  local value = nil
  value, l_8_1 = _DecodeVarint(l_8_0, l_8_1)
  return l_8_1
end

_SkipFixed64 = function(l_9_0, l_9_1, l_9_2)
  l_9_1 = l_9_1 + 8
  if l_9_2 < l_9_1 then
    error("Truncated message.")
  end
  return l_9_1
end

_SkipLengthDelimited = function(l_10_0, l_10_1, l_10_2)
  local size = nil
  size, l_10_1 = _DecodeVarint(l_10_0, l_10_1)
  l_10_1 = l_10_1 + size
  if l_10_2 < l_10_1 then
    error("Truncated message.")
  end
  return l_10_1
end

_SkipFixed32 = function(l_11_0, l_11_1, l_11_2)
  l_11_1 = l_11_1 + 4
  if l_11_2 < l_11_1 then
    error("Truncated message.")
  end
  return l_11_1
end

_RaiseInvalidWireType = function(l_12_0, l_12_1, l_12_2)
  error("Tag had invalid wire type.")
end

_FieldSkipper = function()
  WIRETYPE_TO_SKIPPER = {_SkipVarint, _SkipFixed64, _SkipLengthDelimited, _SkipGroup, _EndGroup, _SkipFixed32, _RaiseInvalidWireType, _RaiseInvalidWireType}
  local ord = string.byte
  local sub = string.sub
  return function(l_1_0, l_1_1, l_1_2, l_1_3)
    local wire_type = ord(sub(l_1_3, 1, 1)) % 8 + 1
    return WIRETYPE_TO_SKIPPER[wire_type](l_1_0, l_1_1, l_1_2)
   end
end

SkipField = _FieldSkipper()

