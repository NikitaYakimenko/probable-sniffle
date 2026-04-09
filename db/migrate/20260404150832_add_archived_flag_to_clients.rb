class AddArchivedFlagToClients < ActiveRecord::Migration[8.1]
  def change
    add_column :clients, :archived_at, :datetime
    add_column :clients, :archived_reason, :string
    add_column :clients, :restored_at, :datetime
  end
end
