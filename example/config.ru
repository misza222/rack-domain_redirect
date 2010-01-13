require "rack/domain_redirect"

use Rack::DomainRedirect, ['misza-desktop', 'localhost']

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello world!']] }
