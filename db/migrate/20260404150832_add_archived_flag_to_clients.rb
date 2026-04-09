class AddArchivedFlagToClients < ActiveRecord::Migration[8.1]
  def change
    add_column :clients, :archived_at, :datetime
    add_column :clients, :archived_reason, :string
  end

  # def down
  #   remove_column :clients, :archived_at
  #   remove_column :clients, :archived_reason
  # end
end
