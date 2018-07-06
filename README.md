# Vagrant で古いサーバ環境をローカルに構築する
古い CentOS サーバ環境で動いている Word Press 等の急なメンテ用に、ローカルに環境を立てるためのもの。
VirtualBox を使う。
* PHP 5.3
* MySQL 5.1
* Apache 2.2

## Vagrant と Packer を用意する
```
$ brew install packer
$ brew cask install vagrant

$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-hostsupdater
```
## Packer で Vagrant Box を作って登録する
```
$ cd old_centos_server/packer
$ packer build -only=virtualbox-iso template.json
$ vagrant box add old_centos centos-6-5-x65-virtualbox.box
```
## WordPress を立てる場合
* `old_centos_server/html` が Vagrant の共有ディレクトリになってるので、ここに本番サーバのドキュメントルートの中身を置く。

* WordPress が一つだけ入っている場合、wp-config.php の情報を取得して Vagrant サーバにデータベースとユーザを自動で設定する。

* `old_centos_server/html`直配下に WordPress からエクスポートした .sql 拡張子の SQL ダンプファイルがあれば読み込む。


## Vagrant でローカルサーバを立てる

Vagrantfile の hostname を書き換える。
```
# Vagrantfile

config.vm.hostname = "example.com"
```

```
$ cd old_centos_server
$ vagrant up
```

http://192.168.33.10 にブラウザアクセス。


#### Packer でビルドし直したときの登録
```
$ vagrant box add old_centos centos-6-5-x65-virtualbox.box --force
```

#### ※※※
ホスト VirtualBox とゲストでバージョンを合わせるためプラグインを入れたが、
これだけだと共有フォルダのマウントに失敗する。

Packer のプロビジョニングでカーネルを変える必要があった。
```
# packer/scripts/cleanup.sh
...
yum -y install http://vault.centos.org/6.4/cr/x86_64/Packages/kernel-devel-2.6.32-431.el6.x86_64.rpm
```
