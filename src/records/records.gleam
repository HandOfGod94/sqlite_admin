import cake/adapter/sqlite
import cake/select as s
import gleam/dynamic/decode
import gleam/int
import gleam/list
import introspect/table
import sqlight

pub fn fetch_records(
  table_name: String,
  table_schema: table.TableSchema,
) -> List(List(String)) {
  // TODO: send this info from app context
  // TODO: currently the dict is only String, i.e. convert everything to string to render. 
  use conn <- sqlight.with_connection("./sample.db")

  let columns = list.map(table_schema.columns, fn(x) { s.col(x.name) })
  let query =
    s.new() |> s.selects(columns) |> s.from_table(table_name) |> s.to_query

  let assert Ok(result) = sqlite.run_read_query(query, decode.dynamic, conn)

  // TODO: handle errors correctly, and use correct decoder funtions, based on data types
  list.map(result, fn(row) {
    list.index_map(table_schema.columns, fn(x, i) {
      case x.type_ {
        "INT" | "timestamp" -> {
          let assert Ok(val) = decode.run(row, decode.at([i], decode.int))
          int.to_string(val)
        }
        "varchar" -> {
          let assert Ok(val) = decode.run(row, decode.at([i], decode.string))
          val
        }
        _ -> ""
      }
    })
  })
}
