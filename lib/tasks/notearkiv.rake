namespace :notearkiv do
  desc 'Perform a full reindex of the system'
  task reindex: :environment do
    Note.full_reindex
    Evensong.full_reindex
  end

end
