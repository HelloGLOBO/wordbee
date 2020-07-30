class MethodContext
	attr_reader :context
	attr_reader :auth_token
	alias_method :client, :context

	def initialize(context)
		@context = context
		@auth_token = @context.auth_token
	end

end