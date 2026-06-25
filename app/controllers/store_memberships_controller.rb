class StoreMembershipsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    store = Store.find_by(store_code: store_code)

    if store.present?
      current_user.update!(store: store)
      redirect_to posts_path, notice: "#{store.name}に参加しました"
    else
      flash.now[:alert] = '店舗コードに一致する店舗が見つかりません'
      render :show, status: :unprocessable_content
    end
  end

  private

  def store_code
    params.require(:store_membership).permit(:store_code)[:store_code].to_s.strip
  end
end
