class TweetsController < ApplicationController

  before_action :authenticate_user
  before_action :ensure_correct_editer, {only:[:edit,:update, :destroy]}

  def index
    @posts = Tweet.all.order(created_at: :desc)
  end

  def search
    @searched_posts = Tweet.where("content LIKE ?", "%#{params[:search]}%").order(created_at: :desc)
    render("tweets/index")
  end

  def show
    @post = Tweet.find_by(id:params[:id])
    @user = @post.user
    @like = Like.where(post_id:params[:id])
  end

  def new
    @post = Tweet.new
  end

  def create
    @post = Tweet.new(content:params[:content], user_id:@current_user.id)
    if @post.save == false
      render("tweets/new")
    elsif params[:image]
      @post.image_name = "#{@post.id}.jpg"
      @post.save
      image = params[:image]
      File.binwrite("public/tweet_images/#{@post.image_name}", image.read)
      flash[:notice] = "投稿されました"
      redirect_to("/tweets/index")
    else
      flash[:notice] = "投稿されました"
      redirect_to("/tweets/index")
    end
  end

  def edit
    @post = Tweet.find_by(id:params[:id])
  end

  def update
    @post = Tweet.find_by(id:params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "編集しました"
      redirect_to("/tweets/index")
    else
      render("tweets/edit")
    end
  end

  def destroy
    @post = Tweet.find_by(id:params[:id])
    @like = Like.where(post_id:params[:id])
    @post.destroy
    if @like
      @like.destroy_all
    end
    if @post.image_name
      File.unlink("public/tweet_images/#{@post.image_name}")
    end
    flash[:notice] = "削除しました"
    redirect_to("/tweets/index")
  end

  def ensure_correct_editer
    @post = Tweet.find_by(id:params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/tweets/index")
    end
  end

end
