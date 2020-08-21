class AddColumnToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :image_name, :string
  end
end
