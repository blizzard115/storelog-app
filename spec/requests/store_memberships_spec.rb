require 'rails_helper'

RSpec.describe 'StoreMemberships', type: :request do
  let(:current_store) { create(:store, name: '現在の店舗') }
  let(:user) { create(:user, store: current_store) }
  let(:new_store) { create(:store, name: '参加先店舗', store_code: 'JOIN-CODE') }

  describe 'GET /store_membership' do
    context 'ログインしていない場合' do
      it '店舗設定画面にアクセスできない' do
        get store_membership_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      it '店舗設定画面を表示できる' do
        get store_membership_path

        expect(response).to have_http_status(:ok)
      end

      it '現在の店舗名が表示される' do
        get store_membership_path

        expect(response.body).to include(current_store.name)
      end
    end
  end

  describe 'PATCH /store_membership' do
    before { sign_in user }

    context '店舗コードが存在する場合' do
      it '所属店舗を変更して投稿一覧へリダイレクトする' do
        expect do
          patch store_membership_path, params: {
            store_membership: { store_code: new_store.store_code }
          }
        end.to change { user.reload.store_id }.from(current_store.id).to(new_store.id)

        expect(response).to redirect_to(posts_path)
      end

      it '店舗変更後も過去の投稿のstore_idは変わらない' do
        past_post = create(:post, user: user, store: current_store)

        patch store_membership_path, params: {
          store_membership: { store_code: new_store.store_code }
        }

        expect(past_post.reload.store_id).to eq(current_store.id)
      end
    end

    context '店舗コードが存在しない場合' do
      it '所属店舗を変更せずエラーを表示する' do
        expect do
          patch store_membership_path, params: {
            store_membership: { store_code: 'UNKNOWN-CODE' }
          }
        end.not_to(change { user.reload.store_id })

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('店舗コードに一致する店舗が見つかりません')
      end
    end
  end
end
