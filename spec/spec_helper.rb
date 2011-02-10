require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/tmp/'

  add_group 'teh libz', '/lib/'
end

require 'gurps_com_cal'
