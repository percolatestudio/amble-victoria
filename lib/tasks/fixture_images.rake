namespace :db do
  namespace :fixtures do
    desc "Load fixtures with images into database using paperclip plugin"
    task :load_with_images => :load do
      require 'active_record/fixtures'
      require 'action_controller/test_process'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      Paperclip.options[:log_commands] = true
      
      images = Dir.glob File.join(RAILS_ROOT, 'test', 'fixtures', 'files', 'images', '*')
      images.each { |image_file|
        name = File.basename(image_file, File.extname(image_file))
        hash = Fixtures.identify(name)
        
        i = Image.find(hash)
        i.image = ActionController::TestUploadedFile.new(image_file, nil, true)
        i.image.reprocess!
        i.save
      }
    end
  end
end