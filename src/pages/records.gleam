import gleam/list
import gleam/option.{Some}
import introspect/table
import layouts/base
import lustre/attribute.{class, href}
import lustre/element
import lustre/element/html.{a, button, div, h1, nav, table, td, th, tr}
import records/records
import wisp.{type Request, type Response}

fn render_record_row(records: List(String)) -> element.Element(a) {
  let action_buttons =
    div([class("btn-group")], [
      button([class("btn btn-sm btn-info me-1")], [element.text("Show")]),
      button([class("btn btn-sm btn-warning me-1")], [element.text("Edit")]),
      button([class("btn btn-sm btn-danger")], [element.text("Delete")]),
    ])

  tr(
    [],
    list.map(records, fn(x) { td([], [element.text(x)]) })
      |> list.append([td([], [action_buttons])]),
  )
}

fn page_content(
  table_name: String,
  table_schema: table.TableSchema,
  records: List(List(String)),
) {
  let header =
    div([class("bg-primary text-white p-4 mb-4")], [
      h1([class("display-4")], [element.text("Records for " <> table_name)]),
    ])

  let navigation =
    nav([class("mb-4")], [
      a([class("btn btn-outline-primary me-2"), href("/admin/")], [
        element.text("← Back to Tables"),
      ]),
    ])

  let header_row = [
    tr(
      [],
      list.append(
        list.map(table_schema.columns, fn(x) { th([], [element.text(x.name)]) }),
        [th([], [element.text("Actions")])],
      ),
    ),
  ]

  let main_content =
    div([class("container mt-4")], [
      div([class("row")], [
        div([class("col-12")], [
          navigation,
          table(
            [class("table table-striped table-hover")],
            list.append(header_row, list.map(records, render_record_row)),
          ),
        ]),
      ]),
    ])

  base.layout([header, main_content])
}

pub fn records_page(_req: Request, table_name: String) -> Response {
  let assert Some(table_schema) = table.get_schema(table_name)
  let assert Ok(records) = records.fetch_records(table_name, table_schema)

  let html = page_content(table_name, table_schema, records)

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
