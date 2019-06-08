-- Command line was: E:\github\dhgametool\scripts\libprotobuf\protobuf.lua 

local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local error = error
local ipairs = ipairs
local pairs = pairs
local print = print
local table = table
local string = string
local tostring = tostring
local type = type
local pb = require("libprotobuf.proto_func")
require("libprotobuf.wire_format")
local wire_format = wire_format
require("libprotobuf.type_checkers")
local type_checkers = type_checkers
require("libprotobuf.encoder")
local encoder = encoder
require("libprotobuf.decoder")
local decoder = decoder
require("libprotobuf.listener")
local listener_mod = listener
require("libprotobuf.containers")
local containers = containers
require("libprotobuf.descriptor")
local descriptor = descriptor
local FieldDescriptor = descriptor.FieldDescriptor
require("libprotobuf.text_format")
local text_format = text_format
module("protobuf")
local make_descriptor = function(l_1_0, l_1_1, l_1_2)
  local meta = {__newindex = function(l_1_0, l_1_1, l_1_2)
    if usable_key[l_1_1] then
      rawset(l_1_0, l_1_1, l_1_2)
    else
      error("error key: " .. l_1_1)
    end
   end}
  meta.__index = meta
  meta.__call = function()
    return setmetatable({}, meta)
   end
  _M[l_1_0] = setmetatable(l_1_1, meta)
end

