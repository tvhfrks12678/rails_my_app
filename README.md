# 1. 概要
　韻を踏んでる単語の組み合わせを回答するクイズサイトです。
 
　現在製作途中です。

# 2.制作理由
　普段から、ラップが好きで聞いているのですが、ラップを聞いた時にどこで韻を踏んでいるか、分からない場合があります。
 
　韻をどこで踏んでいるかわかった方がより音楽を楽しめるので、どこで韻を踏んでいるかの判断を練習できるサイトがあれば役に立つかと考え作成しています。

# 3. URL
　https://evening-ravine-59629.herokuapp.com/quizzes

# 4. 開発環境
- Ruby 2.7.2
- Rails 6.1.3
- Bootstrap
- PostgreSQL
- Heroku
- Rspec
- RuboCop
- Visual Studio Code

# 5. 機能
- クイズ投稿
- クイズ表示
- 投稿したクイズの検索
- 簡易的なログイン

# 6. 工夫した点
- Fat Controller、Fat Modelの対策にService Object、Query Object、Form Objectなどを導入
- N+1問題対策
- ネストを深くしない

# 7. 機能紹介
## 7-1. クイズ回答機能
### ①回答の選択肢をクリックして、回答ボタンをクリックします
<img width="749" alt="スクリーンショット 2021-08-13 11 53 13" src="https://user-images.githubusercontent.com/67419083/129301338-71302b63-b234-43bd-8419-8bd74cd9f131.png">

### ②回答の結果が表示されます
<img width="739" alt="スクリーンショット 2021-08-13 11 53 46" src="https://user-images.githubusercontent.com/67419083/129301342-92e81c63-c247-4d0d-b425-71c7289f8bb9.png">


## 7-2. クイズ投稿機能
<img width="785" alt="スクリーンショット 2021-08-13 11 55 00" src="https://user-images.githubusercontent.com/67419083/129301344-201b738a-0a06-4eb4-b2ee-6838ab486a35.png">
　選択肢を追加、削除、並び替えすることができます。
 
　セレクトボックスで選択肢の母音を選択できます。
 
　投稿ボタンをクリック時、  入力エラーがある場合はエラー内容を表示し、入力エラーがない場合はクイズが投稿されます。
 
 ## 7-3. 投稿したクイズの検索機能
 ![a5f8a-uur10](https://user-images.githubusercontent.com/67419083/168107027-8c3d860b-ad0b-4811-b789-309bff2def32.png)
投稿したクイズの検索画面です。
