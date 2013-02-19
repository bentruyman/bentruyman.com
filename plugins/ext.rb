require 'zurb-foundation'
require 'animation'
require "jekyll-assets"
require "jekyll-assets/compass"

# override jekyll-assets plugin to add defer/async attributes
module Jekyll
  module AssetsPlugin
    class Renderer
      JAVASCRIPT = '<script type="text/javascript" src="%s" defer async></script>'
    end
  end
end