make_descriptor("Descriptor", {}, {name = true, full_name = true, filename = true, containing_type = true, fields = true, nested_types = true, enum_types = true, extensions = true, options = true, is_extendable = true, extension_ranges = true})
make_descriptor("FieldDescriptor", FieldDescriptor, {name = true, full_name = true, index = true, number = true, type = true, cpp_type = true, label = true, has_default_value = true, default_value = true, containing_type = true, message_type = true, enum_type = true, is_extension = true, extension_scope = true})
make_descriptor("EnumDescriptor", {}, {name = true, full_name = true, values = true, containing_type = true, options = true})
make_descriptor("EnumValueDescriptor", {}, {name = true, index = true, number = true, type = true, options = true})
local FIELD_TYPE_TO_WIRE_TYPE = {FieldDescriptor.TYPE_DOUBLE = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_FLOAT = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_INT64 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_UINT64 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_INT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_FIXED64 = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_FIXED32 = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_BOOL = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_STRING = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_GROUP = wire_format.WIRETYPE_START_GROUP, FieldDescriptor.TYPE_MESSAGE = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_BYTES = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_UINT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_ENUM = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_SFIXED32 = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_SFIXED64 = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_SINT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_SINT64 = wire_format.WIRETYPE_VARINT}
local NON_PACKABLE_TYPES = {FieldDescriptor.TYPE_STRING = true, FieldDescriptor.TYPE_GROUP = true, FieldDescriptor.TYPE_MESSAGE = true, FieldDescriptor.TYPE_BYTES = true}
local _VALUE_CHECKERS = {FieldDescriptor.CPPTYPE_INT32 = type_checkers.Int32ValueChecker(), FieldDescriptor.CPPTYPE_INT64 = type_checkers.Int32ValueChecker(), FieldDescriptor.CPPTYPE_UINT32 = type_checkers.Uint32ValueChecker(), FieldDescriptor.CPPTYPE_UINT64 = type_checkers.Uint32ValueChecker(), FieldDescriptor.CPPTYPE_DOUBLE = type_checkers.TypeChecker({number = true}), FieldDescriptor.CPPTYPE_FLOAT = type_checkers.TypeChecker({number = true}), FieldDescriptor.CPPTYPE_BOOL = type_checkers.TypeChecker({boolean = true, bool = true, int = true}), FieldDescriptor.CPPTYPE_ENUM = type_checkers.Int32ValueChecker(), FieldDescriptor.CPPTYPE_STRING = type_checkers.TypeChecker({string = true})}
local TYPE_TO_BYTE_SIZE_FN = {FieldDescriptor.TYPE_DOUBLE = wire_format.DoubleByteSize, FieldDescriptor.TYPE_FLOAT = wire_format.FloatByteSize, FieldDescriptor.TYPE_INT64 = wire_format.Int64ByteSize, FieldDescriptor.TYPE_UINT64 = wire_format.UInt64ByteSize, FieldDescriptor.TYPE_INT32 = wire_format.Int32ByteSize, FieldDescriptor.TYPE_FIXED64 = wire_format.Fixed64ByteSize, FieldDescriptor.TYPE_FIXED32 = wire_format.Fixed32ByteSize, FieldDescriptor.TYPE_BOOL = wire_format.BoolByteSize, FieldDescriptor.TYPE_STRING = wire_format.StringByteSize, FieldDescriptor.TYPE_GROUP = wire_format.GroupByteSize, FieldDescriptor.TYPE_MESSAGE = wire_format.MessageByteSize, FieldDescriptor.TYPE_BYTES = wire_format.BytesByteSize, FieldDescriptor.TYPE_UINT32 = wire_format.UInt32ByteSize, FieldDescriptor.TYPE_ENUM = wire_format.EnumByteSize, FieldDescriptor.TYPE_SFIXED32 = wire_format.SFixed32ByteSize, FieldDescriptor.TYPE_SFIXED64 = wire_format.SFixed64ByteSize, FieldDescriptor.TYPE_SINT32 = wire_format.SInt32ByteSize, FieldDescriptor.TYPE_SINT64 = wire_format.SInt64ByteSize}
local TYPE_TO_ENCODER = {FieldDescriptor.TYPE_DOUBLE = encoder.DoubleEncoder, FieldDescriptor.TYPE_FLOAT = encoder.FloatEncoder, FieldDescriptor.TYPE_INT64 = encoder.Int64Encoder, FieldDescriptor.TYPE_UINT64 = encoder.UInt64Encoder, FieldDescriptor.TYPE_INT32 = encoder.Int32Encoder, FieldDescriptor.TYPE_FIXED64 = encoder.Fixed64Encoder, FieldDescriptor.TYPE_FIXED32 = encoder.Fixed32Encoder, FieldDescriptor.TYPE_BOOL = encoder.BoolEncoder, FieldDescriptor.TYPE_STRING = encoder.StringEncoder, FieldDescriptor.TYPE_GROUP = encoder.GroupEncoder, FieldDescriptor.TYPE_MESSAGE = encoder.MessageEncoder, FieldDescriptor.TYPE_BYTES = encoder.BytesEncoder, FieldDescriptor.TYPE_UINT32 = encoder.UInt32Encoder, FieldDescriptor.TYPE_ENUM = encoder.EnumEncoder, FieldDescriptor.TYPE_SFIXED32 = encoder.SFixed32Encoder, FieldDescriptor.TYPE_SFIXED64 = encoder.SFixed64Encoder, FieldDescriptor.TYPE_SINT32 = encoder.SInt32Encoder, FieldDescriptor.TYPE_SINT64 = encoder.SInt64Encoder}
local TYPE_TO_SIZER = {FieldDescriptor.TYPE_DOUBLE = encoder.DoubleSizer, FieldDescriptor.TYPE_FLOAT = encoder.FloatSizer, FieldDescriptor.TYPE_INT64 = encoder.Int64Sizer, FieldDescriptor.TYPE_UINT64 = encoder.UInt64Sizer, FieldDescriptor.TYPE_INT32 = encoder.Int32Sizer, FieldDescriptor.TYPE_FIXED64 = encoder.Fixed64Sizer, FieldDescriptor.TYPE_FIXED32 = encoder.Fixed32Sizer, FieldDescriptor.TYPE_BOOL = encoder.BoolSizer, FieldDescriptor.TYPE_STRING = encoder.StringSizer, FieldDescriptor.TYPE_GROUP = encoder.GroupSizer, FieldDescriptor.TYPE_MESSAGE = encoder.MessageSizer, FieldDescriptor.TYPE_BYTES = encoder.BytesSizer, FieldDescriptor.TYPE_UINT32 = encoder.UInt32Sizer, FieldDescriptor.TYPE_ENUM = encoder.EnumSizer, FieldDescriptor.TYPE_SFIXED32 = encoder.SFixed32Sizer, FieldDescriptor.TYPE_SFIXED64 = encoder.SFixed64Sizer, FieldDescriptor.TYPE_SINT32 = encoder.SInt32Sizer, FieldDescriptor.TYPE_SINT64 = encoder.SInt64Sizer}
local TYPE_TO_DECODER = {FieldDescriptor.TYPE_DOUBLE = decoder.DoubleDecoder, FieldDescriptor.TYPE_FLOAT = decoder.FloatDecoder, FieldDescriptor.TYPE_INT64 = decoder.Int64Decoder, FieldDescriptor.TYPE_UINT64 = decoder.UInt64Decoder, FieldDescriptor.TYPE_INT32 = decoder.Int32Decoder, FieldDescriptor.TYPE_FIXED64 = decoder.Fixed64Decoder, FieldDescriptor.TYPE_FIXED32 = decoder.Fixed32Decoder, FieldDescriptor.TYPE_BOOL = decoder.BoolDecoder, FieldDescriptor.TYPE_STRING = decoder.StringDecoder, FieldDescriptor.TYPE_GROUP = decoder.GroupDecoder, FieldDescriptor.TYPE_MESSAGE = decoder.MessageDecoder, FieldDescriptor.TYPE_BYTES = decoder.BytesDecoder, FieldDescriptor.TYPE_UINT32 = decoder.UInt32Decoder, FieldDescriptor.TYPE_ENUM = decoder.EnumDecoder, FieldDescriptor.TYPE_SFIXED32 = decoder.SFixed32Decoder, FieldDescriptor.TYPE_SFIXED64 = decoder.SFixed64Decoder, FieldDescriptor.TYPE_SINT32 = decoder.SInt32Decoder, FieldDescriptor.TYPE_SINT64 = decoder.SInt64Decoder}
local FIELD_TYPE_TO_WIRE_TYPE = {FieldDescriptor.TYPE_DOUBLE = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_FLOAT = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_INT64 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_UINT64 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_INT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_FIXED64 = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_FIXED32 = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_BOOL = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_STRING = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_GROUP = wire_format.WIRETYPE_START_GROUP, FieldDescriptor.TYPE_MESSAGE = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_BYTES = wire_format.WIRETYPE_LENGTH_DELIMITED, FieldDescriptor.TYPE_UINT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_ENUM = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_SFIXED32 = wire_format.WIRETYPE_FIXED32, FieldDescriptor.TYPE_SFIXED64 = wire_format.WIRETYPE_FIXED64, FieldDescriptor.TYPE_SINT32 = wire_format.WIRETYPE_VARINT, FieldDescriptor.TYPE_SINT64 = wire_format.WIRETYPE_VARINT}
local IsTypePackable = function(l_2_0)
  return NON_PACKABLE_TYPES[l_2_0] == nil
