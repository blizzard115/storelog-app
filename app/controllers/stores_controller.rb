class StoresController < ApplicationController
  before_action :authenticate_user!

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      current_user.update(store: @store)
      redirect_to posts_path, notice: "店舗を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
  end

  def join_create
    store = Store.find_by(store_code: params[:store_code])

    if store.present?
      current_user.update(store: store)
      redirect_to posts_path, notice: "店舗に参加しました"
    else
      flash.now[:alert] = "店舗コードが見つかりません"
      render :join, status: :unprocessable_entity
    end
  end

  private

  def store_params
    params.require(:store).permit(:name, :email, :store_code)
  end
end
