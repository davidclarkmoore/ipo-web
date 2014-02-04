# encoding: utf-8

class LoginImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :cover_size do
    process :resize_cover
  end

  version :profile_size do
    process :resize_profile
  end

  def resize_cover
    manipulate! format: "png" do |source|
      source.resize_to_fill(1050, 300)
    end 
  end

  def resize_profile
    manipulate! do |source|
      source.resize_to_fill(171, 171)
    end
  end

end