end

local GetTypeChecker = function(l_3_0, l_3_1)
  if l_3_0 == FieldDescriptor.CPPTYPE_STRING and l_3_1 == FieldDescriptor.TYPE_STRING then
    return type_checkers.UnicodeValueChecker()
  end
  return _VALUE_CHECKERS[l_3_0]
end

local _DefaultValueConstructorForField = function(l_4_0)
  if l_4_0.label == FieldDescriptor.LABEL_REPEATED then
    if type(l_4_0.default_value) ~= "table" or  l_4_0.default_value ~= 0 then
      error("Repeated field default value not empty list:" .. tostring(l_4_0.default_value))
    end
    if l_4_0.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      local message_type = l_4_0.message_type
      do
        return function(l_1_0)
          return containers.RepeatedCompositeFieldContainer(l_1_0._listener_for_children, message_type)
            end
      end
    else
      local type_checker = GetTypeChecker(l_4_0.cpp_type, l_4_0.type)
      return function(l_2_0)
        return containers.RepeatedScalarFieldContainer(l_2_0._listener_for_children, type_checker)
         end
    end
  end
  if l_4_0.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
    local message_type = l_4_0.message_type
    return function(l_3_0)
      result = message_type._concrete_class()
      result._SetListener(l_3_0._listener_for_children)
      return result
      end
  end
  return function(l_4_0)
    return field.default_value
   end
end

