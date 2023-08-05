module CurrentTravellerDetails
  extend ActiveSupport::Concern

  included do
    helper_method :traveller_name
  end

  def traveller_name
    @traveller_name ||= current_traveller&.email || 'Guest'
  end
end