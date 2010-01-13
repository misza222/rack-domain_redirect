require 'rubygems'
require 'rack/test'
require 'rack/mock'
require 'shoulda'
#require File.join(File.dirname(__FILE__), '..', 'lib', 'rack', 'domain_redirect')
require 'rack/domain_redirect'

class TestDomainRedirect < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    testing_app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [@body]] }
    Rack::DomainRedirect.new(testing_app, @allowed_hosts)
  end
  
  context "DomainRedirect middleware" do
    setup do
      @body = 'Hello, World!'
      @allowed_hosts     = ['example1.com','example2.com']
      @not_allowed_hosts = ['disallowed.com']
    end
    
    should "not redirect if host within allowed_hosts" do
      get "/", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @allowed_hosts[0])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body
      
      get "/", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @allowed_hosts[1])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body 
    end
    
    should "redirect to the first host from the allowed_hosts list" do
      get "/", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @not_allowed_hosts[0])
      follow_redirect!
      
      assert_equal "http://#{@allowed_hosts[0]}/", last_request.url
      assert last_response.ok?
    end
  end
end
