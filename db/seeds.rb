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
rhyme = Rhyme.create(content: 'えおおえ')
quiz.choices.create!(content: '今日は')
quiz.choices.create!(content: 'スキルも気圧も')
quiz.choices.create!(content: '西高東低', rhyme_id: rhyme.id)
quiz.choices.create!(content: 'また来いや')
quiz.choices.create!(content: '誰かの')
quiz.choices.create!(content: 'セコンドで', rhyme_id: rhyme.id)

quiz_second = user.quizzes.create!(commentary: '正解が二つある')
rhyme_second = Rhyme.create(content: 'あああ')
rhyme_third = Rhyme.create(content: 'おい')
quiz_second.choices.create!(content: '頭', rhyme_id: rhyme_second.id)
quiz_second.choices.create!(content: 'より', rhyme_id: rhyme_third.id)
quiz_second.choices.create!(content: '体', rhyme_id: rhyme_second.id)
quiz_second.choices.create!(content: 'を')
quiz_second.choices.create!(content: '使う')
quiz_second.choices.create!(content: 'ゴリ', rhyme_id: rhyme_third.id)

# その他のユーザーの作成
other_user = User.create!(name: 'z', email: 'z@z.z', password: 'foobar', password_confirmation: 'foobar')
other_quiz = other_user.quizzes.create!(commentary: '')
other_rhyme = Rhyme.create(content: 'いいあいあお')
other_quiz.choices.create!(content: '臭すぎる')
other_quiz.choices.create!(content: 'ひきわり納豆', rhyme_id: other_rhyme.id)
other_quiz.choices.create!(content: 'こいつにくらわす')
other_quiz.choices.create!(content: '右ラリアット', rhyme_id: other_rhyme.id)
