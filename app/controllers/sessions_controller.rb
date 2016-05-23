class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
    redirect_to "/auth/google_oauth2"
  end

  def create
    # debugger
    user = User.find_by(provider: auth_hash[:provider], uid: auth_hash[:uid])

    if user
      user.update_info_from_auth_hash(auth_hash)
    else
      user = create_user_from_auth_hash(auth_hash)
    end

    if user.persisted?
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully"
    else
      flash[:error] = "Could not authenticate or create your account."
    end

    redirect_to_back_or_default
  end

  def destroy
    reset_session
    flash[:notice] = "Logged out successfully"
    redirect_to root_path
  end


  def login
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def create_user_from_auth_hash(auth_hash)
    User.create(
      email: auth_hash["info"][:email],
      name: auth_hash["info"][:name] ,
      uid: auth_hash["uid"],
      provider: auth_hash[:provider],
      profile_pic: auth_hash["info"][:image],
      token: auth_hash["credentials"][:token]
    )
  end
end
