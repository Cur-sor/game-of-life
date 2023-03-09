require 'i18n'
def lang_config( )
    
    begin  
        
        default_file = File.read("./languages/default_language.json")
         
        default_data = JSON.parse(default_file)
       
        I18n.load_path += Dir[File.expand_path("./languages") + "/*.yml"] 
        
        I18n.default_locale = default_data['default']
       
    rescue => e
        puts "[Error LANGUAGE] " + e.message
    end
end