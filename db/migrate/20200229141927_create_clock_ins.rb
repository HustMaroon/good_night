class CreateClockIns < ActiveRecord::Migration[6.0]
  def change
    create_table :clock_ins do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_time
      t.datetime :wakeup_time
      t.float :clocked_in_time

      t.timestamps
    end
  end
end
