# README

### 単語帳bot

* 本アプリは公式LINEである「単語帳」を友達登録すると使用できるようになります。

* 下記QRコードから友達登録ができます。

<img width="85" alt="スクリーンショット 2021-07-26 12 00 57" src="https://user-images.githubusercontent.com/80399352/127944014-679ebfbb-18be-4cc4-939c-e723f8ebc78e.png">


* 本アプリのデモプレイ動画になります。画像をクリックするとYouTubeへリンクします。

[![](https://img.youtube.com/vi/wCnZWuD3pms/0.jpg)](https://www.youtube.com/watch?v=wCnZWuD3pms)

### 開発の背景

* 社会人になってからも意外と勉強する機会は多い。
* 分厚い参考書を見ると、余計にやる気がそがれ、なかなか勉強する気になれない。
* ついつい現実逃避で、スマートフォンをいじってしまう。

### もっと気軽に勉強できるようにしたい！

* ついついいじってしまいがちなスマートフォンで勉強ができるように開発しました。
* しかも「LINE」ってメッセージ来てなくてもなんとなく開きがちじゃないですか、そこに目をつけて開発しました！

### 本アプリのメリット

* 問題登録しておけば、分厚い参考書を持ち歩く必要がなく、いつでも気軽にできる。
* 問題、答えの登録、削除が簡単にできる。
* 苦手な問題や、覚えづらい単語を登録したりなど、どこにもないオリジナルの問題集を作成できる

### 開発環境

* Ruby 2.7.2
* Rails 6.1.4
* docker

### 主要gem

* `rspec`:単体テスト(model)で使用しました。
* `rubocop`:Rubyの静的コード解析
* `line-bot-api`:LINEmessagingAPIをRailsアプリに組み込む

### デプロイ

* Herokuにてデプロイ実施

### LINE Developers

* provider、チャネルを作成し、公式LINEとして使用できるように設定した。

### Qiita記事

解説記事としてQiita記事を執筆した。

https://qiita.com/kobayashiryou/items/603495f9b357ce7a6a57
