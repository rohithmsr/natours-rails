module Api
  module Queries
    class Tours < Base
      attr_reader :scope

      def default_scope
        Tour.all
      end

      def filter_records
        @scope = scope.where(difficulty_levels_filter)
                      .where(discounts_filter)
                      .where(range_filter(:price))
      end

      def sort_records
        @scope = scope.order(order_clause)
      end

      def difficulty_levels_filter
        difficulty_levels = filters[:difficulty]&.split(',')
        { difficulty: difficulty_levels } if difficulty_levels.present?
      end

      def discounts_filter
        discounts = filters[:price_discount]&.split(',')
        { price_discount: discounts } if discounts.present?
      end

      def order_clause
        return 'id DESC' if sort.blank?

        sort_attributes = sort.split(',').filter_map do |field|
          if field[0] == '-'
            field = field[1..]

            "#{field} DESC" if Tour.attribute_names.include?(field)
          elsif Tour.attribute_names.include?(field)
            "#{field} ASC"
          end
        end

        sort_attributes.join(',')
      end
    end
  end
end
