# 1. 概要
韻を踏んでる単語の組み合わせを回答するクイズサイト。
現在製作途中。

# 2. URL
https://evening-ravine-59629.herokuapp.com/quizzes

# 3. 開発環境
- Ruby 2.7.2
- ails 6.1.3
- Bootstrap
- PostgreSQL
- Heroku
- Rspec
- RuboCop
- Visual Studio Code

# 4. 機能
- クイズ投稿
- クイズ表示
- 簡易的なログイン

# 5. 機能紹介
## 5-1. クイズ回答機能
### ①回答の選択肢をクリックして、回答ボタンをクリックする
<img width="749" alt="スクリーンショット 2021-08-13 11 53 13" src="https://user-images.githubusercontent.com/67419083/129301338-71302b63-b234-43bd-8419-8bd74cd9f131.png">

### ②回答の結果が表示される
<img width="739" alt="スクリーンショット 2021-08-13 11 53 46" src="https://user-images.githubusercontent.com/67419083/129301342-92e81c63-c247-4d0d-b425-71c7289f8bb9.png">


## 5-2. クイズ投稿機能
<img width="785" alt="スクリーンショット 2021-08-13 11 55 00" src="https://user-images.githubusercontent.com/67419083/129301344-201b738a-0a06-4eb4-b2ee-6838ab486a35.png">
選択肢を追加、削除、並び替えすることができる。  

セレクトボックスで選択肢の母音を選択する。  
投稿ボタンをクリック時、  入力エラーがある場合はエラー内容を表示し、入力エラーがない場合はクイズが投稿される。  
