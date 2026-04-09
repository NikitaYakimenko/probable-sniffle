class Api::ClientsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_client, only: %i[ show update archive restore destroy ]

  def index
    @clients = Client.all

    render json: @clients, each_serializer: Api::ClientSerializer
  end

  def archived
    @clients = Client.where(archived_at: !nil)

    render json: @clients, each_serializer: Api::ClientSerializer
  end

  def show
    render json: @client, serializer: Api::ClientSerializer
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.json { render json: Api::ClientSerializer.new(@client).to_json, status: :created }
      else
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.json { render json: Api::ClientSerializer.new(@client).to_json, status: :ok }
      else
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    result = Clients::Archive.call(@client, params[:archive_reason])

    respond_to do |format|
      if result.successful?
        format.json { render json: Api::ClientSerializer.new(@client).to_json, status: :ok }
      else
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def restore
    result = Clients::Restore.call(@client)

    respond_to do |format|
      if result.successful?
        format.json { render json: Api::ClientSerializer.new(@client).to_json, status: :ok }
      else
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_client
    @client = Client.find(params.expect(:id))
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :email, :password, :archive_reason)
  end
end
