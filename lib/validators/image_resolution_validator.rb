# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Validators
  class ImageResolutionValidator < ActiveModel::Validator
    def validate(record)
      image = record.image
      
      if image.respond_to?(:width) && image.width < Settings.images.minimum_width.to_i
        record.errors[:image] << ::I18n.t('too_smaller',
          :scope => 'activerecord.errors.models.refinery/image',
          :dimension => :width ,:size => Settings.images.minimum_width.to_i)
      end
      if image.respond_to?(:height) && image.height < Settings.images.minimum_height.to_i
        record.errors[:image] << ::I18n.t('too_smaller',
          :scope => 'activerecord.errors.models.refinery/image',
          :dimension => :height ,:size => Settings.images.minimum_height.to_i)
      end
    end
  end
end
