import cake/adapter/sqlite
import cake/select as s
import gleam/dynamic/decode
import gleam/list
import gleam/result
import introspect/table
import introspect/values
import sqlight

pub fn fetch_records(
  conn: sqlight.Connection,
  table_name: String,
  table_schema: table.TableSchema,
) -> Result(List(List(String)), sqlight.Error) {
  use query_result <- result.try(
    s.new()
    |> s.selects(list.map(table_schema.columns, fn(x) { s.col(x.name) }))
    |> s.from_table(table_name)
    |> s.to_query
    |> sqlite.run_read_query(decode.dynamic, conn),
  )
  Ok(
    list.map(query_result, fn(row) {
      use col_info, idx <- list.index_map(table_schema.columns)
      col_info
      |> values.from_column_info
      |> values.to_formatted_string(row, idx)
      |> result.unwrap("")
    }),
  )
}
