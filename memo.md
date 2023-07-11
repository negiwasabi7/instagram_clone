# 1.devise

**deviseについて、Notionで説明されているとおり実施する**

## 1.1 Gemfileにdeviseを追加

```ruby
gem 'devise'
```

## 1.2 gemをインストールする

```bash
make bundle.install
```

## 1.3 初期設定

```bash
make rails generate devise:install
```

## 1.4 config/application.rbを編集する


- 次のコメントを外す

```ruby
# require "action_mailer/railtie"
```

- 次の行(config.action_mailer.default_url_options ・・・・)を追加する

```ruby
module App
  class Application < Rails::Application
    ...

    config.action_mailer.default_url_options = { host: ENV['APP_DEFAULT_URL_HOST'], port: ENV['APP_DEFAULT_URL_PORT'] }
  end
end
```

## 1.5 docker-compose.ymlに環境変数を追加

```yml
version: '3.9'
services:
  app:
    ...
    environment:
      ...
      # 追加
      - APP_DEFAULT_URL_HOST=localhost
      - APP_DEFAULT_URL_PORT=3000
```

## 1.6 userモデルを作成する

```bash
make rails generate devise user
```


# 2.モデルの作成

## 2.1 ユーザー (users)

- userモデルにカラム(nickname)を追加する。

```bash
make rails generate migration AddNicknameToUsers nickname:string
```

-  app/controllers/application_controller.rbを編集する

```ruby
class ApplicationController < ActionController::Base
  # 追加
  before_action :authenticate_user!
end
```

## 2.2 投稿(写真) (posts)

```bash
make rails g model post user:references description:text
```


**マイグレーションファイルを編集し、descriptionカラムにNOT NULL制約(null: true)を追加する**

"db/migrate/2023xxxxxxxxxx_create_posts.rb"

```ruby
t.string :description, null: true
```

## コメント (comments)

```bash
make rails g model comment user:references post:references content:text
```

## いいね (likes)

```bash
make rails g model like user:references post:references
```

## 2.3 ブックマーク (bookmarks)

```bash
make rails g model bookmark user:references post:references
```

## DM (direct_messages)


**生成されたマイグレーションファイルを以下のように変更**

"db/migrate/2023xxxxxxxxxx_create_direct_messages.rb"

```ruby
t.references :target, foreign_key: { to_table: :users }
```

## 2.4 フォロー (relationships)

```bash
make rails g model relationship follow:references follower:references content:text
```

## 2.5　マイグレーションを実施

```bash
make rails db:migrate
```

# 3.コントローラー(画面)の作成

**「6.コントローラー(画面)の作成」に説明されているとおりにコントローラとアクションを生成する**

**コントローラーの名前は、先頭を大文字にする**

## 3.1 トップ(home)

```bash
make rails generate controller Home index
```

## 3.2 投稿(articles)

```bash
make rails generate controller Articles show new create destroy
```

## 3.3 プロフィール(profiles)

```bash
make rails generate controller Profiles show edit
```


## 3.4 フォロー(follows)

```bash
make rails generate controller Follows index follow unfollow
```


## 3.5 フォロワー(followers) 

```bash
make rails generate controller Followers index follow unfollow
```

# 4.ルーティングの設定

**コントロールに合わせてルーティングを設定する**

**config/routes.rbを編集**

```ruby
Rails.application.routes.draw do
  # トップ(home)
  get 'home/index'

  # 投稿(articles)
  resources :articles, only: [:show, :new, :create, :destroy]

  # プロフィール(profiles)
  resources :profiles, only: [:show, :edit]

  # フォロー(follows)
  resources :follows, only: [:index] do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end

  # フォロワー(followers)
  resources :followers, only: [:index] do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end

  # デフォルトのルートを設定
  root 'home#index'
end
```

# 5.Viewのコーディング

# 6.レイアウトファイルを作る
