class UsersController < ApplicationController

  before_action :authenticate_user, {only:[:index,:show,:edit,:update]}
  before_action :forbid_login_user, {only:[:new,:create,:login_form,:login]}
  before_action :ensure_correct_user, {only:[:edit,:update]}

  def index
    @user = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name:params[:name], email:params[:email], image_name:"default_image.png", password:params[:password])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "登録しました"
      redirect_to("/users/index")
    else
      render("users/new")
    end
  end

  def show
    @user = User.find_by(id:params[:id])
    @likes = Like.where(user_id:params[:id])
  end

  def edit
    @user = User.find_by(id:params[:id])
  end

  def update
    @user = User.find_by(id:params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @user.save
      flash[:notice] = "編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def login_form

  end

  def login
    @user = User.find_by(email:params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/tweets/index")
    else
      @login_error = "メールアドレスかパスワードが違います"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login_form")
  end

end
