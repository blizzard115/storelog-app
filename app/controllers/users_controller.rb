class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user.store.users.find(params[:id])
    @posts = @user.posts.includes(:read_users).order(created_at: :desc)

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

    @post_count = @posts.count
  end
end