local _AttachFieldHelpers = function(l_5_0, l_5_1)
  local is_repeated = l_5_1.label == FieldDescriptor.LABEL_REPEATED
  if l_5_1.has_options then
    local is_packed = l_5_1.GetOptions().packed
  end
  rawset(l_5_1, "_encoder", TYPE_TO_ENCODER[l_5_1.type](l_5_1.number, is_repeated, is_packed))
  rawset(l_5_1, "_sizer", TYPE_TO_SIZER[l_5_1.type](l_5_1.number, is_repeated, is_packed))
  rawset(l_5_1, "_default_constructor", _DefaultValueConstructorForField(l_5_1))
  local AddDecoder = function(l_1_0, l_1_1)
    local tag_bytes = encoder.TagBytes(field_descriptor.number, l_1_0)
    message_meta._decoders_by_tag[tag_bytes] = TYPE_TO_DECODER[field_descriptor.type](field_descriptor.number, is_repeated, l_1_1, field_descriptor, field_descriptor._default_constructor)
   end
  AddDecoder(FIELD_TYPE_TO_WIRE_TYPE[l_5_1.type], False)
  if is_repeated and IsTypePackable(l_5_1.type) then
    AddDecoder(wire_format.WIRETYPE_LENGTH_DELIMITED, True)
  end
end

local _AddEnumValues = function(l_6_0, l_6_1)
  for _,enum_type in ipairs(l_6_0.enum_types) do
    for _,enum_value in ipairs(enum_type.values) do
      l_6_1._member[enum_value.name] = enum_value.number
    end
  end
end

local _InitMethod = function(l_7_0)
  return function()
    local self = {}
    self._cached_byte_size = 0
    self._cached_byte_size_dirty = false
    self._fields = {}
    self._is_present_in_parent = false
    self._listener = listener_mod.NullMessageListener()
    self._listener_for_children = listener_mod.Listener(self)
    return setmetatable(self, message_meta)
   end
end

local _AddPropertiesForRepeatedField = function(l_8_0, l_8_1)
  local property_name = l_8_0.name
  l_8_1._getter[property_name] = function(l_1_0)
    local field_value = l_1_0._fields[field]
    if field_value == nil then
      field_value = field._default_constructor(l_1_0)
      l_1_0._fields[field] = field_value
    end
    return field_value
   end
  l_8_1._setter[property_name] = function(l_2_0)
    error("Assignment not allowed to repeated field \"" .. property_name .. "\" in protocol message object.")
   end
end

local _AddPropertiesForNonRepeatedCompositeField = function(l_9_0, l_9_1)
  local property_name = l_9_0.name
  local message_type = l_9_0.message_type
  l_9_1._getter[property_name] = function(l_1_0)
    local field_value = l_1_0._fields[field]
    if field_value == nil then
      field_value = message_type._concrete_class()
      field_value:_SetListener(l_1_0._listener_for_children)
      l_1_0._fields[field] = field_value
    end
    return field_value
   end
  l_9_1._setter[property_name] = function(l_2_0, l_2_1)
    error("Assignment not allowed to composite field" .. property_name .. "in protocol message object.")
   end
end

local _AddPropertiesForNonRepeatedScalarField = function(l_10_0, l_10_1)
  local property_name = l_10_0.name
  local type_checker = GetTypeChecker(l_10_0.cpp_type, l_10_0.type)
  local default_value = l_10_0.default_value
  l_10_1._getter[property_name] = function(l_1_0)
    local value = l_1_0._fields[field]
    if value ~= nil then
      return l_1_0._fields[field]
    else
      return default_value
    end
   end
  l_10_1._setter[property_name] = function(l_2_0, l_2_1)
    type_checker(l_2_1)
    l_2_0._fields[field] = l_2_1
    if not l_2_0._cached_byte_size_dirty then
      message._member._Modified(l_2_0)
    end
   end
end

local _AddPropertiesForField = function(l_11_0, l_11_1)
  constant_name = l_11_0.name:upper() .. "_FIELD_NUMBER"
  l_11_1._member[constant_name] = l_11_0.number
  if l_11_0.label == FieldDescriptor.LABEL_REPEATED then
    _AddPropertiesForRepeatedField(l_11_0, l_11_1)
  else
    if l_11_0.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      _AddPropertiesForNonRepeatedCompositeField(l_11_0, l_11_1)
    else
      _AddPropertiesForNonRepeatedScalarField(l_11_0, l_11_1)
    end
  end
end

