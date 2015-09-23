require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib/my_app.rb')
use Rack::Static, urls: ['/css', '/js', '/img', '/fonts'], root: 'assets'

run MyApp