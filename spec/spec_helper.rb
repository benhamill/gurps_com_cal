require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/tmp/'

  add_group 'teh libz', '/lib/'
end

require 'gurps_com_cal'

SPEC_WORKING_DIR = File.join(File.expand_path('..', __FILE__), 'work')
SPEC_RESOURCES_DIR = File.join(File.expand_path('..', __FILE__), 'resources')

RSpec.configure do |config|
  config.before(:suite) do
    Dir.mkdir(SPEC_WORKING_DIR) unless Dir.exists?(SPEC_WORKING_DIR)
  end

  config.after(:suite) do
    Dir.new(SPEC_WORKING_DIR).each do |file|
      next if file == '.' or file == '..'
      File.delete("#{SPEC_WORKING_DIR}/#{file}")
    end

    Dir.delete(SPEC_WORKING_DIR)
  end
end
