module Purview
  module Databases
    class PostgreSQL < Base
      private

      def connection_opts
        { :dbname => name }
      end

      def connection_type
        Purview::Connections::PostgreSQL
      end

      def database_type_map
        {
          Purview::Columns::Boolean => 'boolean',
          Purview::Columns::Date => 'date',
          Purview::Columns::Float => 'numeric',
          Purview::Columns::Integer => 'integer',
          Purview::Columns::Money => 'money',
          Purview::Columns::String => 'varchar',
          Purview::Columns::Text => 'text',
          Purview::Columns::Time => 'time',
          Purview::Columns::Timestamp => 'timestamp',
          Purview::Columns::UUID => 'uuid',
        }
      end
    end
  end
end
