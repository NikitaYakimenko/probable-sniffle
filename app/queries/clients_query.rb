class ClientsQuery
  def self.archived
    clients = Client.where(archived_at: !nil)

    clients
  end
end
