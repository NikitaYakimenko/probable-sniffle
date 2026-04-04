require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { create(:client) }

  it 'is valid with valid attributes' do
    expect(client).to be_valid
  end
end
