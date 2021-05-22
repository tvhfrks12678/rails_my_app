# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを一人作成する
user = User.create!(name: 'q', email: 'q@q.q', password: 'foobar', password_confirmation: 'foobar')

# 選択肢: 6 母音: 1
quiz = user.quizzes.create!(commentary: '西高東低で気圧とスキルでダブルミーングになっている')
rhyme = Rhyme.create(content: 'えおおえ')
quiz.choices.create!(content: '今日は')
quiz.choices.create!(content: 'スキルも気圧も')
quiz.choices.create!(content: '西高東低', rhyme_id: rhyme.id)
quiz.choices.create!(content: 'また来いや')
quiz.choices.create!(content: '誰かの')
quiz.choices.create!(content: 'セコンドで', rhyme_id: rhyme.id)

# 選択肢: 6 母音: 2
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

# 選択肢: 4 母音: 1
other_quiz = other_user.quizzes.create!(commentary: '')
other_rhyme = Rhyme.create(content: 'いいあいあお')
other_quiz.choices.create!(content: '臭すぎる')
other_quiz.choices.create!(content: 'ひきわり納豆', rhyme_id: other_rhyme.id)
other_quiz.choices.create!(content: 'こいつにくらわす')
other_quiz.choices.create!(content: '右ラリアット', rhyme_id: other_rhyme.id)

# 選択肢: 10 母音: 5
quiz_tird = user.quizzes.create!(commentary: '韻を踏んだ文章は不自然さを気にしたら負けだって、ばっちゃんが言ってた。')
rhyme_words = %w[oie uiu aee ioi eoi]
rhyme = []
rhyme_words.each do |rhyme_word|
  rhyme << Rhyme.create!(content: rhyme_word)
end
quiz_tird.choices.create!(content: '起きて', rhyme_id: rhyme[0].id)
quiz_tird.choices.create!(content: '終日', rhyme_id: rhyme[1].id)
quiz_tird.choices.create!(content: '雨で', rhyme_id: rhyme[2].id)
quiz_tird.choices.create!(content: 'カフェで', rhyme_id: rhyme[2].id)
quiz_tird.choices.create!(content: '一人', rhyme_id: rhyme[3].id)
quiz_tird.choices.create!(content: 'のみで', rhyme_id: rhyme[0].id)
quiz_tird.choices.create!(content: '勉強し', rhyme_id: rhyme[4].id)
quiz_tird.choices.create!(content: '充実', rhyme_id: rhyme[1].id)
quiz_tird.choices.create!(content: 'enjoy', rhyme_id: rhyme[4].id)
quiz_tird.choices.create!(content: 'にこり', rhyme_id: rhyme[3].id)

# 選択肢: 6 母音: 3
quizzes = []
quizzes << user.quizzes.create!(commentary: '図書館のんは無声音と言って、無視していい。')
rhyme_word_list = %w[ooa iio iai]
rhymes = []
rhyme_word_list.each do |rhyme_word|
  rhymes << Rhyme.create!(content: rhyme_word)
end
words = %w[ここは 図書館 神秘の 真理を 理解 したい]
words_rhyme = [rhymes[0], rhymes[0], rhymes[1], rhymes[1], rhymes[2], rhymes[2]]

words.each_with_index do |word, idx|
  quizzes[0].choices.create!(content: word, rhyme_id: words_rhyme[idx].id)
end