local _ED_meta = {__index = function(l_12_0, l_12_1)
  local _extended_message = rawget(l_12_0, "_extended_message")
  local value = _extended_message._fields[l_12_1]
  if value ~= nil then
    return value
  end
  if l_12_1.label == FieldDescriptor.LABEL_REPEATED then
    value = l_12_1._default_constructor(l_12_0._extended_message)
  else
    if l_12_1.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      value = l_12_1.message_type._concrete_class()
      value:_SetListener(_extended_message._listener_for_children)
    else
      return l_12_1.default_value
    end
  end
  _extended_message._fields[l_12_1] = value
  return value
end
, __newindex = function(l_13_0, l_13_1, l_13_2)
  local _extended_message = rawget(l_13_0, "_extended_message")
  if l_13_1.label == FieldDescriptor.LABEL_REPEATED or l_13_1.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
    error("Cannot assign to extension \"" .. l_13_1.full_name .. "\" because it is a repeated or composite type.")
  end
  local type_checker = GetTypeChecker(l_13_1.cpp_type, l_13_1.type)
  type_checker.CheckValue(l_13_2)
  _extended_message._fields[l_13_1] = l_13_2
  _extended_message._Modified()
end
}
local _ExtensionDict = function(l_14_0)
  local o = {}
  o._extended_message = l_14_0
  return setmetatable(o, _ED_meta)
end

local _AddPropertiesForFields = function(l_15_0, l_15_1)
  for _,field in ipairs(l_15_0.fields) do
    _AddPropertiesForField(field, l_15_1)
  end
  if l_15_0.is_extendable then
    l_15_1._getter.Extensions = function(l_1_0)
    return _ExtensionDict(l_1_0)
   end
  end
end

local _AddPropertiesForExtensions = function(l_16_0, l_16_1)
  local extension_dict = l_16_0._extensions_by_name
  for extension_name,extension_field in pairs(extension_dict) do
    local constant_name = string.upper(extension_name) .. "_FIELD_NUMBER"
    l_16_1._member[constant_name] = extension_field.number
  end
end

local _AddStaticMethods = function(l_17_0)
  l_17_0._member.RegisterExtension = function(l_1_0)
    l_1_0.containing_type = message_meta._descriptor
    _AttachFieldHelpers(message_meta, l_1_0)
    if message_meta._extensions_by_number[l_1_0.number] == nil then
      message_meta._extensions_by_number[l_1_0.number] = l_1_0
    else
      error(string.format("Extensions \"%s\" and \"%s\" both try to extend message type \"%s\" with field number %d.", l_1_0.full_name, actual_handle.full_name, message_meta._descriptor.full_name, l_1_0.number))
    end
    message_meta._extensions_by_name[l_1_0.full_name] = l_1_0
   end
  l_17_0._member.FromString = function(l_2_0)
    local message = message_meta._member.__call()
    message.MergeFromString(l_2_0)
    return message
   end
end

local _IsPresent = function(l_18_0, l_18_1)
  if l_18_0.label == FieldDescriptor.LABEL_REPEATED then
    return l_18_1
  else
    if l_18_0.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      return l_18_1._is_present_in_parent
    else
      return true
    end
  end
end

local _AddListFieldsMethod = function(l_19_0, l_19_1)
  l_19_1._member.ListFields = function(l_1_0)
    local list_field = function(l_1_0)
      local f, s, v = pairs(self._fields)
      local iter = function(l_1_0, l_1_1)
        repeat
          repeat
            repeat
              do
                local descriptor, value = f(l_1_0, l_1_1)
                if descriptor == nil then
                  return 
              until _IsPresent(descriptor, value)
              else
                return descriptor, value
              end
              do return end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
      return iter, s, v
      end
    return list_field(l_1_0._fields)
   end
end

local _AddHasFieldMethod = function(l_20_0, l_20_1)
  local singular_fields = {}
  for _,field in ipairs(l_20_0.fields) do
    if field.label ~= FieldDescriptor.LABEL_REPEATED then
      singular_fields[field.name] = field
    end
  end
  l_20_1._member.HasField = function(l_1_0, l_1_1)
    field = singular_fields[l_1_1]
    if field == nil then
      error("Protocol message has no singular \"" .. l_1_1 .. "\" field.")
    end
    if field.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      value = l_1_0._fields[field]
      return (value ~= nil and value._is_present_in_parent)
    else
      return l_1_0._fields[field]
    end
   end
end

local _AddClearFieldMethod = function(l_21_0, l_21_1)
  l_21_1._member.ClearField = function(l_1_0, l_1_1)
    if message_descriptor.fields_by_name[l_1_1] == nil then
      error("Protocol message has no \"" .. l_1_1 .. "\" field.")
    end
    if l_1_0._fields[field] then
      l_1_0._fields[field] = nil
    end
    message_meta._member._Modified(l_1_0)
   end
