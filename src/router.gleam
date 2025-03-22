import pages/home
import pages/records
import pages/tables_list
import wisp.{type Request, type Response}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}

pub fn handle_request(req: Request) -> Response {
  use req <- middleware(req)

  case wisp.path_segments(req) {
    ["admin"] -> home.home_page(req)
    ["admin", "tables"] -> tables_list.tables_list_page(req)
    ["admin", "tables", table_name, "records"] ->
      records.records_page(req, table_name)
    _ -> wisp.not_found()
  }
}
