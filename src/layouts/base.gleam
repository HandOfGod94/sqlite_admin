import lustre/attribute.{class, href, rel, src}
import lustre/element
import lustre/element/html.{a, body, div, head, html, link, nav, script}
import lustre/internals/vdom

pub fn layout(children: List(vdom.Element(a))) -> vdom.Element(a) {
  html([], [
    head([], [
      link([
        href(
          "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
        ),
        rel("stylesheet"),
      ]),
      script(
        [
          src(
            "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js",
          ),
        ],
        "",
      ),
    ]),
    body([], [
      nav([class("navbar navbar-expand bg-body-tertiary mb-5")], [
        // TODO: get root address from config
        div([class("container-fluid")], [
          a([class("navbar-brand"), href("/admin")], [
            element.text("SQLite Admin"),
          ]),
        ]),
      ]),
      div([class("container")], children),
    ]),
  ])
}
