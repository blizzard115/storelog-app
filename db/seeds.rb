if Rails.env.production?
  puts "デモseedは本番環境では実行しません。"
else
  demo_password = "password"

  ActiveRecord::Base.transaction do
    stores = {}

    [
      { key: :shibuya, name: "デモ渋谷店", store_code: "DEMO-SHIBUYA" },
      { key: :shinjuku, name: "デモ新宿店", store_code: "DEMO-SHINJUKU" },
      { key: :old, name: "デモ移動前店舗", store_code: "DEMO-OLD" }
    ].each do |store_attrs|
      store = Store.find_or_initialize_by(store_code: store_attrs[:store_code])
      store.update!(name: store_attrs[:name])
      stores[store_attrs[:key]] = store
    end

    users = {}

    [
      {
        key: :shibuya_manager,
        email: "demo.shibuya.manager@example.com",
        nickname: "渋谷店 店長",
        store: stores[:shibuya]
      },
      {
        key: :shibuya_staff,
        email: "demo.shibuya.staff@example.com",
        nickname: "渋谷店 スタッフ",
        store: stores[:shibuya]
      },
      {
        key: :shinjuku_manager,
        email: "demo.shinjuku.manager@example.com",
        nickname: "新宿店 店長",
        store: stores[:shinjuku]
      },
      {
        key: :shinjuku_staff,
        email: "demo.shinjuku.staff@example.com",
        nickname: "新宿店 スタッフ",
        store: stores[:shinjuku]
      },
      {
        key: :join_demo,
        email: "demo.join@example.com",
        nickname: "店舗参加デモ",
        store: stores[:old]
      }
    ].each do |user_attrs|
      user = User.find_or_initialize_by(email: user_attrs[:email])
      user.update!(
        nickname: user_attrs[:nickname],
        password: demo_password,
        password_confirmation: demo_password,
        store: user_attrs[:store]
      )
      users[user_attrs[:key]] = user
    end

    now = Time.current
    posts = {}

    [
      {
        key: :shibuya_morning_notice,
        title: "【重要】本日の朝礼共有",
        content: "本日の重点確認です。\n・レジ周りの声かけを徹底する\n・夕方の混雑前に補充状況を確認する\n・未確認の共有は必ず詳細画面で確認してください",
        post_type: :notice,
        important: true,
        user: users[:shibuya_manager],
        store: stores[:shibuya],
        created_at: now - 4.days
      },
      {
        key: :shibuya_arrival,
        title: "週末フェア商品の入荷予定",
        content: "週末フェア用の商品が金曜日の午前中に入荷予定です。入荷後はバックヤードで数量を確認し、売場展開の準備をお願いします。",
        post_type: :arrival,
        important: false,
        user: users[:shibuya_manager],
        store: stores[:shibuya],
        created_at: now - 3.days
      },
      {
        key: :shibuya_claim,
        title: "レジ対応での注意点",
        content: "ポイント付与に関するお問い合わせが増えています。説明時はレシート下部の案内も一緒に確認してください。",
        post_type: :claim,
        important: false,
        user: users[:shibuya_staff],
        store: stores[:shibuya],
        created_at: now - 2.days
      },
      {
        key: :shibuya_customer_service,
        title: "常連のお客様メモ",
        content: "よく来店されるお客様から、次回入荷予定について質問がありました。担当者は入荷日が分かり次第、共有をお願いします。",
        post_type: :customer_service,
        important: false,
        user: users[:shibuya_staff],
        store: stores[:shibuya],
        created_at: now - 1.day
      },
      {
        key: :shinjuku_important_notice,
        title: "【重要】新宿店の共有事項",
        content: "新宿店内でのみ共有する連絡です。別店舗のユーザーからは閲覧できないことを確認するためのデモ投稿です。",
        post_type: :notice,
        important: true,
        user: users[:shinjuku_manager],
        store: stores[:shinjuku],
        created_at: now - 4.days
      },
      {
        key: :shinjuku_arrival,
        title: "新宿店 入荷メモ",
        content: "新宿店向けの商品が入荷しました。売場の棚番号を確認し、品出し後に在庫数を共有してください。",
        post_type: :arrival,
        important: false,
        user: users[:shinjuku_staff],
        store: stores[:shinjuku],
        created_at: now - 2.days
      },
      {
        key: :shinjuku_claim,
        title: "新宿店 クレーム対応メモ",
        content: "返品対応に関する問い合わせがありました。同様の問い合わせがあった場合は、責任者へ確認してから対応してください。",
        post_type: :claim,
        important: false,
        user: users[:shinjuku_staff],
        store: stores[:shinjuku],
        created_at: now - 1.day
      },
      {
        key: :old_store_post,
        title: "店舗移動前の投稿サンプル",
        content: "店舗コード参加機能の確認用投稿です。店舗を変更しても、この投稿は投稿時点の店舗に残ります。",
        post_type: :notice,
        important: false,
        user: users[:join_demo],
        store: stores[:old],
        created_at: now - 5.days
      }
    ].each do |post_attrs|
      post = Post.find_or_initialize_by(
        title: post_attrs[:title],
        user: post_attrs[:user]
      )

      post.update!(
        content: post_attrs[:content],
        post_type: post_attrs[:post_type],
        important: post_attrs[:important],
        store: post_attrs[:store],
        created_at: post_attrs[:created_at],
        updated_at: now
      )

      posts[post_attrs[:key]] = post
    end

    [
      { user: users[:shibuya_staff], post: posts[:shibuya_morning_notice] },
      { user: users[:shibuya_staff], post: posts[:shibuya_arrival] },
      { user: users[:shibuya_manager], post: posts[:shibuya_claim] },
      { user: users[:shinjuku_staff], post: posts[:shinjuku_important_notice] },
      { user: users[:shinjuku_manager], post: posts[:shinjuku_arrival] }
    ].each do |read_attrs|
      Read.find_or_create_by!(
        user: read_attrs[:user],
        post: read_attrs[:post]
      )
    end
  end

  puts "デモseedを作成しました。"
  puts "ログイン例: demo.shibuya.staff@example.com / password"
  puts "店舗参加デモ: demo.join@example.com / password でログインし、店舗コード DEMO-SHIBUYA を入力してください。"
end
