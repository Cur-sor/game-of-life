class LoopControl

    attr_accessor   :history, :isloop


    def initialize()
        @history = []
        @isloop  = false
    end

    def addElement(matrix)
        matrix = matrix.dup
        if @history.include? matrix
            @isloop = true 
        else 
            @history << matrix    
        end
    end



end