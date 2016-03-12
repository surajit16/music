class UsersController < ApplicationController
  before_filter :login_required, :except=>[:login, :new, :create, :forgot_password, :verify, :reset_password]

  def login
    @user=User.new
    if request.post?
      @user = User.find_by_email_and_is_deleted_and_verified(params[:user][:email], false, true)
      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to musics_path, :notice => "Logged in!"
      else
        @user=User.new unless @user.present?
        @user.errors.add(:password, "Invalid email or password")
        render "login"
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_users_path, :notice => "Logged out!"
  end

  def index

  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    @user.is_deleted=false
    token= "#{Time.now.to_i}#{Random.rand(9999)}"
    @user.token=token
    if @user.save
      begin
        url="#{request.protocol}#{request.host_with_port}/users/verify?token=#{@user.token}&email=#{@user.email}"
        UserMailer.welcome_email(@user, url).deliver
      rescue => ex
      end
      redirect_to login_users_path, :notice => "Registered successfully!"
    else
      render 'new'
    end
  end
  
  def show
    @user=User.find params[:id]
  end

  def edit
    @user=User.find params[:id]
  end

  def change_password
    @user=User.find params[:id]
    if request.put?
      if params[:user] and params[:user][:password] and params[:user][:password_confirmation] and (params[:user][:password]==params[:user][:password_confirmation])
        if params[:user][:password].length>3
          if @user.update_attributes(:password=>params[:user][:password_confirmation])
            render 'close', :notice => "Password updated successfully!"
          else
            @user.errors.add(:password, "Something went wrong. Try again!")
            #flash[:alert] = @user.errors.full_messages.join(' and ').html_safe
          end
        else
          @user.errors.add(:password,"Password is too short (minimum is 4 characters)!")
        end
      else
        @user.errors.add(:password_confirmation,"Password doesn't match confirmation!".html_safe)
      end
    end
  end

  def update
    @user=User.find params[:id]
    if @user.update_attributes(params[:user])
      render 'close', :notice => "Updated successfully!"
    else
      render 'edit'
    end
  end

  def forgot_password
    if request.post?
      email=params[:user][:email] if params[:user] and params[:user][:email]
      user=User.find_by_email(email)
      if user.present?
        token= "#{Time.now.to_i}#{Random.rand(9999)}"
        user.update_attributes(:verified=>false, :token=>token)
        begin
          url="#{request.protocol}#{request.host_with_port}/users/reset_password?token=#{user.token}&email=#{user.email}"
          UserMailer.forgot_password_email(user, url).deliver
        rescue => ex
        end
        redirect_to login_users_path, :notice => "Mail has been sent to #{user.email}"
      else
        redirect_to forgot_password_users_path, :alert => "User does not exist!"
      end
    end
  end

  def verify
    token=params[:token]
    email=params[:email]
    user=User.find_by_email(email)
    if user.present?
      if token==user.token
        user.update_attributes(:verified=>true, :token=>nil)
        redirect_to login_users_path, :notice => "Verified successfully!"
      else
        redirect_to login_users_path, :alert => "User token does not exist!"
      end
    else
      redirect_to login_users_path, :alert => "User does not exist!"
    end
  end

  def reset_password
    token=params[:token]
    email=params[:email]
    @user=User.find_by_email_and_token(email, token)
    if @user.present?
      if request.put?
        if params[:user] and params[:user][:password] and params[:user][:password_confirmation] and (params[:user][:password]==params[:user][:password_confirmation])
          if params[:user][:password].length>3
            if @user.update_attributes(:verified=>true, :token=>nil, :password=>params[:user][:password_confirmation])
              redirect_to login_users_path, :notice => "Password updated successfully!"
            else
              @user.errors.add(:password, "Something went wrong. Try again!")
#              flash[:alert] = user.errors.full_messages.join(' and ').html_safe
            end
          else
            @user.errors.add(:password, "Password is too short (minimum is 4 characters)!")
          end
        else
          p "====================================================="
          @user.errors.add(:password_confirmation, "Password doesn't match confirmation!".html_safe)
        end
      end
    else
      redirect_to login_users_path, :alert => "User token does not exist!"
    end
  end


end
