module ClientsHelper
  def archived
    !archived_at.nil?
  end
end
