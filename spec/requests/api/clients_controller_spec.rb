require 'rails_helper'

RSpec.describe Api::ClientsController, type: :request do
  let(:client_params) { attributes_for(:client) }
  let(:invalid_params) { { invalid_paramenter: Faker::Lorem.words.sample } }

  describe '/api/clients' do
    it 'returns accounts list' do
      create :client
      get api_clients_url

      expect(response).to be_successful
      expect(response.status).to be 200
    end

    it 'creates new client' do
      expect { post api_clients_url, params: client_params, as: :json }.to change { Client.count }.by(1)

      expect(response).to be_successful
      expect(response.status).to be 201
    end

    it 'does not create new client with invalid data' do
      expect { post api_clients_url, params: invalid_params, as: :json }.not_to change { Client.count }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '/api/clients/archived' do
    it 'returns archived accounts list' do
      create :client, :archived
      get archived_api_clients_url

      expect(response).to be_successful
      expect(response.status).to be 200
    end
  end

  describe '/api/clients/:id' do
    let(:client) { create :client }

    it 'returns a client' do
      get api_client_url(id: client.id)

      expect(response).to be_successful
      expect(response.status).to be 200
    end

    it 'does not return a not found client' do
      client.destroy!
      get api_client_url(id: client.id)

      expect(response).to have_http_status(:not_found)
    end

    it 'updates a client' do
      patch api_client_url(id: client.id), params: client_params, as: :json

      expect(response).to be_successful
      expect(response.status).to be 200
    end

    it 'does not update a client with invalid data' do
      patch api_client_url(id: client.id), params: invalid_params, as: :json

      expect(response).to have_http_status(:bad_request)
    end

    it 'does not update a not found client' do
      client.destroy!
      patch api_client_url(id: client.id), params: client_params, as: :json

      expect(response).to have_http_status(:not_found)
    end

    it 'destroys a client' do
      client
      expect { delete api_client_url(id: client.id), as: :json }.to change { Client.count }.by(-1)

      expect(response).to be_successful
      expect(response.status).to be 204
    end

    it 'does not destroy a not found client' do
      client.destroy!
      get api_client_url(id: client.id)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe '/api/client/:id/archive' do
    let(:client) { create :client }
    let(:archive_params) { { archive_reason: 'some reason' } }

    it 'archives a client' do
      patch archive_api_client_url(id: client.id), params: archive_params, as: :json

      expect(response).to be_successful
      expect(response.status).to be 200
    end

    it 'does not archive a client w/o archive reason' do
      patch archive_api_client_url(id: client.id), params: invalid_params, as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'does not archive a not found client' do
      client.destroy!
      patch archive_api_client_url(id: client.id), params: archive_params, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end
end
