module Purview
  module Pullers
    class MSSQL < BaseSQL
      def modern_version?
        opts[:modern_version] || false
      end

      private

      def connection_type
        Purview::Connections::MSSQL
      end

      def dialect_type
        Purview::Dialects::MSSQL
      end

      def row_limit_sql(page_number, page_size)
        if modern_version?
          super(page_number, page_size)
        end
      end

      def row_number_sql(page_number, page_size)
        if modern_version?
          super(page_number, page_size)
        else
          "ROW_NUMBER() OVER(ORDER BY #{table.id_column.source_name})"
        end
      end
    end
  end
end
