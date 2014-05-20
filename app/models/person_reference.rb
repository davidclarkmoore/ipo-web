class PersonReference < ActiveRecord::Base
  belongs_to :reference
  belongs_to :referencer, polymorphic: true

  attr_accessible :reference_type, :contact_first_name, :contact_last_name,
                  :contact_email, :contact_phone, :contact_description, :reference_id

  before_save :save_contact

  accepts_nested_attributes_for :reference

  def contact_first_name=(first_name)
    @first_name = first_name
  end

  def contact_first_name
    reference.first_name if reference
  end
  
  def contact_last_name=(last_name)
    @last_name = last_name
  end

  def contact_last_name
    reference.last_name if reference
  end
  
  def contact_email=(email)
    @email = email
  end

  def contact_email
    reference.email if reference
  end

  def contact_phone=(phone)
    @phone = phone
  end

  def contact_phone
    reference.phone if reference
  end

  def contact_description=(description)
    @description = description
  end

  def contact_description
    reference.description if reference
  end 

  private
  
  def save_contact
    @contact = Reference.find_by_email(@email)
    if @contact.nil?
      @contact = Reference.new(email: @email, first_name: @first_name, last_name: @last_name)
      @contact.save
    end
    self.reference = @contact
  end
end