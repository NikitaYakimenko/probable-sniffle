class Clients::Archive
  include ServiceHelper

  def initialize(client, archive_reason)
    @client = client
    @archive_reason = archive_reason
  end

  def self.call(client, archive_reason)
    new(client, archive_reason).perform
  end

  def perform
    if @client.archived
      return Success.new(@client)
    end

    return Failure.new("Archive reason is required") if @archive_reason.blank?

    ActiveRecord::Base.transaction do
      @client.update!(archived_at: Time.current, archived_reason: @archive_reason)

      Success.new(@client)
    rescue ActiveRecord::RecordInvalid => e
      Failure.new("Error when archiving: #{e.message}")
    end
  end
end
