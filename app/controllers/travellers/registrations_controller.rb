# frozen_string_literal: true

module Travellers
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    before_action :ensure_password_confirmation_exists, only: [:create]

    FIELDS_SKIP_PASSWORD_VERIFICATION = %i[first_name last_name avatar].freeze

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      super
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    def update
      if needs_password_verification?(account_update_params)
        super
      else
        # remove the virtual current_password attribute
        # update_without_password doesn't know how to ignore it
        params[resource_name.to_sym].delete(:current_password)
        resource.update_without_password(account_update_params)
      end
    end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name avatar])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name avatar])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    def ensure_password_confirmation_exists
      return if params[:traveller].present? && params[:traveller][:password_confirmation].present?

      render json: { error: 'Please confirm your password with `password_confirmation` field' }, status: :bad_request
    end

  private

    def needs_password_verification?(fields)
      fields.keys.any? { |field| FIELDS_SKIP_PASSWORD_VERIFICATION.exclude?(field.to_sym) }
    end
  end
end
