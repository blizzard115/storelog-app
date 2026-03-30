class ReadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.reads.find_or_create_by(post: @post)

    redirect_to post_path(@post), notice: "確認しました"
  end
end
