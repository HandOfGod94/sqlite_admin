import gleam/option
import gleeunit/should
import introspect/table
import sqlight

pub fn get_schema_test() {
  use conn <- sqlight.with_connection(":memory:")
  let assert Ok(_) =
    sqlight.exec(
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)",
      conn,
    )

  let schema = table.get_schema(conn, "users")
  let expected_schema = [
    table.ColumnInfo(
      cid: 0,
      name: "id",
      type_: "INTEGER",
      is_pk: True,
      is_not_null: False,
    ),
    table.ColumnInfo(
      cid: 1,
      name: "name",
      type_: "TEXT",
      is_pk: False,
      is_not_null: False,
    ),
    table.ColumnInfo(
      cid: 2,
      name: "email",
      type_: "TEXT",
      is_pk: False,
      is_not_null: False,
    ),
  ]
  schema |> should.equal(option.Some(table.TableSchema(expected_schema)))
}
