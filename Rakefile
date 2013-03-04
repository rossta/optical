$LOAD_PATH.unshift 'lib'
require 'optical'
require 'rake/sprocketstask' # <-- important
require 'logger'

namespace :assets do
  Rake::SprocketsTask.new(:precompile) do |t|
    t.environment = OptiCal::App.sprockets
    t.output      = "#{File.dirname(__FILE__)}/public/assets"

    # include sprocket manifests (main application files with 'require's)
    t.assets = %w{ application.js
                   application.css }
    # include anything in `/assets` that is not a manifest (images)
    t.assets << lambda do |path, filename|
      filename =~ /\/assets/ && !%w(.js .css).include?(File.extname(path))
    end

    # setting debug is good for CI logs
    t.logger = Logger.new($stdout)
    t.logger.level = Logger::DEBUG
  end
end
