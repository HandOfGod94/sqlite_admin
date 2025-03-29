import gleam/erlang/process
import mist
import router
import sqlight
import wisp
import wisp/wisp_mist

pub type Context {
  Context(db: sqlight.Connection, prefix: String)
}

pub fn main() {
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(32)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key_base)
    |> mist.new
    |> mist.port(8081)
    |> mist.start_http

  process.sleep_forever()
}
