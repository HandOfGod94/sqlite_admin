import gleam/dynamic/decode.{type Decoder}
import gleam/int
import gleam/result
import introspect/table

pub type ValueType {
  IntValue(decoder: Decoder(Int))
  StringValue(decoder: Decoder(String))
  // Float
  // Bool
  TimestampValue(decoder: Decoder(Int))
}

pub fn from_column_info(col_info: table.ColumnInfo) -> ValueType {
  case col_info.type_ {
    "INT" -> IntValue(decode.int)
    "VARCHAR" -> StringValue(decode.string)
    // "FLOAT" -> Float
    // "BOOL" -> Bool
    "timestamp" -> TimestampValue(decode.int)
    _ -> StringValue(decode.string)
  }
}

pub fn decode_to_string(
  record_type: ValueType,
  value: decode.Dynamic,
  index: Int,
) -> Result(String, List(decode.DecodeError)) {
  case record_type {
    IntValue(decoder) | TimestampValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      Ok(int.to_string(val))
    }
    StringValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      Ok(val)
    }
  }
}
