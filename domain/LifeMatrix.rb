require './domain/Matrix.rb'
require './languages/lang_config.rb'

lang_config( )

class LifeMatrix

    attr_accessor   :matrix,  :generation

    def initialize(matrix, generation)
        @matrix = matrix
        @generation = generation
        validateState()
    end

    def validateState()
        if matrix.nil? || !(matrix.instance_of? Matrix)
            # Matrix can not be empty or null
            raise StandardError.new(I18n.t(:lifeMatrix_class_error_MatrixEmptyOrNull)) 
        end
        if generation.nil? ||  !(generation.is_a? Numeric )
            # LiveMatrix must contain a not empty and numeric generation value
            raise StandardError.new(I18n.t(:lifeMatrix_class_error_Generation)) 
        end
    end
 
    def evolve () 
        @matrix= @matrix.getNextGeneration()
        @generation =  @generation + 1
    end

    def isADeadZone()
        return matrix.isADeadZone()
    end

    def printMe () 
        puts I18n.t(:lifeMatrix_class_generation) + generation.to_s + ":"
        puts matrix.getHeigth().to_s + " " + matrix.getWidth().to_s
        matrix.printMe()
    end

    def ==(other)
        self.generation  == other.generation &&
        self.matrix == other.matrix
    end

end    