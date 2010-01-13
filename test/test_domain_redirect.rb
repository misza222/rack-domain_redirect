require 'rubygems'
require 'rack/mock'
require 'shoulda'
require File.join(File.dirname(__FILE__), '..', 'lib', 'domain_redirect')

class TestDomainRedirect < Test::Unit::TestCase
  
  def domain_redirect_app(allowed_hosts)
  end
  
  context "Rack middleware should" do
    setup do
      @allowed_hosts = ['example1.com','example1.com']
    end
    
    should "not redirect if host within allowed_hosts" do
      app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ["Hello, World!"]] }
      res = Rack::DomainRedirect.new(app,@allowed_hosts).call()
      
      res.should.be.ok
      res.body.should.equal 'Hello, World'
    end
  end
end
