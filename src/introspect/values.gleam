import gleam/dynamic/decode.{type Decoder}
import gleam/int
import gleam/result
import gleam/string
import introspect/table
import sqlight

pub type ValueType {
  IntValue(decoder: Decoder(Int))
  StringValue(decoder: Decoder(String))
  // Float
  BoolValue(decoder: Decoder(Bool))
  TimestampValue(decoder: Decoder(Int))
}

pub fn from_column_info(col_info: table.ColumnInfo) -> ValueType {
  case string.uppercase(col_info.type_) {
    "INT" -> IntValue(decode.int)
    "VARCHAR" -> StringValue(decode.string)
    // "FLOAT" -> Float
    "BOOLEAN" -> BoolValue(sqlight.decode_bool())
    "TIMESTAMP" -> TimestampValue(decode.int)
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
    BoolValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      case val {
        True -> Ok("✔️")
        False -> Ok("❌")
      }
    }
  }
}
