# Vagrant で古いサーバ環境をローカルに構築する
古い CentOS サーバ環境で動いている Word Press 等の急なメンテ用に、ローカルに環境を立てるためのもの。
VirtualBox を使う。
* PHP 5.3
* MySQL 5.1
* Apache 2.2

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
```
$ cd old_centos_server
$ vagrant up
```
http://192.168.33.10 にブラウザアクセス。


#### Packer でビルドし直したときの登録
```
$ vagrant box add old_centos centos-6-5-x65-virtualbox.box --force
```

#### issue
`vagrant up` のとき、共有フォルダのマウントに失敗する。
ホスト VirtualBox とゲストでバージョンを合わせるために、プラグインが必要。
```
$ vagrant plugin install vagrant-vbguest
```

がうまくいかず、結局 Vagrant サーバで `yum update` して Error が出ないようにしたので、CentOS が 6.10 になる。
