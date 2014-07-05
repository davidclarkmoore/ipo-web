module ProjectsSetupHelper
  def wizard_steps_header active_step
    # TODO: Output html and css required to show the wizard progress
    # TODO: Use states from state machine instead of duplicating list here
    steps = %w(about_you the_project location content agreement confirmation)
    idx = steps.index active_step
    steps[idx] = ">>" + steps[idx] + "<<"
    steps.join(", ")
  end

  def currency_options(selected = nil)
    options_from_collection_for_select(currencies, :last, :first, selected)
  end

  def currencies 
    currencies = ::Money::Currency.table.map  do |code, details|
      iso = details[:iso_code]
      ["#{details[:name]} (#{iso})", iso]
    end
  end
end