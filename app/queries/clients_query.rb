class ClientsQuery
  def self.all
    clients = Client.all

    clients
  end

  def self.archived
    clients = Client.where(archived_at: !nil)

    clients
  end
end
