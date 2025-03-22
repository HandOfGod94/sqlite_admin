import lustre/attribute.{class, href, rel, src}
import lustre/element/html.{body, div, head, html, link, script}
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
    body([], [div([class("container")], children)]),
  ])
}
