# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを一人作成する
user = User.create!(name: 'q', email: 'q@q.q', password: 'foobar', password_confirmation: 'foobar')
quiz = user.quizzes.create!(commentary: '西高東低で気圧とスキルでダブルミーングになっている')
quiz.choices.create!(content: '今日は')
quiz.choices.create!(content: 'スキルも気圧も')
quiz.choices.create!(content: '西高東低')
quiz.choices.create!(content: 'また来いや')
quiz.choices.create!(content: '誰かの')
quiz.choices.create!(content: 'セコンドで')

other_user = User.create!(name: 'z', email: 'z@z.z', password: 'foobar', password_confirmation: 'foobar')
other_quiz = other_user.quizzes.create!(commentary: '')
other_quiz.choices.create!(content: '臭すぎる')
other_quiz.choices.create!(content: 'ひきわり納豆')
other_quiz.choices.create!(content: 'こいつにくらわす')
other_quiz.choices.create!(content: '右ラリアット')
