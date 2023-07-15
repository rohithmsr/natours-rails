module Api
  module Queries
    class Base
      DEFAULT_PAGE = 1
      DEFAULT_LIMIT = 10

      attr_reader :params, :scope, :page, :limit, :filters

      def initialize(params)
        @params = params
        @page = params[:page] ? params[:page].to_i : DEFAULT_PAGE
        @limit = params[:limit] ? params[:limit].to_i : DEFAULT_LIMIT
        @filters = params[:filters] || {}
        @scope = default_scope
      end

      def default_scope
        raise NotImplementedError
      end

      def call
        filter_records
      end

      def all_records
        # Can be used for cases where you return only a certain fields to the user
        @scope
      end

      def records
        paginate(@scope)
      end

      def count
        @scope.count
      end

      private

        def paginate(records)
          records.offset((page - 1) * limit).limit(limit)
        end

        def filter_records
          raise NotImplementedError
        end
    end
  end
end