module Lita
  module Handlers
    class SaltApi < Handler
    require 'curb'
    config :url
    config :user
    config :pass	
    
    route(/^saltit ping on\s+(.+)/, :test_ping, command: true, help: {
      "saltit ping on server" => "lists alive minions"})
    route(/^saltit restart\s+(.+)/, :service_restart, command: true, help: {
      "saltit restart on server" => "restarts services"})
    route(/^saltops stop\s+(.+)/, :service_stop, command: true, help: {
      "saltops stop on server" => "stops a service on a server"})
    route(/^saltops start\s+(.+)/, :service_start, command: true, help: {
      "saltops start on server" => "starts service on a server"})
    route(/^saltops highstate\s+(.+)/, :highstate, command: true, help: {
      "saltops highstate on server" => "runs a state.highstate on server"})
    
    def test_ping(response)
        server = response.matches[0][0]
        payload = '{\'client\':\'local\',
                    \'tgt\':server,
                    \'fun\':\'test.ping\'}'
        uri = config.url
        c = Curl::Easy.new
        c.http_auth_types = :pam
        c.ssl_verify_peer = false
        c.username = config.user
        c.password = config.pass
        c.http_post(uri, payload) do |curl| 
          curl.headers["Content-Type"] = ["application/json"]
        end
    	response.reply(c.body_str)
        #responce.reply(user)
    end

    def service_restart(response)
    	server = response.matches[0][1]
    	response.reply "True"
    end	
    
    def service_start(response)
    	server = response.matches[0][1]
    	response.reply "True"
    end	

    def service_stop(response)
    	server = response.matches[0][1]
    	response.reply "True"
    end	

    def highstate(response)
    	server = response.matches[0][1]
    	response.reply "den2iws01:
        Summary
        -----------
        Succeeded: 0
        Failed:   0
        -----------
        Total:    0"
    end	

#final end block
    end

    Lita.register_handler(SaltApi)
  end
end

