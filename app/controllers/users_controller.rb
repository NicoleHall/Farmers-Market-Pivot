class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      if @user.vendor?
        redirect_to vendor_dashboard_path
      else
        redirect_to dashboard_path
      end
    else
      render :new
    end
  end

  def show
    if current_user
      @user = User.find_by_slug(params[:slug])
    else
      render file: "public/404"
    end
  end

  def edit
    render file: "public/404" unless user_slug_is_current_user
  end

  def update
    if @user.update_attributes(user_params)
      if @user.platform_admin?
        redirect_to platform_admin_dashboard_path
      elsif @user.vendor?
        redirect_to vendor_dashboard_path
      else
        redirect_to dashboard_path
      end
    else
      flash.now[:error] = "Incorrect user information. Please upload an image to change item status."
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :username,
                                 :password,
                                 :password_confirmation,
                                 :email_address,
                                 :street_address,
                                 :city,
                                 :state,
                                 :zipcode,
                                 :role,
                                 :slug,
                                 :file_upload)
  end

  def user_slug_is_current_user
    current_user.slug == params[:slug]
  end
end
