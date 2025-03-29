import gleam/string_tree
import pages/records
import pages/tables/list as tables_list
import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  handle_request: fn(Request) -> Response,
) -> Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- admin_middleware(req)

  handle_request(req)
}

pub fn admin_middleware(
  req: Request,
  app_handle_request: fn() -> Response,
) -> Response {
  case wisp.path_segments(req) {
    ["admin"] -> tables_list.tables_list_page(req)
    ["admin", table_name, "records"] -> records.records_page(req, table_name)
    _ -> app_handle_request()
  }
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
