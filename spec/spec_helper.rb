Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require file }

RSpec.configure do |config|
  config.order = 'random'
end
