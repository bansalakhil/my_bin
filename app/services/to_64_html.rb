require 'base64'

# converts attached PNGs into base64 strings

# Eg
# <img src="my.png" /> to <img src="data:image/png;base64,..." />

class To64Html

  def initialize(path)
    @path = path
  end

  def self.img64(path)
    File.open(path, 'rb') do |img|
      'data:image/png;base64,' + Base64.strict_encode64(img.read)
    end
  end

  def html(name='based64.html')
    File.open(@path, 'r') do |h|
      html = h.read.gsub(/src="(.*\.png)"/) do |g|
        "src='#{To64Html::img64($1)}'"
      end

      IO.write(name, html)

      p 'done'
    end
  end

end
