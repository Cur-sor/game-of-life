require 'json'
require 'i18n'
require './domain/Configuration.rb'
require './utils/FileUtils.rb'
require './utils/ScreenUtils.rb'
require './domain/LifeMatrix.rb'
require './domain/LoopControl.rb'
require './languages/lang_config.rb'

lang_config()

print I18n.t(:initiatializing)
configuration_file_path = "config.json"
wait = 2

begin 
    # Initiatializing ....
    configuration = Configuration.of(configuration_file_path)
rescue Errno::ENOENT    
    # The file config.json was not found in the application path
    puts "\n" + I18n.t(:configFileNotFound, deep_interpolation: true, configuration_file_path: configuration_file_path )
rescue => e
    puts I18n.t(:genericError) + e.message
else
    print puts I18n.t(:ok)+"\n"
    puts I18n.t(:fileToParse) + configuration.filepath
    begin   
        lifeMatrix = getLifeMatrix(configuration)
        puts I18n.t(:separator)
        puts I18n.t(:currentGeneration)       
        lifeMatrix.printMe() 
        puts  I18n.t(:starting_In_Seconds, deep_interpolation: true, seconds: configuration.waitBeforeStartInSeconds.to_s )
        sleep configuration.waitBeforeStartInSeconds
        puts I18n.t(:separator)
        puts I18n.t(:futureGeneration)            
        counter = 0
        loopControl = LoopControl.new()
        while counter < configuration.maxNumberOfEvolutionCycle && !lifeMatrix.isADeadZone() && !loopControl.isloop
            clearScreen()
            lifeMatrix.evolve()
            lifeMatrix.printMe()
            loopControl.addElement(lifeMatrix.matrix)
            sleep configuration.refreshScreenInSeconds
            counter = counter + 1
        end
        puts I18n.t(:separator)
        if lifeMatrix.isADeadZone()
            # No living cells detected in the matrix
            puts  I18n.t(:matrixIsDead) 
        end
        if counter == configuration.maxNumberOfEvolutionCycle 
            # The maximum number of evolution cycles expected have been performed
            puts I18n.t(:maxNumberOfEvolutionCycle) + configuration.maxNumberOfEvolutionCycle.to_s
        end
        if loopControl.isloop 
            # The cycle of evolution has been interrupted because it has entered a loop.
            puts I18n.t(:isALoop) + lifeMatrix.generation.to_s
        end
    rescue FileNotFoundException => fnf
        puts I18n.t(:genericError) + fnf.message
    rescue NotRectangular => nrs
        puts I18n.t(:genericError) + nrs.message
    rescue NotRightChars => nrc
        puts I18n.t(:genericError) + nrc.message        
    end
end

