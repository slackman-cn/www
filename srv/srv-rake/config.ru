require 'rubygems'
require 'bundler'

Bundler.require

$: << '.'
$: << 'lib/'

require './app'

run Sinatra::Application 