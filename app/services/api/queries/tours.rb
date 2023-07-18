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

      def sort_records
        @scope = scope.order(order_clause)
      end

      def difficulty_levels_filter
        difficulty_levels = filters[:difficulty]&.split(',')
        { difficulty: difficulty_levels } if difficulty_levels.present?
      end

      def order_clause
        return 'id DESC' if sort.blank?

        sort_attributes = sort.split(',').map do |field|
          if field[0] == '-'
            "#{field[1..]} DESC"
          else
            "#{field} ASC"
          end
        end

        sort_attributes.join(',')
      end
    end
  end
end
