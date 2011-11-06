class CommandHandler < EventMachine::Connection
	include EventMachine::Protocols::LineText2
	attr_accessor :server
	
	def initialize
	end
	def receive_line data
		@server.log.info "Console >> "+data
		args = data.split
		command = args[0]
		args.delete_at(0)
		#Built in functions
		if command == "stop"
			@server.stop
		elsif command == "help"
			help_contents = [
				"RubyCraft Help:",
				"help - This dialog",
				"stop - Stop server",
					]
			help_contents.each do |help|
				@server.log.info help
			end
		else
			@server.log.info "ERR: Unknown Command"
		end
		#TODO: Plugin Hook.
	end
end

