import birl
import gleam/dynamic/decode.{type Decoder}
import gleam/float
import gleam/int
import gleam/result
import gleam/string
import introspect/table
import sqlight

pub type ValueType {
  IntValue(decoder: Decoder(Int))
  StringValue(decoder: Decoder(String))
  FloatValue(decoder: Decoder(Float))
  BoolValue(decoder: Decoder(Bool))
  TimestampValue(decoder: Decoder(Int))
}

pub fn from_column_info(col_info: table.ColumnInfo) -> ValueType {
  case string.uppercase(col_info.type_) {
    "INT"
    | "INTEGER"
    | "TINYINT"
    | "SMALLINT"
    | "MEDIUMINT"
    | "BIGINT"
    | "UNSIGNED BIG INT"
    | "INT2"
    | "INT8" -> IntValue(decode.int)
    "VARCHAR" -> StringValue(decode.string)
    "FLOAT" | "DOUBLE" | "REAL" | "DOUBLE PRECISION" | "NUMERIC" ->
      FloatValue(decode.float)
    "BOOLEAN" -> BoolValue(sqlight.decode_bool())
    "TIMESTAMP" | "DATETIME" | "DATE" -> TimestampValue(decode.int)
    _ -> StringValue(decode.string)
  }
}

pub fn decode_to_string(
  record_type: ValueType,
  value: decode.Dynamic,
  index: Int,
) -> Result(String, List(decode.DecodeError)) {
  case record_type {
    IntValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      Ok(int.to_string(val))
    }
    TimestampValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      Ok(val |> birl.from_unix |> birl.to_iso8601)
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
    FloatValue(decoder) -> {
      use val <- result.try(decode.run(value, decode.at([index], decoder)))
      Ok(float.to_string(val))
    }
  }
}
