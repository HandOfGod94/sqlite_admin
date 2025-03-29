import pages/records
import pages/tables/list as tables_list
import sqlight
import wisp.{type Request, type Response}

pub fn admin_middleware(
  req req: Request,
  db db: sqlight.Connection,
  prefix prefix: String,
  app_handle_request app_handle_request: fn() -> Response,
) -> Response {
  case wisp.path_segments(req) {
    [root] if root == prefix -> tables_list.tables_list_page(db, req)
    [root, table_name, "records"] if root == prefix ->
      records.records_page(db, req, table_name)
    _ -> app_handle_request()
  }
}
