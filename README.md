Zabbix入門
===
# 目的
Zabbixのインストール・設定の解説

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| Chef Development Kit  |0.1.0  |             |
| vagrant        |1.6.0         |             |

# 構成
+ [セットアップ](#1)
+ [インストール](#2)
+ [設定](#3)

# 詳細
## <a name="1">セットアップ</a>
```bash
$ chef generate app zabbix_introduction
$ cd zabbix_introduction
$ git add .
$ git commit -am "セットアップ"
$ git create
$ git push origin master
```
## <a name="2">インストール</a>
### zabbixのインストール
#### Zabbix SIAのyumレポジトリ登録
_site-cookbooks/zabbix22/recipes/base.rb_
#### Zabbixサーバのインストール
_site-cookbooks/zabbix22/recipes/server.rb_  
_site-cookbooks/zabbix22/recipes/database.rb_
#### Webインターフェースのインストール
_site-cookbooks/zabbix22/recipes/web.rb_

#### zabbixエージェントのインストール
_site-cookbooks/zabbix22/recipes/agent.rb_

### データベースのインストール
_cookbooks/zabbix_introduction/Berksfile_
```bash
cookbook "mysql"
cookbook "database"
```

### プロビジョニング実行
```bash
$ cd cookbooks/zabbix_introduction
$ vagrant up --provision
```

名前解決に失敗する場合は以下を実行してい再度プロビジョニング実行
```bash
$ vagrant ssh
$ echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
```
プロビジョニングが完了したら_http://192.168.33.10/zabbix/_にアクセスしてセットアップ。

|      |     |
|:---------------|:-------------|
| Database name  |zabbix        |
| User  |zabbix        |
| Password  |zabbixpassword     |
| ログインUsername |Admin        |
| ログインPassword |zabbix       |

zabbixサーバーが起動していない場合はサービスを再起動する
```
$ vagrant ssh
$ sudo service zabbix-server restart
```

## <a name="3">設定</a>

# 参照
+ [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
+ [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
+ [RuntimeError: Couldn’t determine Berks versionエラーが出たら](http://kwmt27.net/index.php/2014/08/06/runtimeerror-couldnt-determine-berks-version/)
+ [Database Cookbook](https://github.com/opscode-cookbooks/database)
+ [サーバー設定ツール「Chef」の概要と基礎的な使い方 3ページ](http://sourceforge.jp/magazine/14/03/05/090000/3)
