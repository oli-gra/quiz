class ModelTables < ActiveRecord::Migration[5.2]
  def change

    create_table :questions do |t|
  t.string :category
  t.string :difficulty
  t.string :question
  t.string :answer
  t.string :wrong_1
  t.string :wrong_2
  t.string :wrong_3
  t.timestamps
end

create_table :users do |t|
  t.string :name
  t.integer :age
  t.timestamps
end

create_table :leaderboards do |t|
  t.integer :question_id
  t.integer :user_id
  t.boolean :result
  t.timestamps
end

  end
end
