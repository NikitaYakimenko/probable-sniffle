class Client < ApplicationRecord
  include ClientsHelper

  attribute :archived_at, :datetime
  attribute :archived_reason, :string
  attribute :restored_at, :datetime

  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, uniqueness: true
end
