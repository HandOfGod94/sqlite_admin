import lustre/attribute
import lustre/element/html
import lustre/internals/vdom

pub fn layout(children: List(vdom.Element(a))) -> vdom.Element(a) {
  html.html([], [
    html.head([], [
      html.link([
        attribute.href(
          "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
        ),
        attribute.rel("stylesheet"),
      ]),
      html.script(
        [
          attribute.src(
            "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js",
          ),
        ],
        "",
      ),
    ]),
    html.body([], [html.div([attribute.class("container")], children)]),
  ])
}
