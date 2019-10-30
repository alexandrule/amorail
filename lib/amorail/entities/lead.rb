module Amorail
  # AmoCRM lead entity
  class Lead < Amorail::Entity
    amo_names 'leads'

    amo_field :name, :price, :status_id, :tags, :pipeline_id, :responsible_user_id, :created_user_id, :date_create, :date_close, :main_contact_id
    amo_property :custom_fields
    
    validates :name, :status_id, presence: true

    def reload
      @contacts = nil
      super
    end

    # Return list of associated contacts
    def contacts
      fail NotPersisted if id.nil?
      @contacts ||=
        begin
          links = Amorail::ContactLink.find_by_leads(id)
          links.empty? ? [] : Amorail::Contact.find_all(links.map(&:contact_id))
        end
    end
  end
end
