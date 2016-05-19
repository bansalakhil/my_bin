module ApplicationHelper

  def generate_html(js_bin)
    doc = Nokogiri::HTML.parse(js_bin.html)
    body = doc.at("body")
    head = doc.at("head")
    head.add_child("<style>\n#{js_bin.css}</style>")
    body.add_child("<script language = 'javascript'>\n#{js_bin.js}</script>")
    doc.to_html.html_safe
  end
end
