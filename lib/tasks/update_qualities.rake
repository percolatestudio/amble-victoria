namespace :db do
  desc "Recalculate the quality fields in place records"
  task :update_place_qualities => :environment do
    Place.find(:all).each { |p|
      p.set_qualities
      p.save!
    }
  end
end