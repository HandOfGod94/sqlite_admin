import layouts/base
import lustre/attribute.{class, href}
import lustre/element
import lustre/element/html.{a, div, h1, nav, table, td, th, tr}
import wisp.{type Request, type Response}

fn page_content() {
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

  let tables =
    table([class("table table-striped table-hover")], [
      tr([], [
        th([], [element.text("Table Name")]),
        th([], [element.text("Row Count")]),
        th([], [element.text("Actions")]),
      ]),
      tr([], [
        td([], [element.text("users")]),
        td([], [element.text("150")]),
        td([], [
          a([class("btn btn-sm btn-primary me-2"), href("/tables/users")], [
            element.text("View"),
          ]),
          a([class("btn btn-sm btn-danger"), href("/tables/users/delete")], [
            element.text("Delete"),
          ]),
        ]),
      ]),
      tr([], [
        td([], [element.text("products")]),
        td([], [element.text("75")]),
        td([], [
          a([class("btn btn-sm btn-primary me-2"), href("/tables/products")], [
            element.text("View"),
          ]),
          a([class("btn btn-sm btn-danger"), href("/tables/products/delete")], [
            element.text("Delete"),
          ]),
        ]),
      ]),
      tr([], [
        td([], [element.text("orders")]),
        td([], [element.text("300")]),
        td([], [
          a([class("btn btn-sm btn-primary me-2"), href("/tables/orders")], [
            element.text("View"),
          ]),
          a([class("btn btn-sm btn-danger"), href("/tables/orders/delete")], [
            element.text("Delete"),
          ]),
        ]),
      ]),
    ])

  let main_content =
    div([class("container mt-4")], [
      div([class("row")], [div([class("col-12")], [navigation, tables])]),
    ])

  base.layout([header, main_content])
}

pub fn tables_list_page(_req: Request) -> Response {
  let html = page_content()

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
