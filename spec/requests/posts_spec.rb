require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  before do
    @store = create(:store)
    @user = create(:user, store: @store)
    @same_store_user = create(:user, store: @store)
    @post = create(:post, user: @user, store: @store)
    @same_store_post = create(:post, user: @same_store_user, store: @store)

    @other_store = create(:store)
    @other_store_user = create(:user, store: @other_store)
    @other_store_post = create(:post, user: @other_store_user, store: @other_store)
  end

  describe 'GET /posts/new' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get '/posts/new'
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get '/posts/new'
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }
      it 'HTTPステータス200を返す' do
        get '/posts/new'
        expect(response).to have_http_status(200)
      end

      it 'ログインページにリダイレクトされない' do
        get '/posts/new'
        expect(response).not_to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET /posts/:id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get "/posts/#{@post.id}"
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get "/posts/#{@post.id}"
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }

      it '同じ店舗の投稿詳細を閲覧できる' do
        get post_path(@same_store_post)

        expect(response).to have_http_status(:ok)
      end

      it '別店舗の投稿詳細を閲覧できない' do
        get post_path(@other_store_post)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    before { sign_in @user }

    it '自分が作成した同じ店舗の投稿編集画面を閲覧できる' do
      get edit_post_path(@post)

      expect(response).to have_http_status(:ok)
    end

    it '別店舗の投稿編集画面を閲覧できない' do
      get edit_post_path(@other_store_post)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /posts/:id' do
    before { sign_in @user }

    it '別店舗の投稿を更新できない' do
      original_title = @other_store_post.title

      patch post_path(@other_store_post), params: {
        post: {
          title: '更新後のタイトル',
          content: @other_store_post.content,
          post_type: @other_store_post.post_type
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(@other_store_post.reload.title).to eq(original_title)
    end
  end

  describe 'DELETE /posts/:id' do
    before { sign_in @user }

    it '別店舗の投稿を削除できない' do
      expect do
        delete post_path(@other_store_post)
      end.not_to change(Post, :count)

      expect(response).to have_http_status(:not_found)
      expect(Post.exists?(@other_store_post.id)).to be(true)
    end
  end

  describe 'GET /posts' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get '/posts'
        expect(response).to have_http_status(302)
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    context 'ログインしている場合' do
      it 'HTTPステータス200を返す' do
        sign_in @user
        get '/posts'
        expect(response).to have_http_status '200'
      end
    end
  end
end
