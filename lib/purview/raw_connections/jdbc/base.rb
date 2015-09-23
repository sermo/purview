module Purview
  module RawConnections
    module JDBC
      class Base < Purview::RawConnections::Base
        private

        attr_reader :last_sql, :last_statement

        def delete_or_insert_or_update?(sql)
          delete?(sql) || insert?(sql) || update?(sql)
        end

        def execute_sql(sql, opts={})
          @last_sql = sql
          @last_statement = statement = raw_connection.createStatement
          if select?(sql)
            statement.executeQuery(sql)
          elsif delete_or_insert_or_update?(sql)
            statement.executeUpdate(sql)
            nil
          else
            statement.execute(sql)
            nil
          end
        end

        def extract_rows(result)
          if result
            metadata = result.getMetaData
            column_count = metadata.getColumnCount
            [].tap do |rows|
              while result.next
                rows << {}.tap do |row|
                  (1..column_count).each do |index|
                    column_name = metadata.getColumnName(index)
                    row[column_name] = result.getString(column_name)
                  end
                end
              end
            end
          end
        end

        def extract_rows_affected(result)
          delete_or_insert_or_update?(last_sql) ? last_statement.getUpdateCount : 0
        end

        def new_connection
          conn_properties = java.util.Properties.new
          conn_properties.setProperty('user', username)
          conn_properties.setProperty('password', password)
          if timeout.present?
            conn_properties.setProperty('timeout', timeout)
          end

          java.sql.DriverManager.getConnection(url, conn_properties)
        end

        def url
          raise %{All "#{Base}(s)" must override the "url" method}
        end
      end
    end
  end
end
