require 'i18n'

require './languages/lang_config.rb'

lang_config( )

class Matrix

    attr_accessor   :matrix, :alive, :dead 
    

    def initialize(matrix, alive, dead)
        @matrix = matrix
        @alive = alive
        @dead = dead
        validateState()
    end

    def validateState()
        if @matrix.nil? || @matrix.empty?
            # Matrix can not be empty or null
            raise StandardError.new(I18n.t(:matrix_class_error_Matrix_NullOrEmpty)) 
        end
        if @alive.nil? || @alive.empty?
            # Matrix must contain a not empty alive value
            raise StandardError.new(I18n.t(:matrix_class_error_Alive_Symbol_NullOrEmpty) ) 
        else 
            if @alive.length >1 
                # Matrix must contain single char for alive value
                raise StandardError.new(I18n.t(:matrix_class_error_Alive_Symbol_LengthError) ) 
            end
        end
        if @dead.nil? || @dead.empty?
            # Matrix must contain a not empty dead value
            raise StandardError.new(I18n.t(:matrix_class_error_Dead_Symbol_NullOrEmpty) ) 
        else 
            if @dead.length >1 
                # Matrix must contain single char for dead value
                raise StandardError.new(I18n.t(:matrix_class_error_Dead_Symbol_LengthError) ) 
            end
        end
       
    end

    def getHeigth()
        return matrix.length
    end

    def getWidth()
        return matrix[0].length
    end

    def getNeighbors(x,y)
        neighbors = []
        (-1..1).each do |i|
            (-1..1).each do |j|
                if (x + i >= 0 && x + i < matrix.length) && (y + j >= 0 && y + j < matrix[0].length)
                neighbors << matrix[x+i][y+j]
                end
            end
        end
        neighbors.delete_at(neighbors.index(matrix[x][y]))               
       
        return neighbors            
    end

    def cellDestiny (status, deads, alives)
        exit = status
       
        if (status == alive)
            if (alives < 2) 
                exit = dead
            end
            if (alives > 3) 
                exit = dead
            end
        else
            if alives == 3
                exit = alive
            end
        end
        return exit
    end

    def getNextGeneration ()
        exit = []
        ylen = matrix.length-1
         
        (0..ylen).each do |y|
            newline = []
            xlen = matrix[y].length-1
             
            (0..xlen).each do |x|
                 
                neighbors = getNeighbors(y,x)
                deads = neighbors.count(dead)                
                alives = neighbors.count(alive)
              
                newline << cellDestiny(matrix[y][x],deads,alives)               
            end
            exit << newline
        end
        return  Matrix.new(exit,  alive,  dead )
    end

    def printMe ()    
        heigth = getHeigth()
        width = getWidth()
        (0..heigth-1).each do |y|
            (0..width-1).each do |x|
                print matrix[y][x].to_s
            end
            print "\n"
        end
    end

    def isADeadZone()
        heigth = getHeigth()
        width = getWidth()
        exit = true
        (0..heigth-1).each do |y|
            (0..width-1).each do |x|
                if matrix[y][x] == alive
                    return false
                end
            end
        end
        return exit
    
    end


    def ==(other)
        self.alive == other.alive &&
        self.dead == other.dead &&
        self.matrix == other.matrix
    end

    


end