require './domain/Configuration.rb'
require './utils/FileUtils.rb'
require './domain/LifeMatrix.rb'
require './domain/Metadata.rb'
require 'test/unit'
require './languages/lang_config.rb'


class TestSimpleNumber < Test::Unit::TestCase
    
    self.test_order = :defined

    @@test_folder = "./test_files/"
    @@config_test_file = @@test_folder +"configtest.json"
    @@test_matrix_error_file_name = "test_matrix error_"
    @@test_matrix_error_file_ext = ".txt"
    @@test_matrix_errors =  [
        ["1","Check for Not Rectangular Matrix Error"],
        ["2","Check for Not Right Chars in Matrix Error"],
        ["3","Check for Not Right Column Number Error"],
        ["4","Check for Not Right Row Number Error"],
        ["5","Check for Not Right Generation Number Error"],
        ["6","Check for Not Right Matrix size Error"],
    ]
    @@test_matrix_known_life_form_file_beging = "test_"
    @@test_matrix_known_life_form_file_end = "_matrix_"
    @@test_matrix_known_life_form_file_ext = ".txt"
    @@test_matrix_known_life_form =  [
        ["still_life","Check if a still life figure remains the same"],
        ["oscillator","Check if an oscillator figure oscillates"],
        ["spaceship","Check if a spaceship figure evolve as expected"]
    ]
    @@delimiter = "-------------"
    @@bigdelimiter = "-----------------------------------------------------------------------------"


    def test_configuration_class()
    
        puts @@bigdelimiter
        print @@delimiter + "-> test_configuration_class "
        assert_raise(StandardError) {Configuration.new("", 1, 1, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new(nil, 1, 1, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", "", 1, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", "a", 1, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", nil, 1, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 1, "", "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 1, "a", "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 1, nil, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, nil,".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",nil, "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*","", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "","(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", nil,"(\\d+) (\\d+)",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) ",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","",100,0.2,2)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$",nil,100,0.2,2)}      
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",nil,0.2,2)}            
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)","",0.2,2)}               
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)","a",0.2,2)}      
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,nil,2)}          
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,"",2)}          
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,"a",2)}          
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,nil)}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,"")}
        assert_raise(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,"a")}
        assert_nothing_raised(StandardError) {Configuration.new("matrix.txt", 4, 4, "*",".", "^Generation (\\d+):$","(\\d+) (\\d+)",100,0.2,2)}          
        print "...ok\n"
    end

    def test_load_configuration_from_test_file()
        puts @@bigdelimiter
        print @@delimiter + "-> test_load_configuration_from_test_file "
        assert_equal(true,File.exists?(@@config_test_file))
        assert_nothing_raised(StandardError) {configuration = Configuration.of(@@config_test_file)}         
        print "...ok\n"
         
    end

    def test_matrix_instantiation() 
        puts @@bigdelimiter
        print @@delimiter + "-> test_matrix_instantiation BEGIN"
        matrix = [[".",".",".",".","."],[".",".","*",".","."],[".",".","*",".","."],[".",".","*",".","."],[".",".",".",".","."]]
        assert_raise(StandardError) {Matrix.new([], "*", ".")}
        assert_raise(StandardError) {Matrix.new(nil, "*", ".")}
        assert_raise(StandardError) {Matrix.new(matrix, "", ".")}
        assert_raise(StandardError) {Matrix.new(matrix, nil, ".")}
        assert_raise(StandardError) {Matrix.new(matrix, "*", "")}
        assert_raise(StandardError) {Matrix.new(matrix, "*", nil)}
        assert_raise(StandardError) {Matrix.new(matrix, "*21", ".")} 
        assert_raise(StandardError) {Matrix.new(matrix, "*", ".---")} 
        
        assert_nothing_raised(StandardError) {Matrix.new(matrix, "*", ".")}            
        print "...ok\n"
         
    end

    def test_lifeMatrix_instantiation() 
        puts @@bigdelimiter
        print @@delimiter + "-> test_lifeMatrix_instantiation BEGIN"
        array_matrix = [[".",".",".",".","."],[".",".","*",".","."],[".",".","*",".","."],[".",".","*",".","."],[".",".",".",".","."]]
        matrix = Matrix.new(array_matrix, "*", ".")
        assert_raise(StandardError) {LifeMatrix.new(nil,   1)}
        assert_raise(StandardError) {LifeMatrix.new(matrix,   nil)}
        assert_raise(StandardError) {LifeMatrix.new(matrix,   "")}
        assert_nothing_raised(StandardError) {LifeMatrix.new(matrix,   1)}            
        print "...ok\n"
         
    end

    def test_load_matrix_file()
        puts @@bigdelimiter
        puts @@delimiter + "-> test_load_matrix_file BEGIN"
        configuration = Configuration.of(@@config_test_file)
        puts @@delimiter
        assert_nothing_raised(StandardError) {
            matrix = getLifeMatrix(configuration)
        }    
        puts "Matrix file with no error load...ok"
        @@test_matrix_errors.each { |error_test| 
            puts @@delimiter
            configuration.filepath = @@test_folder + @@test_matrix_error_file_name + error_test[0].to_s + @@test_matrix_error_file_ext
            assert_raise() {getLifeMatrix(configuration)}
            puts error_test[1] +"..ok\n"
        }                 
        puts @@delimiter + "-> test_load_matrix_file END"
    end

    def test_LiveMatrix_Neighbors()
        puts @@bigdelimiter
        puts @@delimiter + "-> test_LiveMatrix_Neighbors BEGIN"
        configuration = Configuration.of(@@config_test_file)
        matrix = getLifeMatrix(configuration).matrix
        puts @@delimiter
        result = [".",".","."]
        assert_equal(result,matrix.getNeighbors(0,0))
        assert_equal(result,matrix.getNeighbors(6,16))
        assert_equal(result,matrix.getNeighbors(0,16))
        assert_equal(result,matrix.getNeighbors(6,0))
        puts "Neightbors vertex test...ok"
        result = [".",".",".",".","."]
        assert_equal(result,matrix.getNeighbors(0,1))
        assert_equal(result,matrix.getNeighbors(5,16))
        assert_equal(result,matrix.getNeighbors(0,5))
        result = [".",".",".","*","."]
        assert_equal(result,matrix.getNeighbors(1,16))
        puts "Neightbors side test...ok" 
        result = ["*", ".", "*", ".", ".", ".", ".", "."]
        assert_equal(result,matrix.getNeighbors(4,5))
        puts "Neightbors middle test...ok"
        puts @@delimiter + "-> test_LiveMatrix_Neighbors END"
    end

    def test_LiveMatrix_evolution()
        ##FARE UNA FUNZIONE CHE MI TESTA LE COSE COSÌ DA RENDE PIÙ USABILE
        puts @@bigdelimiter
        puts @@delimiter + "-> test_LiveMatrix_evolution BEGIN"
        @@test_matrix_known_life_form.each { |life_test| 
            puts @@delimiter
            file_input = @@test_folder + @@test_matrix_known_life_form_file_beging + life_test[0].to_s + @@test_matrix_known_life_form_file_end + "input" + @@test_matrix_known_life_form_file_ext
            file_output = @@test_folder + @@test_matrix_known_life_form_file_beging + life_test[0].to_s + @@test_matrix_known_life_form_file_end + "output" + @@test_matrix_known_life_form_file_ext
            configuration_input = Configuration.of(@@config_test_file)
            configuration_output = Configuration.of(@@config_test_file)
            configuration_input.filepath = file_input
            configuration_output.filepath = file_output
            matrix_to_test = getLifeMatrix(configuration_input)
            matrix_to_test.evolve()
            matrix_for_confirm = getLifeMatrix(configuration_output)
            assert_equal(matrix_for_confirm,matrix_to_test )
            puts life_test[1] +"..ok\n"
        }         
        puts @@delimiter + "-> test_LiveMatrix_evolution END"
        
    end

end