end

local _AddClearExtensionMethod = function(l_22_0)
  l_22_0._member.ClearExtension = function(l_1_0, l_1_1)
    if l_1_0._fields[l_1_1] == nil then
      l_1_0._fields[l_1_1] = nil
    end
    message_meta._member._Modified(l_1_0)
   end
end

local _AddClearMethod = function(l_23_0, l_23_1)
  l_23_1._member.Clear = function(l_1_0)
    l_1_0._fields = {}
    message_meta._member._Modified(l_1_0)
   end
end

local _AddStrMethod = function(l_24_0)
  local format = text_format.msg_format
  l_24_0.__tostring = function(l_1_0)
    return format(l_1_0)
   end
end

local _AddHasExtensionMethod = function(l_25_0)
  l_25_0._member.HasExtension = function(l_1_0, l_1_1)
    if l_1_1.label == FieldDescriptor.LABEL_REPEATED then
      error(l_1_1.full_name .. " is repeated.")
    end
    if l_1_1.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
      value = l_1_0._fields[l_1_1]
      return (value ~= nil and value._is_present_in_parent)
    else
      return l_1_0._fields[l_1_1]
    end
   end
end

local _AddSetListenerMethod = function(l_26_0)
  l_26_0._member._SetListener = function(l_1_0, l_1_1)
    if l_1_1 ~= nil then
      l_1_0._listener = listener_mod.NullMessageListener()
    else
      l_1_0._listener = l_1_1
    end
   end
end

local _AddByteSizeMethod = function(l_27_0, l_27_1)
  l_27_1._member.ByteSize = function(l_1_0)
    if not l_1_0._cached_byte_size_dirty then
      return l_1_0._cached_byte_size
    end
    local size = 0
    for field_descriptor,field_value in message_meta._member.ListFields(l_1_0) do
      size = field_descriptor._sizer(field_value) + size
    end
    l_1_0._cached_byte_size = size
    l_1_0._cached_byte_size_dirty = false
    l_1_0._listener_for_children.dirty = false
    return size
   end
end

local _AddSerializeToStringMethod = function(l_28_0, l_28_1)
  l_28_1._member.SerializeToString = function(l_1_0)
    if not message_meta._member.IsInitialized(l_1_0) then
      error("Message is missing required fields: " .. table.concat(message_meta._member.FindInitializationErrors(l_1_0), ","))
    end
    return message_meta._member.SerializePartialToString(l_1_0)
   end
  l_28_1._member.SerializeToIOString = function(l_2_0, l_2_1)
    if not message_meta._member.IsInitialized(l_2_0) then
      error("Message is missing required fields: " .. table.concat(message_meta._member.FindInitializationErrors(l_2_0), ","))
    end
    return message_meta._member.SerializePartialToIOString(l_2_0, l_2_1)
   end
end

local _AddSerializePartialToStringMethod = function(l_29_0, l_29_1)
  local concat = table.concat
  local _internal_serialize = function(l_1_0, l_1_1)
    for field_descriptor,field_value in message_meta._member.ListFields(l_1_0) do
      field_descriptor._encoder(l_1_1, field_value)
    end
   end
  local _serialize_partial_to_iostring = function(l_2_0, l_2_1)
    local w = l_2_1.write
    local write = function(l_1_0)
      w(iostring, l_1_0)
      end
    _internal_serialize(l_2_0, write)
    return 
   end
  local _serialize_partial_to_string = function(l_3_0)
    local out = {}
    local write = function(l_1_0)
      out[ out + 1] = l_1_0
      end
    _internal_serialize(l_3_0, write)
    return concat(out)
   end
  l_29_1._member._InternalSerialize = _internal_serialize
  l_29_1._member.SerializePartialToIOString = _serialize_partial_to_iostring
  l_29_1._member.SerializePartialToString = _serialize_partial_to_string
end

