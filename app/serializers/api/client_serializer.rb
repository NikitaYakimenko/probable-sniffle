class Api::ClientSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :archived, :archived_at, :archived_reason, :created_at, :updated_at
end
