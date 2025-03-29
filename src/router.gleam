import gleam/string_tree
import middleware
import sqlight
import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  handle_request: fn(Request) -> Response,
) -> Response {
  use db <- sqlight.with_connection("./sample.db")

  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- middleware.admin_middleware(req: req, db: db, prefix: "admin")

  handle_request(req)
}

pub fn handle_request(req: Request) -> Response {
  use req <- middleware(req)

  case wisp.path_segments(req) {
    [] -> {
      let welcome = "<h1>Welcome</h1>"
      wisp.ok()
      |> wisp.html_body(string_tree.from_string(welcome))
    }

    _ -> wisp.not_found()
  }
}