local _AddMergeFromStringMethod = function(l_30_0, l_30_1)
  local ReadTag = decoder.ReadTag
  local SkipField = decoder.SkipField
  local decoders_by_tag = l_30_1._decoders_by_tag
  local _internal_parse = function(l_1_0, l_1_1, l_1_2, l_1_3)
    message_meta._member._Modified(l_1_0)
    local field_dict = l_1_0._fields
    do
      local tag_bytes, new_pos, field_decoder = nil, nil, nil
      repeat
        repeat
          if l_1_2 ~= l_1_3 then
            tag_bytes, new_pos = ReadTag(l_1_1, l_1_2)
            field_decoder = decoders_by_tag[tag_bytes]
            if field_decoder == nil then
              new_pos = SkipField(l_1_1, new_pos, l_1_3, tag_bytes)
              if new_pos == -1 then
                return l_1_2
              end
              l_1_2 = new_pos
            else
              l_1_2 = field_decoder(l_1_1, new_pos, l_1_3, l_1_0, field_dict)
            end
          else
            return l_1_2
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  l_30_1._member._InternalParse = _internal_parse
  local merge_from_string = function(l_2_0, l_2_1)
    local length =  l_2_1
    if _internal_parse(l_2_0, l_2_1, 0, length) ~= length then
      error("Unexpected end-group tag.")
    end
    return length
   end
  l_30_1._member.MergeFromString = merge_from_string
  l_30_1._member.ParseFromString = function(l_3_0, l_3_1)
    message_meta._member.Clear(l_3_0)
    merge_from_string(l_3_0, l_3_1)
   end
end

local _AddIsInitializedMethod = function(l_31_0, l_31_1)
  local required_fields = {}
  for _,field in ipairs(l_31_0.fields) do
    if field.label == FieldDescriptor.LABEL_REQUIRED then
      required_fields[ required_fields + 1] = field
    end
  end
  l_31_1._member.IsInitialized = function(l_1_0, l_1_1)
    for _,field in ipairs(required_fields) do
      if l_1_0._fields[field] == nil or field.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE and not l_1_0._fields[field]._is_present_in_parent then
        if l_1_1 ~= nil then
          l_1_1[ l_1_1 + 1] = message_meta._member.FindInitializationErrors(l_1_0)
        end
        return false
      end
    end
    for field,value in pairs(l_1_0._fields) do
      if field.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
        if field.label == FieldDescriptor.LABEL_REPEATED then
          for _,element in ipairs(value) do
            if not element:IsInitialized() then
              if l_1_1 ~= nil then
                l_1_1[ l_1_1 + 1] = message_meta._member.FindInitializationErrors(l_1_0)
              end
              return false
            end
          end
          for field,value in (for generator) do
          end
          if value._is_present_in_parent and not value:IsInitialized() then
            if l_1_1 ~= nil then
              l_1_1[ l_1_1 + 1] = message_meta._member.FindInitializationErrors(l_1_0)
            end
            return false
          end
        end
      end
      return true
       -- Warning: missing end command somewhere! Added here
    end
   end
  l_31_1._member.FindInitializationErrors = function(l_2_0)
    do
      local errors = {}
      for _,field in ipairs(required_fields) do
        if not message_meta._member.HasField(l_2_0, field.name) then
          errors.append(field.name)
        end
      end
      for field,value in message_meta._member.ListFields(l_2_0) do
        if field.cpp_type == FieldDescriptor.CPPTYPE_MESSAGE then
          if field.is_extension then
            name = io:format("(%s)", field.full_name)
          else
            name = field.name
          end
          if field.label == FieldDescriptor.LABEL_REPEATED then
            for i,element in ipairs(value) do
              prefix = io:format("%s[%d].", name, i)
              sub_errors = element:FindInitializationErrors()
              for _,e in ipairs(sub_errors) do
                errors[ errors + 1] = prefix .. e
              end
            end
            for field,value in (for generator) do
            end
            prefix = name .. "."
            sub_errors = value:FindInitializationErrors()
            for _,e in ipairs(sub_errors) do
              errors[ errors + 1] = prefix .. e
            end
          end
        end
        return errors
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
end

local _AddMergeFromMethod = function(l_32_0)
  local LABEL_REPEATED = FieldDescriptor.LABEL_REPEATED
  local CPPTYPE_MESSAGE = FieldDescriptor.CPPTYPE_MESSAGE
  l_32_0._member.MergeFrom = function(l_1_0, l_1_1)
    assert(l_1_1 ~= l_1_0)
    message_meta._member._Modified(l_1_0)
    do
      local fields = l_1_0._fields
      for field,value in pairs(l_1_1._fields) do
        if field.label == LABEL_REPEATED or field.cpp_type == CPPTYPE_MESSAGE then
          field_value = fields[field]
          if field_value == nil then
            field_value = field._default_constructor(l_1_0)
            fields[field] = field_value
          end
          field_value:MergeFrom(value)
          for field,value in (for generator) do
          end
          l_1_0._fields[field] = value
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
end

