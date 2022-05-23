class MainRawUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  def content_type_allowlist
    /image\//
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.character.user.no_hash_battletag}/#{model.character.realm.slug}/#{model.character.name}/main_raw"
  end

  #default image for inset images
  def default_url(*args)
    "https://s3.amazonaws.com/arpmory/uploads/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # version :zoomed do    
  #   process :zoom
  # end

  version :trimmed do    
    process :trim
    process :resize_to_fit_by_percentage => 0.55
    # process :resize_to_limit => [232, nil]
  end

private 

# def zoom
#   manipulate! do |img|
#       # img.resize 'x900' # resize to 140px high
#       pixels_to_remove = ((img[:width] - 620)/2).round # calculate amount to remove
#       img.shave "#{pixels_to_remove}x150" # shave off the sides
#       img.resize 'x600' # resize to 140px high

#     img # Returned image should be 180x140, cropped from the centre
#   end
# end

def resize_to_fit_by_percentage(percentage)
  resize_to_fit self.width*percentage, nil
end

def trim
  manipulate! do |img|
    test_image = img.clone
    test_image.trim
    if test_image.width < img.width || test_image.height < img.height
      test_image
    else
      img
    end
  end
end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
