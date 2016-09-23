require "life_guard/version"

module LifeGuard
  class Rack
    def initialize(app, opts={})
      @app = app
      @options = opts
      @header_key = @options[:header]
      @lambda = @options[:transformation]
      @failure_message = @options[:failure_message]
      @activepoolset = {}
      @config = ActiveRecord::Base.configurations.deep_dup
    end

    def call(env)
      begin
        switch_connection(env[@header_key]) if !env[@header_key].blank?
      rescue 
        return [404, {'Content-Type' => 'text/html'}, ["#{@failure_message}"]]
      else
        return @app.call(env)
      ensure
        change_connection(@config) if env[@header_key]
      end
    end
private
    def switch_connection(header)
      modified_config = @config.deep_dup
      @lambda.call(modified_config[Rails.env], header)
      change_connection(modified_config)
    end

    def change_connection(destination_config)
      ActiveRecord::Base.clear_active_connections!
      ActiveRecord::Base.configurations = destination_config
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.active?
    end
  end
end