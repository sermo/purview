module Purview
  module Mixins
    module Connection
      def connect
        connection_type.connect(connection_opts)
      end

      def connection_opts
        {
          :database => database_name,
          :host => database_host,
          :logger => logger_opts,
          :password => database_password,
          :port => database_port,
          :username => database_username,
          :timeout => timeout
        }
      end

      def with_new_connection
        yield connection = connect
      ensure
        connection.disconnect if connection
      end

      def with_new_or_existing_connection(opts={})
        if existing_connection = opts[:connection]
          yield existing_connection
        else
          with_new_connection { |connection| yield connection }
        end
      end

      def with_transaction(connection)
        connection.with_transaction { yield }
      end
    end
  end
end
