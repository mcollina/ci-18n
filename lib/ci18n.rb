# Configure Rails 3.1 to precompile the included javascripts
module Ci18n
  module Rails
    class Engine < ::Rails::Engine

      initializer "Ci18n.precompile_js_assets" do |app|
        app.config.assets.precompile << "ci-18n.js"
        Dir[::Rails.root.join("app", "assets", "javascripts", "locales", "*")].each do |locale|
          locale = locale.gsub(/\.coffee/, '') # this should no be needed?
          app.config.assets.precompile << File.join("locales", File.basename(locale))
        end
      end

    end
  end
end

