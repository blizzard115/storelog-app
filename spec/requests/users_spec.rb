require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:store) { create(:store) }
  let(:user) { create(:user, store: store) }
  let(:same_store_user) { create(:user, store: store) }

  let(:other_store) { create(:store) }
  let(:other_store_user) { create(:user, store: other_store) }

  describe 'GET /users/:id' do
    before { sign_in user }

    it '同じ店舗のユーザーページを閲覧できる' do
      get user_path(same_store_user)

      expect(response).to have_http_status(:ok)
    end

    it '別店舗のユーザーページを閲覧できない' do
      get user_path(other_store_user)

      expect(response).to have_http_status(:not_found)
    end

    context '所属店舗を変更した場合' do
      before do
        @old_store_post = create(
          :post,
          title: '元店舗の投稿',
          user: user,
          store: store
        )

        user.update!(store: other_store)

        @new_store_post = create(
          :post,
          title: '新しい店舗の投稿',
          user: user,
          store: other_store
        )
      end

      it '元店舗の投稿は表示されない' do
        get user_path(user)

        expect(response.body).not_to include(@old_store_post.title)
      end

      it '新しい所属店舗の投稿だけが表示される' do
        get user_path(user)

        expect(response.body).to include(@new_store_post.title)
      end
    end
  end
end
