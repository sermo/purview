module Purview
  module Loaders
    class MySQL < Base
      private

      def dialect_type
        Purview::Dialects::MySQL
      end

      def id_in_sql(temporary_table_name)
        'SELECT %s FROM %s' % [
          table.id_column.name,
          temporary_table_name,
        ]
      end

      def in_window_sql(window)
        if window.nil?
          '%s IS NULL' % table.updated_timestamp_column.name
        else
          '%s BETWEEN %s AND %s' % [
            table.updated_timestamp_column.name,
            quoted(window.min),
            quoted(window.max),
          ]
        end
      end

      def not_in_window_sql(window)
        if window.nil?
          '%s IS NOT NULL' % table.updated_timestamp_column.name
        else
          '%s NOT BETWEEN %s AND %s' % [
            table.updated_timestamp_column.name,
            quoted(window.min),
            quoted(window.max),
          ]
        end
      end

      def table_delete_sql(window, temporary_table_name)
        'DELETE FROM %s WHERE %s AND %s NOT IN (%s)' % [
          table.name,
          in_window_sql(window),
          table.id_column.name,
          id_in_sql(temporary_table_name),
        ]
      end

      def table_insert_sql(window, temporary_table_name)
        'INSERT INTO %s (%s) SELECT %s FROM %s t1 WHERE NOT EXISTS (SELECT 1 FROM %s t2 WHERE t1.%s = t2.%s)' % [
          table.name,
          table.column_names.join(', '),
          table.column_names.join(', '),
          temporary_table_name,
          table.name,
          table.id_column.name,
          table.id_column.name,
        ]
      end

      def table_update_sql(window, temporary_table_name)
        'UPDATE %s t1 JOIN %s t2 ON t1.%s = t2.%s SET %s' % [
          table.name,
          temporary_table_name,
          table.id_column.name,
          table.id_column.name,
          table.column_names.map { |column_name| "t1.#{column_name} = t2.#{column_name}" }.join(', '),
        ]
      end

      def temporary_table_insert_sql(temporary_table_name, rows)
        'INSERT INTO %s (%s) VALUES %s' % [
          temporary_table_name,
          table.column_names.join(', '),
          rows.map { |row| "(#{row_values(row)})" }.join(', ')
        ]
      end

      def temporary_table_opts
        super.merge(:create_indices => false)
      end

      def temporary_table_verify_sql(temporary_table_name, window)
        'SELECT COUNT(1) %s FROM %s WHERE %s' % [
          count_column_name,
          temporary_table_name,
          not_in_window_sql(window),
        ]
      end
    end
  end
end