local _AddMessageMethods = function(l_33_0, l_33_1)
  _AddListFieldsMethod(l_33_0, l_33_1)
  _AddHasFieldMethod(l_33_0, l_33_1)
  _AddClearFieldMethod(l_33_0, l_33_1)
  if l_33_0.is_extendable then
    _AddClearExtensionMethod(l_33_1)
    _AddHasExtensionMethod(l_33_1)
  end
  _AddClearMethod(l_33_0, l_33_1)
  _AddStrMethod(l_33_1)
  _AddSetListenerMethod(l_33_1)
  _AddByteSizeMethod(l_33_0, l_33_1)
  _AddSerializeToStringMethod(l_33_0, l_33_1)
  _AddSerializePartialToStringMethod(l_33_0, l_33_1)
  _AddMergeFromStringMethod(l_33_0, l_33_1)
  _AddIsInitializedMethod(l_33_0, l_33_1)
  _AddMergeFromMethod(l_33_1)
end

local _AddPrivateHelperMethods = function(l_34_0)
  local Modified = function(l_1_0)
    if not l_1_0._cached_byte_size_dirty then
      l_1_0._cached_byte_size_dirty = true
      l_1_0._listener_for_children.dirty = true
      l_1_0._is_present_in_parent = true
      l_1_0._listener:Modified()
    end
   end
  l_34_0._member._Modified = Modified
  l_34_0._member.SetInParent = Modified
end

local property_getter = function(l_35_0)
  local getter = l_35_0._getter
  local member = l_35_0._member
  return function(l_1_0, l_1_1)
    local g = getter[l_1_1]
    if g then
      return g(l_1_0)
    else
      return member[l_1_1]
    end
   end
end

local property_setter = function(l_36_0)
  local setter = l_36_0._setter
  return function(l_1_0, l_1_1, l_1_2)
    local s = setter[l_1_1]
    if s then
      s(l_1_0, l_1_2)
    else
      error(l_1_1 .. " not found")
    end
   end
end

_AddClassAttributesForNestedExtensions = function(l_37_0, l_37_1)
  local extension_dict = l_37_0._extensions_by_name
  for extension_name,extension_field in pairs(extension_dict) do
    l_37_1._member[extension_name] = extension_field
  end
end

local Message = function(l_38_0)
  local message_meta = {}
  message_meta._decoders_by_tag = {}
  rawset(l_38_0, "_extensions_by_name", {})
  for _,k in ipairs(l_38_0.extensions) do
    l_38_0._extensions_by_name[k.name] = k
  end
  rawset(l_38_0, "_extensions_by_number", {})
  for _,k in ipairs(l_38_0.extensions) do
    l_38_0._extensions_by_number[k.number] = k
  end
  message_meta._descriptor = l_38_0
  message_meta._extensions_by_name = {}
  message_meta._extensions_by_number = {}
  message_meta._getter = {}
  message_meta._setter = {}
  message_meta._member = {}
  local ns = setmetatable({}, message_meta._member)
  message_meta._member.__call = _InitMethod(message_meta)
  message_meta._member.__index = message_meta._member
  message_meta._member.type = ns
  if rawget(l_38_0, "_concrete_class") == nil then
    rawset(l_38_0, "_concrete_class", ns)
    for k,field in ipairs(l_38_0.fields) do
      _AttachFieldHelpers(message_meta, field)
    end
  end
  _AddEnumValues(l_38_0, message_meta)
  _AddClassAttributesForNestedExtensions(l_38_0, message_meta)
  _AddPropertiesForFields(l_38_0, message_meta)
  _AddPropertiesForExtensions(l_38_0, message_meta)
  _AddStaticMethods(message_meta)
  _AddMessageMethods(l_38_0, message_meta)
  _AddPrivateHelperMethods(message_meta)
  message_meta.__index = property_getter(message_meta)
  message_meta.__newindex = property_setter(message_meta)
  return ns
end

_M.Message = Message

