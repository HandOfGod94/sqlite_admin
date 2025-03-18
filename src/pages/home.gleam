import lustre/element
import wisp.{type Request, type Response}

pub fn home_page(req: Request) -> Response {
  let html = element.element("h1", [], [element.text("hello world")])

  wisp.ok()
  |> wisp.html_body(element.to_string_builder(html))
}
