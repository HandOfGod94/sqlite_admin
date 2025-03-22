import layouts/base
import lustre/attribute.{class, href, placeholder, type_}
import lustre/element
import lustre/element/html.{a, div, form, h1, h5, input, p}
import wisp.{type Request, type Response}

fn page_content() {
  let header =
    div([class("bg-primary text-white p-4 mb-4")], [
      h1([class("display-4")], [element.text("SQLite Admin")]),
      p([class("lead")], [
        element.text("Manage your SQLite databases with ease"),
      ]),
    ])

  let main_content =
    div([class("container mt-4")], [
      div([class("row")], [
        div([class("col-md-6 mb-4")], [
          div([class("card")], [
            div([class("card-header")], [
              h5([class("card-title mb-0")], [
                element.text("Database Connection"),
              ]),
            ]),
            div([class("card-body")], [
              form([], [
                div([class("mb-3")], [
                  div([class("form-label")], [element.text("Database Path")]),
                  input([
                    class("form-control"),
                    type_("text"),
                    placeholder("Enter database path"),
                  ]),
                ]),
                a([class("btn btn-primary"), href("/tables")], [
                  element.text("Connect"),
                ]),
              ]),
            ]),
          ]),
        ]),
        div([class("col-md-6 mb-4")], [
          div([class("card")], [
            div([class("card-header")], [
              h5([class("card-title mb-0")], [element.text("Recent Databases")]),
            ]),
            div([class("card-body")], [
              div([class("list-group")], [
                a([class("list-group-item list-group-item-action"), href("#")], [
                  element.text("example.db"),
                ]),
                a([class("list-group-item list-group-item-action"), href("#")], [
                  element.text("test.db"),
                ]),
              ]),
            ]),
          ]),
        ]),
      ]),
    ])

  base.layout([header, main_content])
}

pub fn home_page(_req: Request) -> Response {
  let html = page_content()

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
