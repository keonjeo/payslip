class Admins::SessionsController < Devise::SessionsController

  # layout false, :only => [:new, :create]
  layout 'layouts/login', :only => :new

  skip_before_action :authenticate_admin!, :only => :new
  skip_before_filter :verify_authenticity_token, :only => :create

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # GET /admin/sign_in
  # def new
  #   self.resource = resource_class.new(sign_in_params)
  #   clean_up_passwords(resource)
  #   yield resource if block_given?
  #   respond_with(resource, serialize_options(resource))
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  protected

  # 重写Devise父类方法, 去掉 already_authenticated 这句信息
  # def require_no_authentication
  #   assert_is_devise_resource!
  #   return unless is_navigational_format?
  #   no_input = devise_mapping.no_input_strategies
  #
  #   authenticated = if no_input.present?
  #                     args = no_input.dup.push scope: resource_name
  #                     warden.authenticate?(*args)
  #                   else
  #                     warden.authenticated?(resource_name)
  #                   end
  #
  #   if authenticated && resource = warden.user(resource_name)
  #     redirect_to after_sign_in_path_for(resource)
  #   end
  # end

  def after_sign_in_path_for(resource)
    employees_path
  end


end
