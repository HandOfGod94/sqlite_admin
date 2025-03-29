import pages/records
import pages/tables/list as tables_list
import wisp.{type Request, type Response}

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
