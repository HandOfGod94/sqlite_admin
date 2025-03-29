import pages/records
import pages/tables/list as tables_list
import sqlight
import wisp.{type Request, type Response}

pub type AdminConfig {
  AdminConfig(db: sqlight.Connection, prefix: String)
}

pub fn admin_middleware(
  req: Request,
  config: AdminConfig,
  app_handle_request: fn() -> Response,
) -> Response {
  case wisp.path_segments(req) {
    [root] if root == config.prefix ->
      tables_list.tables_list_page(config.db, req)
    [root, table_name, "records"] if root == config.prefix ->
      records.records_page(config.db, req, table_name)
    _ -> app_handle_request()
  }
}
