module Purview
  module Pullers
    class BaseSQL < Base
      def pull(window, page_number, page_size)
        with_new_connection do |connection|
          connection.execute(pull_sql(window, page_number, page_size))
        end
      end

      def earliest_timestamp
        with_new_connection do |connection|
          result = connection.execute('SELECT MIN(%s) earliest_timestamp FROM %s' %
            [table.updated_timestamp_column.source_name, table_name])
          result.rows.first.earliest_timestamp
        end
      end

      private

      include Purview::Mixins::Connection
      include Purview::Mixins::Dialect
      include Purview::Mixins::Helpers
      include Purview::Mixins::Logger

      def additional_sql
        " #{opts[:additional_sql]}".rstrip
      end

      def column_names
        table.columns.map do |column|
          name = column.name
          source_name = column.source_name
          source_name == name ? name : "#{source_name} AS #{name}"
        end
      end

      def connection_type
        raise %{All "#{BaseSQL}(s)" must override the "connection_type" method}
      end

      def database_host
        opts[:database_host]
      end

      def database_name
        opts[:database_name]
      end

      def database_password
        opts[:database_password]
      end

      def database_port
        opts[:database_port]
      end

      def database_username
        opts[:database_username]
      end

      def dialect_type
        raise %{All "#{BaseSQL}(s)" must override the "dialect_type" method}
      end

      def is_function?
        opts[:is_function] || false
      end

      def pull_sql(window, page_number, page_size)
        start_row = ((page_number - 1) * page_size) + 1
        end_row = start_row + page_size - 1
        if is_function?
          <<-SQL
            SELECT #{column_names.join(', ')}
            FROM #{table_name}
              (
                #{window.nil? ? 'NULL' : quoted(window.min)},
                #{window.nil? ? 'NULL' : quoted(window.max)},
                #{page_number},
                #{page_size}
              )
          SQL
        else
          <<-SQL
            SELECT #{column_names.join(', ')}
            FROM (
              SELECT *, #{row_number_sql(page_number, page_size)} row_num
              FROM #{table_name}
              WHERE
                #{in_window_sql(window)}
                #{additional_sql}
                #{row_limit_sql(page_number, page_size)}
            ) a
            WHERE row_num BETWEEN #{start_row} AND #{end_row}
          SQL
        end
      end

      def row_limit_sql(page_number, page_size)
        <<-SQL
          ORDER BY #{table.id_column.source_name}
          LIMIT #{page_size}
          OFFSET #{(page_number - 1) * page_size}
        SQL
      end

      def row_number_sql(page_number, page_size)
        page_number * page_size
      end

      def table_name
        opts[:table_name]
      end

      def in_window_sql(window)
        if window.nil?
          '%s IS NULL' % table.updated_timestamp_column.source_name
        else
          '%s BETWEEN %s AND %s' % [
            table.updated_timestamp_column.source_name,
            quoted(window.min),
            quoted(window.max)
          ]
        end
      end
    end
  end
end
