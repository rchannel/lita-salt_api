module Lita
  module Handlers
    class SaltApi < Handler
    require 'httparty'
    config :url
    config :user
    config :pass	
    
    
    route(/^saltit ping on\s+(.+)/, :test_ping, command: true, help: {
      "saltit ping on server" => "lists alive minions"})
    route(/^saltit restart (.*) on (.*)$/i, :service_restart, command: true, help: {
      "saltit restart on server" => "saltit restart servicename on servername"})
    route(/^saltops stop (.*) on (.*)$/i, :service_stop, command: true, restrict_to: [:ops], help: {
      "saltops stop on server" => "saltops stop servicename on servername"})
    route(/^saltops start (.*) on (.*)$/i, :service_start, command: true, restrict_to: [:ops], help: {
      "saltops start on server" => "saltops start servicename on servername"})
    route(/^saltops highstate on\s+(.+)/, :highstate, command: true, restrict_to: [:ops], help: {
      "saltops highstate on server" => "runs a state.highstate on server"})
    #route(/^saltit cmd (.*) on (.*)$/i, :service_start, command: true, help: {
    #  "saltops cmd.run on server" => "will run a cmd on a server"})

    def test_ping(response)
        server = response.matches[0][0]
        url = config.url
        username = config.user
        password = config.pass
        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => "#{username}", :password => "#{password}", :eauth => "pam",
                                :client => "local", :tgt => "#{server}", :fun => "test.ping", 
                                :debug_output => $stdout, header: "Accept: application/x-yaml"})
        stat = awesome.body
        if stat == "{\"return\": [{}]}"
            response.reply("Server not found: #{server}")
        else 
            response.reply(stat)
        end
    end

    def service_restart(response)
    	server = response.matches[0][1]
        service = response.matches[0][0]
    	url = config.url
        username = config.user
        password = config.pass

        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => "#{username}", :password => "#{password}", :eauth => "pam",
                                :client => "local", :tgt => "#{server}", :fun => "service.restart", :arg => "#{service}",
                                :debug_output => $stdout, header: "Accept: application/x-yaml"})
        stat = awesome.body
        if stat == "{\"return\": [{}]}"
            response.reply("Server not found: #{server}")
        else 
            response.reply(stat)
        end
    end	
    
    def service_start(response)
    	server = response.matches[0][1]
        service = response.matches[0][0]
        url = config.url
        username = config.user
        password = config.pass
        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => "#{username}", :password => "#{password}", :eauth => "pam",
                                    :client => "local", :tgt => "#{server}", :fun => "service.start", :arg => "#{service}", 
                                    :debug_output => $stdout, header: "Accept: application/x-yaml"})
        stat = awesome.body
        if stat == "{\"return\": [{}]}"
            response.reply("Server not found: #{server}")
        else 
            response.reply(stat)
        end
    end	

    def service_stop(response)
    	server = response.matches[0][1]
        service = response.matches[0][0]
        url = config.url
        username = config.user
        password = config.pass
        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => "#{username}", :password => "#{password}", :eauth => "pam",
                                    :client => "local", :tgt => "#{server}", :fun => "service.stop", :arg => "#{service}",
                                    :debug_output => $stdout, header: "Accept: application/x-yaml"})
        stat = awesome.body
        if stat == "{\"return\": [{}]}"
            response.reply("Server not found: #{server}")
        else 
            response.reply(stat)
        end
    end	

    def highstate(response)
    	server = response.matches[0][0]
        url = config.url
        username = config.user
        password = config.pass
        awesome = HTTParty.post("#{url}/run", :verify => false, :body => {:username => "#{username}", :password => "#{password}", :eauth => "pam",
                                    :client => "local", :tgt => "#{server}", :fun => "state.highstate", 
                                    :debug_output => $stdout, header: "Accept: application/x-yaml"})
        stat = awesome.body
        response.reply(stat)
    end	

#final end block
    end

    Lita.register_handler(SaltApi)
  end
end

