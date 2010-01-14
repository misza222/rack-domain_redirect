require 'rubygems'
require 'rack/test'
require 'rack/mock'
require 'shoulda'
require 'rack/domain_redirect'

class TestDomainRedirect < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    testing_app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [@body]] }
    Rack::DomainRedirect.new(testing_app, @allowed_hosts)
  end
  
  def build_query_string(hash_query)
    hash_query.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
  end
  
  context "DomainRedirect middleware" do
    setup do
      @body = 'Hello world!'
      @allowed_hosts     = ['example1.com','example2.com']
      @not_allowed_hosts = ['disallowed.com']
    end
    
    should "not redirect if host within allowed_hosts" do
      get "", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @allowed_hosts[0])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body
      
      get "", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @allowed_hosts[1])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body 
    end
    
    should "redirect to the first host from the allowed_hosts list" do
      
      query_hash = {'query' => 'string', 'another' => 'one'}
      path = "path/on/the/server?" << build_query_string(query_hash)
      
      get "", {}, Rack::MockRequest.env_for("/" << path, "SERVER_NAME" => @not_allowed_hosts[0])
      follow_redirect!
      
      assert_equal @allowed_hosts[0], last_request.host
      assert_equal "/path/on/the/server", last_request.path
      assert_equal build_query_string(query_hash), last_request.query_string
      assert last_response.ok?
    end
    
    should "degrade if not configured (allowed hosts is nil)" do
      @allowed_hosts = nil
      
      get "", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @not_allowed_hosts[0])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body 
    end
    
    should "degrade if not configured (allowed hosts is an empty array)" do
      @allowed_hosts = []
      
      get "", {}, Rack::MockRequest.env_for("/", "SERVER_NAME" => @not_allowed_hosts[0])
      
      assert ! last_response.redirect?
      assert last_response.ok?
      assert_equal @body, last_response.body 
    end
  end
end
