class RegistrationsController < Devise::RegistrationsController
  # override redirection after signing in
  protected
    def after_update_path_for(user)
      user_path(user)
    end

    def after_sign_in_path_for(user)
      user_path(user)
    end
end