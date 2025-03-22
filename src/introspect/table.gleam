import cake/adapter/sqlite
import cake/select as s
import cake/where as w
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import sqlight

pub type ColumnInfo {
  ColumnInfo(
    cid: Int,
    name: String,
    type_: String,
    is_pk: Bool,
    is_not_null: Bool,
  )
}

pub type TableSchema {
  TableSchema(columns: List(ColumnInfo))
}

pub fn get_schema(table_name: String) -> Option(TableSchema) {
  // TODO: get sample db from app context, and make it result
  use conn <- sqlight.with_connection("./sample.db")

  let schema_decoder = {
    use cid <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use type_ <- decode.field(2, decode.string)
    use is_not_null <- decode.field(3, sqlight.decode_bool())
    use is_pk <- decode.field(5, sqlight.decode_bool())
    decode.success(ColumnInfo(cid, name, type_, is_pk, is_not_null))
  }

  let sql = "PRAGMA table_info(" <> table_name <> ")"
  case sqlight.query(sql, conn, [], schema_decoder) {
    Ok(column_inf_list) -> Some(TableSchema(column_inf_list))
    Error(_err) -> None
  }
}

pub fn get_tables() -> List(String) {
  // TODO: get sample db from app context, and make it result
  use conn <- sqlight.with_connection("./sample.db")
  let assert Ok(result) =
    s.new()
    |> s.selects([s.col("name")])
    |> s.from_table("sqlite_master")
    |> s.where(w.col("type") |> w.like("table"))
    |> s.to_query
    |> sqlite.run_read_query(decode.dynamic, conn)

  list.map(result, fn(x) {
    let assert Ok(val) = decode.run(x, decode.at([0], decode.string))
    val
  })
}
