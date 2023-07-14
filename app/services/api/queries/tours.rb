module Api
  module Queries
    class Tours < Base
      private

        attr_reader :scope

        def default_scope
          Tour.all
        end
    end
  end
end