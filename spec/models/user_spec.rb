require 'rails_helper'
 
describe User do
  let(:nickname) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:user) { User.new(nickname: nickname, email: email, password: password, password_confirmation: password) } # 変数に格納
 
  describe '.first' do
    before do
      @user = create(:user, nickname: nickname, email: email) # 修正
      @post = create(:post, title: 'タイトル', content: '本文', user: @user)
    end
 
    subject { described_class.first }
 
    it '事前に作成した通りのUserを返す' do
      expect(subject.nickname).to eq('テスト太郎')
      expect(subject.email).to eq('test@example.com')
    end

    it '紐づくPostの情報を取得できる' do
      expect(subject.posts.size).to eq(1)
      expect(subject.posts.first.title).to eq('タイトル')
      expect(subject.posts.first.content).to eq('本文')
      expect(subject.posts.first.user_id).to eq(@user.id)
    end
  end
 
  describe 'validation' do
    let(:password) { '12345678' }
 
    describe 'nickname属性' do
      describe '文字数制限の検証' do
        context 'nicknameが20文字以下の場合' do
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてと' } # 20文字
 
          it 'User オブジェクトは有効である' do
            expect(user.valid?).to be(true)
          end
        end
 
        context 'nicknameが20文字を超える場合' do
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてとな' } # 21文字
 
          it 'User オブジェクトは無効である' do
            user.valid?
 
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include('は20文字以下に設定して下さい。')
          end
        end
      end
 
      describe '存在性の検証' do
        context 'nicknameが空欄の場合' do
          let(:nickname) { '' }
 
          it 'User オブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include("が入力されていません。")
          end
        end
      end
    end

    describe 'store属性' do
      it '保存済みUserのstoreが空の場合は無効である' do
        saved_user = create(:user)
        saved_user.store = nil

        expect(saved_user.valid?).to be(false)
        expect(saved_user.errors.of_kind?(:store, :blank)).to be(true)
      end
    end
  end
end
