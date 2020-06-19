class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?




	protected
		def after_sign_in_path_for(resource)
    	case resource
   		when Admin
      	manager_top_path
    	when Member
      	root_path
    	end
  	end

  	def after_sign_out_path_for(resource)
    	case resource
    	when :manager_admin
      	new_manager_admin_session_path
    	when :public_member
      	root_path
    	end
  	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:nick_name, :name, :kana_name, :email, :status])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nick_name, :name, :kana_name, :email, :status])
    # デバイスに追加したカラムを許可する記述
	end
end
