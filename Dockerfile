# ベースイメージとして Ruby のオフィシャルイメージを使用
FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs
# 作業ディレクトリの設定
WORKDIR /myapp

# ローカルの Gemfile と Gemfile.lock をコンテナにコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundler を使って Gem をインストール
RUN bundle install

# ローカルのアプリケーションコードをコンテナにコピー
COPY . /myapp

# Pumaサーバのポートを公開
EXPOSE 3000

# コンテナ起動時に実行するコマンドを設定
CMD ["rails", "server", "-b", "0.0.0.0"]

