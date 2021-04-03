FactoryBot.define do
  factory :goal do
    title { Faker::Lorem.sentence(word_count: 2, random_words_to_add: 2) }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 2) }
    user
    is_template { Faker::Boolean.boolean }
    # TODO: generate template in 2/3 of all cases
  end
end
