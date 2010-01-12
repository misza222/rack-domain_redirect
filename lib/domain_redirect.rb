module Rack
  
  # 
  #
  class DomainRedirect
    
    def initialize(app, hosts = [])
      @app = app
      @hosts = hosts
      @hosts[0] = 'www.google.com' if @hosts.empty?
    end
    
    def call(env)
      req = Rack::Request.new(env)
      
      if @hosts.include?(req.host)
        @app.call(env)
      else
        url = "http://#{@hosts[0]}"
        url << ":#{req.port}" unless req.port == 80
        url << "#{req.path}"
        url << "?#{req.query_string}" unless req.query_string.empty?
        res = Rack::Response.new
        res.redirect(url)
        res.finish
      end
    end
  end
end
