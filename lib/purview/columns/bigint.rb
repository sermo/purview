module Purview
  module Columns
    class Bigint < Base
      private

      def default_opts
        super.merge(:type => Purview::Types::Bigint)
      end
    end
  end
end
