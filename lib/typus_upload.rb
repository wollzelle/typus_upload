module TypusUpload
  require 'react-rails'
  require 'sprockets-coffee-react'
  require 'typus_upload/version'
  require 'typus_upload/engine'
  require 'typus_upload/class_methods'
  ActiveRecord::Base.extend(TypusUpload::ClassMethods)
end
