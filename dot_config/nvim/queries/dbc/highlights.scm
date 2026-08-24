; Section keywords
[
  "VERSION"
  "NS_ :"
  "BS_:"
  "BU_:"
  "VAL_TABLE_"
  "BO_"
  "BO_TX_BU_"
  "SG_"
  "SG_MUL_VAL_"
  "VAL_"
  "EV_"
  "ENVVAR_DATA_"
  "SGTYPE_"
  "SIG_GROUP_"
  "SIG_VALTYPE_"
  "SIG_TYPE_REF_"
  "CM_"
  "BA_DEF_"
  "BA_DEF_DEF_"
  "BA_"
] @keyword

; _ns_symbol keywords (NS_ block contents)
[
  "NS_DESC_"
  "CAT_DEF_"
  "CAT_"
  "FILTER"
  "EV_DATA_"
  "SGTYPE_VAL_"
  "BA_DEF_SGTYPE_"
  "BA_SGTYPE_"
  "SIGTYPE_VALTYPE_"
  "BA_DEF_REL_"
  "BA_REL_"
  "BA_DEF_DEF_REL_"
  "BU_SG_REL_"
  "BU_EV_REL_"
  "BU_BO_REL_"
] @keyword

; attribute_value_type keywords
[
  "INT"
  "HEX"
  "FLOAT"
  "STRING"
  "ENUM"
] @type.builtin

; access_type placeholders
[
  "DUMMY_NODE_VECTOR0"
  "DUMMY_NODE_VECTOR1"
  "DUMMY_NODE_VECTOR2"
  "DUMMY_NODE_VECTOR3"
  "DUMMY_NODE_VECTOR8000"
  "DUMMY_NODE_VECTOR8001"
  "DUMMY_NODE_VECTOR8002"
  "DUMMY_NODE_VECTOR8003"
] @constant

; implicit "no node" placeholders
[
  "Vector__XXX"
  "VECTOR__XXX"
] @constant.builtin

; multiplexer markers
["m" "M"] @keyword

; punctuation
[";" ":" ","] @punctuation.delimiter
["(" ")" "[" "]"] @punctuation.bracket
["\""] @punctuation.bracket
["|" "@" "-"] @operator

; literals
(dbc_identifier) @variable
(char_string) @string
(unsigned_integer) @number
(signed_integer) @number
(double) @number
(byte_order) @number
(env_var_type) @number
(signal_extended_value_type) @number
(value_type) @operator

; documentation strings attached via CM_ statements read as comments
(comment (char_string) @comment)

; identifiers with a more specific role
(message_name) @type
(value_table_name) @type
(signal_type_name) @type
(signal_group_name) @type
(signal_name) @property
(multiplexed_signal_name) @property
(multiplexor_switch_name) @property
(attribute_name) @property
