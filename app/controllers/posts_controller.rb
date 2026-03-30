class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @posts =
      if user_signed_in? && current_user.store.present?
        current_user.store.posts.includes(:user, :read_users).order(created_at: :desc)
      else
        Post.none
      end

    if params[:keyword].present?
      @posts = @posts.where("title LIKE ? OR content LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:post_type].present?
      @posts = @posts.where(post_type: params[:post_type])
    end

    if params[:read_status] == "unread" && user_signed_in?
      read_post_ids = current_user.reads.select(:post_id)
      @posts = @posts.where.not(id: read_post_ids).where.not(user_id: current_user.id)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.store = current_user.store

    if @post.save
      flash[:notice] = "共有を投稿しました"
      redirect_to posts_path
    else
      flash[:alert] = "共有の投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = current_user.store.posts.find(params[:id])
    @unread_users = @post.unread_users
  end

  def destroy
    post = current_user.store.posts.find(params[:id])

    if post.user == current_user
      post.destroy
      flash[:notice] = "共有を削除しました"
    else
      flash[:alert] = "他のユーザーの投稿は削除できません"
    end

    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_type)
  end
end
