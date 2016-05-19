json.array!(@js_bins) do |js_bin|
  json.extract! js_bin, :id, :html, :css, :js
  json.url js_bin_url(js_bin, format: :json)
end
