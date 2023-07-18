module Api
  module Queries
    class Base
      DEFAULT_PAGE = 1
      DEFAULT_LIMIT = 10

      attr_reader :params, :scope, :page, :limit, :filters, :fields, :sort

      def initialize(params)
        @params = params
        @page = params[:page] ? params[:page].to_i : DEFAULT_PAGE
        @limit = params[:limit] ? params[:limit].to_i : DEFAULT_LIMIT
        @filters = params[:filters] || {}
        @fields = params[:fields]
        @sort = params[:sort]
        @scope = default_scope
      end

      def default_scope
        raise NotImplementedError
      end

      def call
        filter_records
        sort_records
      end

      def all_records
        # Can be used for cases where you return only a certain fields to the user
        @scope
      end

      def records
        rows = paginate(@scope)
        project(rows)
      end

      def count
        @scope.count
      end

      private

      def paginate(records)
        records.offset((page - 1) * limit).limit(limit)
      end

      def project(records)
        return records if fields.blank?

        field_names = fields.split(',')
        filtered_fields = field_names.intersection(records.attribute_names)

        records.select(filtered_fields)
      end

      def filter_records
        raise NotImplementedError
      end

      def sort_records
        scope
      end
    end
  end
end
