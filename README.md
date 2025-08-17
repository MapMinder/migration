# migration
DB マイグレション用のリポジトリ
※ 詳細なreadmeはあとほど書きます

# 前提条件

1. ローカルに `mysql@8.0` をインストールされていること
2. DockerとDocker-composeを利用できるじょうたいであること
3. go migrate をインストールされていること(参考：[go migrate](https://github.com/golang-migrate/migrate))

# セットアップ
## 手順

1. 本リポジトリをcloneする
2. 以下のコマンド利用してデータベースを立ち上げる

```sh
docker-compose up -d  // daemonで起動したくないなら -d を追加せずコマンドを実行
```
3. mysqlのコンテナを起動していることを以下のコマンド打って確認

```sh
docker ps
```
4. 本リポジトリのrootディレクトリに移動し以下のコマンドを打つ
 
```sh
migrate -path ./migration -database "mysql://<user>:<password>@tcp(localhost:3306)/<dbname>" up
```
