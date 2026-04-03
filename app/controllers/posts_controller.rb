class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = @store.posts
                   .includes(:user, :read_users)
                   .order(created_at: :desc)

    if params[:keyword].present?
      @posts = @posts.where("title LIKE ? OR content LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:post_type].present?
      @posts = @posts.where(post_type: params[:post_type])
    end

    if params[:read_status] == "unread"
      read_post_ids = current_user.reads.select(:post_id)
      @posts = @posts.where.not(id: read_post_ids).where.not(user_id: current_user.id)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = @store.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to posts_path, notice: "共有を投稿しました"
    else
      flash.now[:alert] = "共有の投稿に失敗しました"
      render :new, status: :unprocessable_content
    end
  end

  def show
    @unread_users = @post.unread_users
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "共有を更新しました"
    else
      flash.now[:alert] = "共有の更新に失敗しました"
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "共有を削除しました"
  end

  private

  def set_store
    @store = current_user.store
    return if @store.present?

    redirect_to new_store_path, alert: "店舗を作成するか、既存の店舗に参加してください。"
  end

  def set_post
    @post = @store.posts.find(params[:id])
  end

  def ensure_post_owner
    return if @post.user_id == current_user.id

    redirect_to posts_path, alert: "他のユーザーの投稿は編集・削除できません"
  end

  def post_params
    params.require(:post).permit(:title, :content, :post_type)
  end
end
