$LOAD_PATH.unshift 'lib'
require 'optical'

guard 'livereload' do
  watch(%r{^assets/.+$})  # in favor of this
  watch(%r{^views/.+$})
  watch(%r{^lib/.+$})
end

guard 'livereload' do
  watch(%r{lib/.+\.rb})
  watch(%r{views/.+\.(erb)})
  watch(%r{public/.+\.(css|js|html)})
end
