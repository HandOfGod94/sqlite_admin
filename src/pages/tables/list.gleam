import gleam/list
import introspect/table
import layouts/base
import lustre/attribute.{class, href}
import lustre/element
import lustre/element/html.{a, div, table, td, th, tr}
import sqlight
import wisp.{type Request, type Response}

fn render_table_row(table_name: String) -> element.Element(a) {
  tr([], [
    td([], [element.text(table_name)]),
    td([], [
      a(
        [
          class("btn btn-sm btn-primary me-2"),
          href("/admin/" <> table_name <> "/records"),
        ],
        [element.text("View")],
      ),
      a(
        [
          class("btn btn-sm btn-danger"),
          href("/admin/tables/" <> table_name <> "/delete"),
        ],
        [element.text("Delete")],
      ),
    ]),
  ])
}

fn page_content(tables: List(String)) {
  let table_rows = list.map(tables, render_table_row)

  let header_row = [
    tr([], [
      th([], [element.text("Table Name")]),
      th([], [element.text("Actions")]),
    ]),
  ]

  base.layout([
    div([class("container mt-4")], [
      div([class("row")], [
        div([class("col-12")], [
          table(
            [class("table table-striped table-hover")],
            list.append(header_row, table_rows),
          ),
        ]),
      ]),
    ]),
  ])
}

pub fn tables_list_page(db: sqlight.Connection, _req: Request) -> Response {
  let tables = table.get_tables(db)

  let html = page_content(tables)

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
