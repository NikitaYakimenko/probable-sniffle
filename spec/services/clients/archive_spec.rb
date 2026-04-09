require 'rails_helper'

RSpec.describe Clients::Archive, :unit do
  let(:client) { create :client }
  let(:archived_client) { create :client, :archived }
  let(:archive_reason) { 'some reason' }

  it 'archives a client' do
    result = described_class.call(client, archive_reason)
    client.reload

    expect(result).to be_successful
    expect(client.archived).to be true
    expect(client.archived_reason).to eq archive_reason
  end

  it 'does not archive an archived client' do
    initial_updated_at = archived_client.updated_at
    initial_archived_at = archived_client.archived_at
    initial_archive_reason = archived_client.archived_reason

    result = described_class.call(archived_client, archive_reason)
    archived_client.reload

    expect(result).to be_successful
    expect(archived_client.archived_at).to eq initial_archived_at
    expect(archived_client.archived_reason).to eq initial_archive_reason
    expect(archived_client.updated_at).to eq initial_updated_at
  end

  it 'does not archive a client with invalid data' do
    allow(client).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(client))

    result = described_class.call(client, 123)
    client.reload

    expect(result).to be_failed
    expect(result.error).to eq 'Error when archiving: Validation failed: '
  end

  it 'does not archive a client w/o archive reason' do
    result = described_class.call(client, nil)
    client.reload

    expect(result).to be_failed
    expect(result.error).to eq 'Archive reason is required'
  end
end
