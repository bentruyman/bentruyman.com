# Created by Nick Markwell, based on code by Philip Durbin from:
# http://stackoverflow.com/questions/8490528/how-can-i-make-jekyll-use-a-layout-without-specifying-it
#
# Modified by Ben Truyman to fix incompatibilities with the new "layouts"
# configuration option.
#
#
# This provides the ability to specify the following in _config.yml:
#    layouts:
#      default: DEFAULT_LAYOUT_NAME     # everything that doesn't have another default specified
#      _posts: DEFAULT_POST_LAYOUT_NAME # all posts
#      magic: DEFAULT_MAGICAL_LAYOUT    # everything in magic/
#
# To use the plugin, just drop this file in _plugins.
#
# Repository: https://github.com/duckinator/jekyll-default-layout
#

module Jekyll
  module Convertible
    # TODO: Find where this is already stored so it's less hacktastic
    def __get_config_yml
      @__config  ||= YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '_config.yml')))
      @__layouts ||= @__config['default_layouts']
    end
    
    def read_yaml(base, name)
      __get_config_yml
      dir = base.split('/')[-1] # TODO: Remove hackiness :(
      
      
      self.content = File.read(File.join(base, name))
      
      if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        self.content = $POSTMATCH
        
        begin
          self.data = YAML.load($1)
          
          if @__layouts.keys.include?(dir)
            self.data['layout'] ||= @__layouts[dir]
          elsif @__layouts.keys.include?('default')
            self.data['layout'] ||= @__layouts['default']
          end
        rescue => e
          puts "YAML Exception reading #{name}: #{e.message}"
        end
      end
      
      self.data ||= {}
    end
  end
end
