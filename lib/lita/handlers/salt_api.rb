module Lita
  module Handlers
    class SaltApi < Handler
    require 'curb'
    require 'httparty'
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
        url = config.url
        username = config.user
        password = config.pass
        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => #{username}, :password => #{password}, :eauth => "pam",
                                :client => "local", :tgt => "#{server}", :fun => "test.ping"},
                                :debug_output => $stdout, :headers => {"Accept" => "application/x-yaml"})
        puts awesome.inspect
        stat = awesome.message
        response.reply(stat)
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

