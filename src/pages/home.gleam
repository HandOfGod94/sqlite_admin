import layouts/base
import lustre/attribute
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

fn page_content() {
  let header =
    html.div([attribute.class("bg-primary text-white p-4 mb-4")], [
      html.h1([attribute.class("display-4")], [element.text("SQLite Admin")]),
      html.p([attribute.class("lead")], [
        element.text("Manage your SQLite databases with ease"),
      ]),
    ])

  let main_content =
    html.div([attribute.class("container mt-4")], [
      html.div([attribute.class("row")], [
        html.div([attribute.class("col-md-6 mb-4")], [
          html.div([attribute.class("card")], [
            html.div([attribute.class("card-header")], [
              html.h5([attribute.class("card-title mb-0")], [
                element.text("Database Connection"),
              ]),
            ]),
            html.div([attribute.class("card-body")], [
              html.form([], [
                html.div([attribute.class("mb-3")], [
                  html.div([attribute.class("form-label")], [
                    element.text("Database Path"),
                  ]),
                  html.input([
                    attribute.class("form-control"),
                    attribute.type_("text"),
                    attribute.placeholder("Enter database path"),
                  ]),
                ]),
                html.button(
                  [
                    attribute.class("btn btn-primary"),
                    attribute.type_("submit"),
                  ],
                  [element.text("Connect")],
                ),
              ]),
            ]),
          ]),
        ]),
        html.div([attribute.class("col-md-6 mb-4")], [
          html.div([attribute.class("card")], [
            html.div([attribute.class("card-header")], [
              html.h5([attribute.class("card-title mb-0")], [
                element.text("Recent Databases"),
              ]),
            ]),
            html.div([attribute.class("card-body")], [
              html.div([attribute.class("list-group")], [
                html.a(
                  [
                    attribute.class("list-group-item list-group-item-action"),
                    attribute.href("#"),
                  ],
                  [element.text("example.db")],
                ),
                html.a(
                  [
                    attribute.class("list-group-item list-group-item-action"),
                    attribute.href("#"),
                  ],
                  [element.text("test.db")],
                ),
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
