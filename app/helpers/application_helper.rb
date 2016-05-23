module ApplicationHelper
  FLASH_CLASS = {
    notice: "alert alert-info",
    success: "alert alert-success",
    error: "alert alert-danger",
    alert: "alert alert-warning"
  }

  def flash_class(type)
    FLASH_CLASS[type.to_sym]
  end


  def active_class?(*paths)
    # debugger
    active = false
    paths.each { |path| active ||= current_page?(path) }
    active ? 'active' : nil
  end

  def generate_html(js_bin, hijack_js_console = true)
    doc = Nokogiri::HTML.parse(js_bin.html)
    body = doc.at("body")
    head = doc.at("head")
    head.add_child("<style>\n#{js_bin.css}</style>")
    body.add_child(render(partial: "js_bins/hijack_js_console")) if hijack_js_console
    body.add_child("<script language = 'javascript'>\n#{js_bin.js}</script>")
    doc.to_html.html_safe
  end
end
