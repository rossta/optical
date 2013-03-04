# encoding: utf-8
$LOAD_PATH.unshift 'lib'
require 'optical'

use Rack::ShowExceptions

map '/assets' do
  run OptiCal::App.sprockets
end

run OptiCal::App
