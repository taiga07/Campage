class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :phone_number, :null => false
      t.text :body, :null => false
      t.timestamps
    end
  end
end
