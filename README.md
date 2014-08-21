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
### MySQLのインストール
```bash
$ knife cookbook create mysql -o ./site-cookbooks
$ cd site-cookbooks/mysql
```
### zabbixのインストール
```bash
$ cd cookbooks/zabbix_introduction/
$ berks init
```
_Berksfile_
```
cookbook "zabbix"
```
```bash
$ berks vendor
```
```bash
$ knife cookbook create zabbix -o ./site-cookbooks
cd
```
## <a name="3">設定</a>

# 参照
+ [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
+ [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
+ [RuntimeError: Couldn’t determine Berks versionエラーが出たら](http://kwmt27.net/index.php/2014/08/06/runtimeerror-couldnt-determine-berks-version/)
+ [Database Cookbook](https://github.com/opscode-cookbooks/database)
