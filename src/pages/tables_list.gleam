import gleam/int
import gleam/list
import layouts/base
import lustre/attribute.{class, href}
import lustre/element
import lustre/element/html.{a, div, h1, nav, table, td, th, tr}
import wisp.{type Request, type Response}

type TableData {
  TableData(name: String, row_count: Int)
}

fn render_table_row(table_data: TableData) -> element.Element(a) {
  tr([], [
    td([], [element.text(table_data.name)]),
    td([], [element.text(int.to_string(table_data.row_count))]),
    td([], [
      a(
        [
          class("btn btn-sm btn-primary me-2"),
          href("/tables/" <> table_data.name),
        ],
        [element.text("View")],
      ),
      a(
        [
          class("btn btn-sm btn-danger"),
          href("/tables/" <> table_data.name <> "/delete"),
        ],
        [element.text("Delete")],
      ),
    ]),
  ])
}

fn page_content(tables: List(TableData)) {
  let header =
    div([class("bg-primary text-white p-4 mb-4")], [
      h1([class("display-4")], [element.text("Database Tables")]),
    ])

  let navigation =
    nav([class("mb-4")], [
      a([class("btn btn-outline-primary me-2"), href("/")], [
        element.text("← Back to Home"),
      ]),
    ])

  let table_rows = list.map(tables, render_table_row)

  let header_row = [
    tr([], [
      th([], [element.text("Table Name")]),
      th([], [element.text("Row Count")]),
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
  let dummy_tables = [
    TableData("users", 150),
    TableData("products", 75),
    TableData("orders", 300),
  ]

  let html = page_content(dummy_tables)

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
