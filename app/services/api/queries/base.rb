module Api
  module Queries
    class Base
      DEFAULT_PAGE = 1
      DEFAULT_LIMIT = 10

      attr_reader :params, :scope, :page, :limit

      def initialize(params)
        @params = params
        @page = params[:page] ? params[:page].to_i : DEFAULT_PAGE
        @limit = params[:limit] ? params[:limit].to_i : DEFAULT_LIMIT
        @scope = default_scope
      end

      def default_scope
        raise NotImplementedError
      end

      def call
        raise NotImplementedError
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
    end
  end
end