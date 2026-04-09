require 'rails_helper'

RSpec.describe Clients::Restore, :unit do
  let(:client) { create :client }
  let(:archived_client) { create :client, :archived }

  it 'restores a client' do
    result = described_class.call(archived_client)
    archived_client.reload

    expect(result).to be_successful
    expect(archived_client.archived).to be false
    expect(archived_client.archived_reason).to be nil
    expect(archived_client.restored_at).not_to be nil
  end

  it 'does not restore an non-archived client' do
    initial_updated_at = client.updated_at.to_datetime

    result = described_class.call(client)
    client.reload

    expect(result).to be_successful
    expect(client.updated_at.to_datetime).to eq initial_updated_at
  end

  it 'does not restore a client with invalid data' do
    allow(archived_client).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(archived_client))
    result = described_class.call(archived_client)

    expect(result).to be_failed
    expect(result.error).to eq 'Error when restoring: Validation failed: '
  end
end
