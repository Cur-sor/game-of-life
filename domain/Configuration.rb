require 'json'
require './languages/lang_config.rb'

lang_config( )
class Configuration
    attr_accessor   :filepath, :minimumX, :minimumY, :alive, :dead,  :firstLine, :secondLine, :maxNumberOfEvolutionCycle, :refreshScreenInSeconds, :waitBeforeStartInSeconds

    def initialize(filepath, minimumX, minimumY, alive, dead, firstLine, secondLine, maxNumberOfEvolutionCycle,refreshScreenInSeconds,waitBeforeStartInSeconds)
        @filepath = filepath
        @minimumX = minimumX
        @minimumY = minimumY
        @alive = alive
        @dead = dead 
        @firstLine = firstLine
        @secondLine = secondLine
        @maxNumberOfEvolutionCycle = maxNumberOfEvolutionCycle
        @refreshScreenInSeconds = refreshScreenInSeconds
        @waitBeforeStartInSeconds = waitBeforeStartInSeconds
        validateState()
    end

    def validateState()
        #Check if there are more thant 2 numbers -> it is impossible to determine the Generation number.
        if filepath.nil? || filepath.empty?
            # "Configuration file must contain a not empty filepath"
            raise StandardError.new(I18n.t(:config_class_error_Empty_FilePath) )
        end
        if minimumX.nil? ||  !(minimumX.is_a? Numeric )
            # Configuration file must contain a not empty and numeric minimumX value, it indicates the minimum width of the matrix
            raise StandardError.new(I18n.t(:config_class_error_MinimumX) ) 
        end
        if minimumY.nil? ||  !(minimumY.is_a? Numeric )
            # Configuration file must contain a not empty and numeric minimumY value, it indicates the minimum height of the matrix
            raise StandardError.new(I18n.t(:config_class_error_Minimumy))
        end

        if refreshScreenInSeconds.nil? ||  !(refreshScreenInSeconds.is_a? Numeric )
            # Configuration file must contain a not empty and numeric refreshScreenInSeconds value, it indicates the refresh rate during matrix evolution
            raise StandardError.new(I18n.t(:config_class_error_RefreshScreenInSeconds))
        end

        if maxNumberOfEvolutionCycle.nil? ||  !(maxNumberOfEvolutionCycle.is_a? Numeric )
            # Configuration file must contain a not empty and numeric maxNumberOfEvolutionCycle value, it indicates the maximum number of evolution cycles of the matrix
            raise StandardError.new(I18n.t(:config_class_error_MaxNumberOfEvolutionCycle))
        end

        if waitBeforeStartInSeconds.nil? ||  !(waitBeforeStartInSeconds.is_a? Numeric )
            # Configuration file must contain a not empty and numeric waitBeforeStartInSeconds value.
            raise StandardError.new(I18n.t(:config_class_error_WaitBeforeStartInSeconds))
        end
        if @alive.nil? || @alive.empty?
            raise StandardError.new(I18n.t(:matrix_class_error_Alive_Symbol_NullOrEmpty) ) 
        else 
            if @alive.length >1 
                raise StandardError.new(I18n.t(:matrix_class_error_Alive_Symbol_LengthError) ) 
            end
        end
        if @dead.nil? || @dead.empty?
            raise StandardError.new(I18n.t(:matrix_class_error_Dead_Symbol_NullOrEmpty) ) 
        else 
            if @dead.length >1 
                raise StandardError.new(I18n.t(:matrix_class_error_Dead_Symbol_LengthError) ) 
            end
        end
        if firstLine.nil? || firstLine.empty?  
             # Configuration file must contain a not empty firstLine value
            raise StandardError.new(I18n.t(:config_class_error_FirstLineEmpty))             
        end
        if firstLine.count("/\d") >1
            # Configuration file must contain only one number in the firstLine regular expression
            raise StandardError.new(I18n.t(:config_class_error_FirstLineEmpty))  
        end
        if firstLine.count("/\d") == 0
            # Configuration file must contain one number in the firstLine regular expression
            raise StandardError.new(I18n.t(:config_class_error_FirstOneNumber) )  
        end
        if secondLine.nil? || secondLine.empty?  
            # Configuration file must contain a not empty secondLine value
            raise StandardError.new(I18n.t(:config_class_error_SecondLineEmpty))             
        end
        if secondLine.count("/\d") <2  
            # Configuration file must contain at least 2 number in the secondLine regular expression
            raise StandardError.new(I18n.t(:config_class_error_FirstLineLessThanTwoNumber))  
        end
   
    end

    def self.of(configuration_file_path)
        configuration_file = File.read(configuration_file_path)
        configuration_data = JSON.parse(configuration_file)
        return Configuration.new(configuration_data['filepath'],configuration_data['minimumX'],configuration_data['minimumY'],configuration_data['alive'],configuration_data['dead'], configuration_data['firstLine'],configuration_data['secondLine'], configuration_data['maxNumberOfEvolutionCycle'],configuration_data['refreshScreenInSeconds'],configuration_data['waitBeforeStartInSeconds'])
    end

end