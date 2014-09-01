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
### 初期データ投入
```bash
$ vagrant ssh host1
$ cd /usr/share/doc/zabbix-server-mysql-2.2.5/create/
$ cat schema.sql images.sql data.sql | mysql -uzabbix -pzabbixpassword zabbix
```

プロビジョニング・初期データ投入が完了したら_http://192.168.33.10/zabbix/_にアクセスしてセットアップ。

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
### Zabbixのアップグレード
#### サーバーのアップグレード
```bash
$ service zabbix-server stop
$ mysqldump -u zabbix -p zabbix > /root/zabbix.dump
$ cp -r /etc/zabbix /root/zabbix-conf.backup
$ yum update zabbix zabbix-server zabbix-server-mysql zabbix-web zabbix-web-mysql
$ service zabbix-server start
```
#### エージェントのアップグレード
```bash
$ service zabbix-agent stop
$ cp /etc/zabbix/zabbix_agentd.conf /root
$ rpm -Fvh zabbix-agent-2.2.3.1.el6.JP.x86_64.rpm
$ yum update zabbix-agent
$ service zabbix-agent start
```

## <a name="3">設定</a>
### サーバー
_site-cookbooks/zabbix22/templates/default/zabbix_server.conf.erb_  
_site-cookbooks/zabbix22/templates/default/zabbix.conf.erb_

サーバーにエージェントをインストールした場合Server=127.0.0.1
### クライアント
_site-cookbooks/zabbix22/templates/default/zabbix_agentd.conf.erb_

### Apache Webサーバの監視
#### コンテンツが正常に表示できなければWebサービスを再起動する
##### ウェブ監視の設定
![](https://farm4.staticflickr.com/3926/14914406087_76633383ea.jpg)
![](https://farm6.staticflickr.com/5558/15100606652_85a5baac9c.jpg)
##### トリガーの設定
![](https://farm6.staticflickr.com/5592/15077976226_4f5bbb10d6.jpg)
![](https://farm4.staticflickr.com/3882/14914401068_dd42681bee.jpg)
##### アクションの設定
![](https://farm4.staticflickr.com/3885/14914406137_e19c9c4f6d.jpg)
![](https://farm6.staticflickr.com/5559/15077976106_4839637ea6.jpg)
![](https://farm4.staticflickr.com/3835/15100606702_e15e8b4176.jpg)
![](https://farm6.staticflickr.com/5551/15097959161_b18b99a970.jpg)

##### リモートコマンドの許可とsudoの設定
_/etc/zabbix/zabbix_agentd.conf_
```
EnableRemoteCommands=1
```
監視対象のサーバーで、rootユーザでvisudoコマンドを実行する
```
#Defaults requiretty
・・・
zabbix localhost=(root) NOPASSWD:/etc/init.d/httpd
```

#### Webサーバのコネクション数の監視
##### Apacheのステータス取得の設定
_/etc/httpd/mods-enabled/status.conf_が有効になっているか確認する

##### ユーザーパラメータの設定
_/etc/zabbix/zabbix_agentd.conf_
```
UserParameter=apache.con.num,sudo /usr/sbin/apachectl status|grep "requests currently being processed"|awk '{print $1}'
```
##### アイテムの設定
![](https://farm4.staticflickr.com/3840/15077976196_3eb518c9fe.jpg)

# 参照
+ [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
+ [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
+ [RuntimeError: Couldn’t determine Berks versionエラーが出たら](http://kwmt27.net/index.php/2014/08/06/runtimeerror-couldnt-determine-berks-version/)
+ [Database Cookbook](https://github.com/opscode-cookbooks/database)
+ [サーバー設定ツール「Chef」の概要と基礎的な使い方 3ページ](http://sourceforge.jp/magazine/14/03/05/090000/3)
+ [chefでattributeファイルを上書きしたい時](http://d.hatena.ne.jp/toritori0318/20131112/1384273734)
+ [【Chef Solo】attributeはどう使い分けるべきか。](http://dev.classmethod.jp/server-side/chef/attribute-overrides-pattern/)
+ [include_recipeだけでは読み込み先のattributesが読み込まれない](http://qiita.com/mistymagich/items/5d6c429863e950ed92cf)
+ [apachectl status で、ステータスが表示されない](http://www.square-mi.com/wp/category/webserver/apache/)
+ [This account is currently not available.でsuで別ユーザに変更できない時](http://blog.mizoshiri.com/archives/214)
+ [【Zabbix】リモートコマンド　～ httpd落ちたら自動で立ち上がる編 ～](http://toatoshi.hatenablog.com/entry/2013/07/17/095543)
