class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy] # ログインしているかどうかを判断
 
  def index
    @posts = Post.includes(:user, :read_users).order(created_at: :desc)

    if params[:keyword].present?
      @posts = @posts.where("title LIKE ? OR content LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:post_type].present?
      @posts = @posts.where(post_type: params[:post_type])
    end
  end
  
  def new
    @post = Post.new # 新規投稿用のインスタンス変数を用意
  end
 
  def create
    @post = Post.new(post_params) # ストロングパラメータを使ってフォームから受け取ったパラメータを許可
    @post.user = current_user
 
    if @post.save
      flash[:notice] = '投稿しました' # 成功時のフラッシュメッセージ
      redirect_to posts_path # 一時的にトップページへリダイレクト(後に修正)
    else
      flash[:alert] = '投稿に失敗しました' # 失敗時のフラッシュメッセージ
      render :new, status: :unprocessable_entity # 投稿画面を再表示
    end
  end
 
  def show
    @post = Post.find(params[:id])
    @unread_users = User.where.not(id: @post.read_users.pluck(:id) + [@post.user_id])
  end
 
  def destroy
    post = Post.find(params[:id])

    if post.user == current_user
      post.destroy
      flash[:notice] = "投稿が削除されました"
    else
      flash[:alert] = "他のユーザーの投稿は削除できません"
    end

    redirect_to posts_path
  end
  private
 
  # ストロングパラメータで許可するカラムを指定
  def post_params
    params.require(:post).permit(:title, :content, :post_type)
  end
end
