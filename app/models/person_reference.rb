class PersonReference < ActiveRecord::Base
  belongs_to :reference
  belongs_to :referencer, polymorphic: true

  attr_accessible :reference_type, :contact_first_name, :contact_last_name,
                  :contact_email, :contact_phone, :contact_description, :reference_id

  before_save :save_contact

  delegate :first_name, :last_name, :email, :phone, :description, to: :reference, prefix: :contact, allow_nil: true

  def contact_first_name=(first_name)
    @first_name = first_name
  end
  
  def contact_last_name=(last_name)
    @last_name = last_name
  end
  
  def contact_email=(email)
    @email = email
  end

  def contact_phone=(phone)
    @phone = phone
  end

  def contact_description=(description)
    @description = description
  end

  def self.find_or_build_person_reference (person_references, type)
    person_references.find_by_reference_type(type) || person_references.build(reference_type: type)
  end

  private
  
  def save_contact
    return if reference_id.present?
    @contact = Reference.find_by_email(@email)
    if @contact.nil?
      @contact = Reference.new(email: @email, first_name: @first_name, 
        last_name: @last_name, phone: @phone, description: @description)
      @contact.save
    end
    self.reference = @contact
  end
end