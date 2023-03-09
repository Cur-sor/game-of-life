 # Game of Life

This is my first Ruby Project.

I've never used Ruby before, and I've spent no more than few hours/day in the past 6 days to learn it so, please, be kind :D.

## Run

if, like me, you are not familiar with ruby, the first thing to do is to download libraries (gems). 

So please type :

`bundle install`

Then just for test open a console and type:

`ruby Main.rb`

It will use a file in the *data_example* directory.

## Config 

You can configure the file to use and other parameters by simply editing the config.json file.

Parameters are :

 -  **filepath** :  the data file path  e.g. *"./data_example/matrix2.txt"*
 - **minimumX** :  The minimum number of columns. e.g. *4*  
 - **minimumY** : The minimum number of rows. e.g. *4* 
 - **alive**: The character used to mark an alive cell. e.g. *"*"*
 - **dead**: The character used to mark an dead cell. e.g. *"."*
 - **firstLine**: The RegEx expression to parse the first line of file in order to get the generation number. 
		 e.g. *"^Generation (\\d+):$"*
 - **secondLine**: The RegEx expression to parse the second line of file in order to get the number of columns and rows.
	e.g. *"(\\d+) (\\d+)"*
 - **maxNumberOfEvolutionCycle** : Maximum number of evolution cycle. This is to prevent eternal loops. e.g. *50*
 - **refreshScreenInSeconds** : The refresh rate (seconds) during the display of evolution. e.g. *0.2*
 - **waitBeforeStartInSeconds**: The time to wait before the evolution process starts. e.g. *2*

## Internazionalization

I've used i18n for internationalization.

I've implemented english and italian languages.

You can change language just editing the file *default_language.json* in the *language* directory.

The .yml files, in the *language* directory, contain translations needed.

## Test Unit
I've implemented a test unit. 

`ruby TestUnit.rb`

Test unit does NOT use the config.json file in the main folder, instead it uses its own.

You can find this file in the *test_file* folder. Its name is *configtest.json.*

What did I test?


 - Classes method and constructors ...
 - Functions ..
 - Error check for malformed file.  All "test_matrix_error_*" files are used for this reason
 - Game Rules using known lifeforms. From Still Life to Spaceship as described here [Game Of Life Wiki](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
	All "test_*_matrix_*" files are used for this reason.