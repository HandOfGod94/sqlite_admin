import gleam/list
import introspect/table
import layouts/base
import lustre/attribute.{class, href}
import lustre/element
import lustre/element/html.{a, div, h1, nav, table, td, th, tr}
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
  let header =
    div([class("bg-primary text-white p-4 mb-4")], [
      h1([class("display-4")], [element.text("Database Tables")]),
    ])

  let navigation =
    nav([class("mb-4")], [
      a([class("btn btn-outline-primary me-2"), href("/admin")], [
        element.text("← Back to Home"),
      ]),
    ])

  let table_rows = list.map(tables, render_table_row)

  let header_row = [
    tr([], [
      th([], [element.text("Table Name")]),
      th([], [element.text("Actions")]),
    ]),
  ]

  let tables =
    table(
      [class("table table-striped table-hover")],
      list.append(header_row, table_rows),
    )

  let main_content =
    div([class("container mt-4")], [
      div([class("row")], [div([class("col-12")], [navigation, tables])]),
    ])

  base.layout([header, main_content])
}

pub fn tables_list_page(_req: Request) -> Response {
  let tables = table.get_tables()

  let html = page_content(tables)

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
