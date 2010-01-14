# This example allows requests for example.com and another-example.com.
# If any other domain is requested it redirects to the first domain on the
# list - example.com preserving path and query string from the first request.
require "rack/domain_redirect"

# This is how you use and configure Rack::DomainRedirect middleware
use Rack::DomainRedirect, ['example.com', 'localhost']

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello world!']] }
