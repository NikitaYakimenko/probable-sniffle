class Clients::Restore
  include ServiceHelper

  def initialize(client)
    @client = client
  end

  def self.call(client)
    new(client).perform
  end

  def perform
    if @client.archived_at.nil?
      return Success.new(@client)
    end

    ActiveRecord::Base.transaction do
      @client.update!(archived_at: nil, archived_reason: nil, restored_at: Time.current)

      Success.new(@client)
    rescue ActiveRecord::RecordInvalid => e
      Failure.new("Error when restoring: #{e.message}")
    end
  end
end
