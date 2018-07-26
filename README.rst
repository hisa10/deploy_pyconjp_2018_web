=======================
deploy_pyconjp_2018_web
=======================

Ansible playbook for deploy PyCon JP 2018 Website in Debian server.


WARNING
=======

THIS SCRIPT MAY DAMAGE YOUR SYSTEM, DO NOT USE IT IF YOU ARE NOT UNCERTAIN!!!


Requirements
============

Server
------

- Debian 9 (stretch)
- OpenSSH
- Python 3


Client
------

- UN*X Based OS (or WSL on Windows 10)
- Ansible >= 2.6
  - OpenSSH
  - Python 3 or Python 2.7


Person
------

- Who can operates Linux internet server correctly


手順
====

サーバ側準備
------------

以下、内容を読んで操作方法が理解できることが必要条件のため、あえて具体的なコマンドは書きません。

1. Debian 9をインストール (またはインスタンスを起動)
2. 以下のパッケージをインストール
   - openssh-server
   - python3 
3. sshd_configを以下のように設定する
   - rootユーザでログインできるように
   - Password認証でログインできないように
4. クライアントで生成したssh公開鍵を、サーバのrootのauthorized_keysに追加する


クライアント側準備
------------------

1. Ansibleをインストールする (pipでインストール可能)
2. ~/.ssh/configでIdentitiFileを適切に設定する
3. Ansibleのhostsファイルの[pyconjp]セクションにサーバのホスト名を設定する
   または~/.ssh/configの設定をhostsに合わせる
4. group_vars/all.yml内のdeploybranch行を、pycon.jp.2018リポジトリ内のデプロイ対象にしたいbranch名に設定する


デプロイ
--------

ansible-playbook -i hosts site.yml


運用
====

起動・終了
----------

- デプロイ完了した時点で、最新版のサイトがDockerで起動し、port 4000でlistenする
- 起動: docker-compose start
- 終了: docker-compose stop
- アップデート: /opt/workspace/update-web.sh
  うまくいかない場合は、--no-cacheをつける

ブランチ切り替え
----------------

1. /opt/workspace/pyconjp-2018/docker-compose.yml を編集し、GIT_BRANCH 環境変数を書き換える
2. /opt/workspace/update-web.sh を実行する


ToDo
====

- ~~ Firewall等の設定 ~~
  クラウド側のフィルタ設定で行う方向で。
