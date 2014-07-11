class SetDefaultValueToPayRegistration < ActiveRecord::Migration
  def up
    StudentApplication.where(pay_registration_fee: nil).each do |sa|
      sa.update_attribute(:pay_registration_fee, true)
    end
    change_column :student_applications, :pay_registration_fee, :boolean, default: true
  end

  def down
    change_column :student_applications, :pay_registration_fee, :boolean, default: nil
  end
end
