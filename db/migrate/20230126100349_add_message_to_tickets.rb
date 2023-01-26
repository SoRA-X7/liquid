class AddMessageToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :message, :text
  end
end
