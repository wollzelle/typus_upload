module TypusUpload
  module ClassMethods

    def extended_modules
      (class << self; self end).included_modules
    end

    def typus_upload(*args)
      cattr_accessor :typus_upload_options, :typus_upload_fields
      self.typus_upload_fields  ||= []
      self.typus_upload_options ||= {}

      options = args.extract_options!

      args.each do |field|
        self.typus_upload_fields << field
        self.typus_upload_options[field] = options
        serialize field
      end

      extend TemplateMethods unless extended_modules.include?(TemplateMethods)
    end
  end

  module TemplateMethods
    def typus_template(attribute)
      if self.typus_upload_fields.include? attribute.to_sym
        'upload'
      else
        super(attribute)
      end
    end
  end
end