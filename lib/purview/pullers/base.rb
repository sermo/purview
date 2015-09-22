module Purview
  module Pullers
    class Base
      def initialize(opts={})
        @opts = opts
      end

      def earliest_timestamp
        raise %{All "#{Base}(s)" must override the "earliest_timestamp" method}
      end

      def pull(window, page_number, page_size)
        raise %{All "#{Base}(s)" must override the "pull" method}
      end

      private

      include Purview::Mixins::Logger

      attr_reader :opts

      def table
        opts[:table]
      end

      def timeout
        opts[:timeout]
      end
    end
  end
end
