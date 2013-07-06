require 'json'
require 'active_support/inflector'
require 'faraday'
require 'redstack/version'
require 'redstack/errors'

['base', 'identity'].each do |m|
  Dir[Pathname.new(__FILE__).join('..', 'redstack', m, '**', '*.rb')].each do |f|
    require f
  end
end
