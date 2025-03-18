import layouts/base
import lustre/attribute
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

fn page_content() {
  base.layout([html.h1([], [element.text("hello world")])])
}

pub fn home_page(_req: Request) -> Response {
  let html = page_content()

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
