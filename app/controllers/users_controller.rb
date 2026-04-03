class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store

  def show
    @user = @store.users.find(params[:id])
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

  private

  def set_store
    @store = current_user.store
    return if @store.present?

    redirect_to new_store_path, alert: "店舗を作成するか、既存の店舗に参加してください。"
  end
end
