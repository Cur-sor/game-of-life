require 'json'
require './domain/Metadata.rb'
require './domain/Matrix.rb'
require './languages/lang_config.rb'

lang_config( )

def getLifeMatrix ( configuration )
    raise FileNotFoundException.new(configuration.filepath) unless File.exists?(configuration.filepath)
    lines = getLines(configuration.filepath)
    integrityCheck(lines, configuration)
    metadata = getMetadata(lines, configuration)
    line_matrix = getLine_Matrix(lines, metadata)
    matrix = checkColumnsAndCharAndReturnMatrix(line_matrix, configuration, metadata)    
    puts I18n.t(:file_utils_check_Columns)
    puts I18n.t(:file_utils_check_Characters)
    return LifeMatrix.new( matrix,  metadata.generation)
end 

def getLines ( filepath )
    file = File.open(filepath, "r")
    contents = file.read
    lines = []
    contents.each_line do |line|
        line = line.chomp  # remove newline character at end of line
        lines << line
    end
    return lines
end

def integrityCheck(lines, configuration )
    raise StandardError.new(I18n.t(:file_utils_error_IsEmpty)) unless !lines.empty?
    puts I18n.t(:file_utils_check_Empty)
    raise StandardError.new(I18n.t(:file_utils_error_Not_Enough_Lines)) unless lines.length >= 2 + configuration.minimumY
    puts I18n.t(:file_utils_check_Lenght)
end

def getMetadata(lines, configuration)
    firstLine = lines[0]
    raise StandardError.new(I18n.t(:file_utils_error_FirstLineDoesNotMatch) + configuration.firstLine ) if !firstLine.match?(Regexp.new configuration.firstLine)
    generationNumber = firstLine.match(Regexp.new configuration.firstLine).captures.first.to_i
    puts I18n.t(:file_utils_Generation_Number_Is) + generationNumber.to_s    
    secondLine = lines[1]
    secondLinePattern = Regexp.new configuration.secondLine
    raise StandardError.new(I18n.t(:file_utils_error_SecondLineDoesNotMatch) + configuration.secondLine) if !secondLine.match?(secondLinePattern)
    height = secondLine.match(secondLinePattern).captures[0].to_i
    puts  I18n.t(:file_utils_Heigth_Is) + height.to_s
    width = secondLine.match(secondLinePattern).captures[1].to_i 
    puts  I18n.t(:file_utils_Width_Is) + width.to_s
    return Metadata.new(generationNumber,height,width)
end

def getLine_Matrix(lines, metadata)
    matrix = lines.slice(2,lines.length)
    raise StandardError.new(I18n.t(:file_utils_error_LineMismatch, deep_interpolation: true, found: matrix.length.to_s, declared: metadata.height.to_s )) unless matrix.length() >= metadata.height    
    puts I18n.t(:file_utils_check_Lines)
    return matrix
end


def checkColumnsAndCharAndReturnMatrix(lines,configuration, metadata) 
    len = lines[0].length()
    if (len < metadata.width )
        raise NotRectangular.new(I18n.t(:file_utils_error_ColumnMismatch, deep_interpolation: true, found: len.to_s, declared: metadata.width.to_s ))
    end
    exit = []
    line_counter = 0
    lines.each do |line|       
        if line.length() != len or line.length() < configuration.minimumX 
            raise NotRectangular.new(I18n.t(:file_utils_column_Error, deep_interpolation: true, min: configuration.minimumX.to_s, line: line_counter.to_s ))            
        end
        col_counter = 0
        exit_line = []
        line.each_char do |cell|          
            if cell != configuration.dead and cell != configuration.alive
                raise NotRectangular.new(I18n.t(:file_utils_error_CharacterMismatch, deep_interpolation: true, dead: configuration.dead.to_s, alive:  configuration.alive.to_s, line: (line_counter +1).to_s, col:(col_counter+1).to_s  ))    
            end
            col_counter += 1
            exit_line << cell
        end
        exit << exit_line.slice(0..metadata.width)
        line_counter += 1
    end
    exit.slice(0..metadata.height)
    return Matrix.new(exit,configuration.alive, configuration.dead)
end

def charCheckColumns(lines,configuration)
    lines.each do |line|       
        if line.length() != len or line.length() < configuration.minimumX 
            exit = counter
            break
        end
        y += 1
    end
end



class FileNotFoundException < StandardError
    def initialize(msg,  exception_type="custom")
      @exception_type = exception_type
      super("File " + msg + " not found")
    end
end

class NotRectangular < StandardError
    def initialize(msg,  exception_type="custom")
        @exception_type = exception_type
        super(msg)
      end
end

class NotRightChars < StandardError
    def initialize(msg,  exception_type="custom")
      @exception_type = exception_type
      super(msg)
    end
end
