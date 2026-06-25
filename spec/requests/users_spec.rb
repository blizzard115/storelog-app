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
  end
end
