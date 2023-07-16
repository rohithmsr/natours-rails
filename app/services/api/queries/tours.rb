module Api
  module Queries
    class Tours < Base
      private

      attr_reader :scope

      def default_scope
        Tour.all
      end

      def filter_records
        @scope = scope.where(difficulty_levels_filter)
      end

      def difficulty_levels_filter
        difficulty_levels = filters.dig(:difficulty)&.split(',')
        { difficulty: difficulty_levels } if difficulty_levels.present?
      end
    end
  end
end
