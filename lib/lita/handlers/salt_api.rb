module Lita
  module Handlers
    class SaltApi < Handler
    config :url
    config :user
    config :pass	
    
    route /^s(?:alt)it ping$/i, :test_ping, command: true, help: {
      'saltit ping on server' => 'lists alive minions'}
    route /^s(?:alt)it restart$/i, :service_restart, command: true, help: {
      'saltit restart on server' => 'restarts services'}

    def test_ping(response)
    	server = response.matches[0][1]
    	response.reply "Add Ping Test"
    end

    def service_restart(response)
    	server = response.matches[0][1]
    	response.reply "Add service.restart"
    end	

#final end block
    end

    Lita.register_handler(SaltApi)
  end
end
