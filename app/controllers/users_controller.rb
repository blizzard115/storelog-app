class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)

    if params[:keyword].present?
      @posts = @posts.where("title LIKE ? OR content LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:status].present?
      @posts = @posts.where(status: params[:status])
    end

    if params[:post_type].present?
      @posts = @posts.where(post_type: params[:post_type])
    end

    @post_count = @posts.count
  end
end
