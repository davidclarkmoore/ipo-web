Refinery::Image.class_eval do
  validates_with Validators::ImageResolutionValidator
  
end
