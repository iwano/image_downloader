namespace :feeds do
  desc "Update feeds"
  task :update => :environment do
    Entry.update_feeds
  end
end