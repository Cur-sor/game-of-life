require './languages/lang_config.rb'

lang_config( )
class  Metadata

    attr_accessor :generation, :height, :width

    def initialize(generation, height, width)
        @generation = generation
        @height = height
        @width = width
    end

    def validateState()
        if generation.nil? ||  !(generation.is_a? Numeric )
            # Metadata must contain a not empty and numeric generation value
            raise StandardError.new(I18n.t(:metadata_class_error_Generation)) 
        end
        if height.nil? ||  !(height.is_a? Numeric )
            # Metadata must contain a not empty and numeric height value
            raise StandardError.new( I18n.t(:metadata_class_error_Height)) 
        end
        if width.nil? ||  !(width.is_a? Numeric )
            # Metadata must contain a not empty and numeric width value
            raise StandardError.new(I18n.t(:metadata_class_error_Width) ) 
        end
    end

end