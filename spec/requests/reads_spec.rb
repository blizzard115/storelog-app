require 'rails_helper'

RSpec.describe 'Reads', type: :request do
  let(:store) { create(:store) }
  let(:user) { create(:user, store: store) }
  let(:same_store_user) { create(:user, store: store) }
  let(:same_store_post) { create(:post, user: same_store_user, store: store) }

  let(:other_store) { create(:store) }
  let(:other_store_user) { create(:user, store: other_store) }
  let(:other_store_post) { create(:post, user: other_store_user, store: other_store) }

  describe 'POST /posts/:post_id/read' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '同じ店舗の投稿の場合' do
        it '既読登録できる' do
          expect do
            post post_read_path(same_store_post)
          end.to change(Read, :count).by(1)

          expect(response).to redirect_to(post_path(same_store_post))
          expect(Read.exists?(user: user, post: same_store_post)).to be(true)
        end

        it '同じ投稿を二度確認しても既読が重複しない' do
          post post_read_path(same_store_post)

          expect do
            post post_read_path(same_store_post)
          end.not_to change(Read, :count)

          expect(Read.where(user: user, post: same_store_post).count).to eq(1)
        end
      end

      context '別店舗の投稿の場合' do
        it '既読登録できない' do
          expect do
            post post_read_path(other_store_post)
          end.not_to change(Read, :count)

          expect(response).to have_http_status(:not_found)
          expect(Read.exists?(user: user, post: other_store_post)).to be(false)
        end
      end
    end

    context 'ログインしていない場合' do
      it '既読登録できない' do
        expect do
          post post_read_path(same_store_post)
        end.not_to change(Read, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
