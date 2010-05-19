#These rake tasks use the yuicompressor to compress (and lightly obfuscate) 
#javascript and css files.  They're run automatically from our capistrano
#build/deployment process
namespace :obfuscate do 
  
  task :js => :environment do
    basedir = "public/javascripts"
    exclude_files = []
    
    obfuscate_dir(basedir, exclude_files, "js")  
  end
  
  task :css => :environment do
    basedir = "public/stylesheets"
    exclude_files = []
    
    obfuscate_dir(basedir, exclude_files, "css")  
  end
end

def obfuscate_dir(dir, exclude_files, type)
  puts "obfuscating #{type} files in dir: #{dir}"
  Dir.glob("#{dir}/**/*.#{type}").each {|f|
    unless exclude_files.include?(f)
      obfuscate(f, type)
    end
  }  
end
  
#file is the path to a file
#type is a file type (currently "js" or "css")
def obfuscate(file, type)
  puts "\t#{file}"
  FileUtils.mv(file, file + ".preObs")
  
  begin
    raise unless system("java -jar \"vendor/util/yuicompressor/yuicompressor-2.4.2.jar\" --type #{type} #{file + ".preObs"} > #{file}")    
  rescue
    FileUtils.mv(file + ".preObs", file)
    raise "failed to obfuscate file!"
  end
  
  FileUtils.rm(file + ".preObs")
end