module ProjectsSetupHelper
  def wizard_steps_header active_step
    # TODO: Output html and css required to show the wizard progress
    # TODO: Use states from state machine instead of duplicating list here
    steps = %w(about_you the_project location content agreement confirmation)
    idx = steps.index active_step
    steps[idx] = ">>" + steps[idx] + "<<"
    steps.join(", ")
  end
end