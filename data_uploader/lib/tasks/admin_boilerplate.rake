namespace :db do
  namespace :admin_boilerplate do
    desc 'Creates boilerplate for admin panel (does not create duplicates and removes obsolete objects)'
    task create: :environment do
      Rake::Task['db:platforms:create'].invoke
      Rake::Task['db:sections:create'].invoke
      Rake::Task['db:datasets:create'].invoke
      puts 'All done!'
    end

    desc 'Clears all boilerplate'
    task clear_all: ['db:datasets:clear_all', 'db:sections:clear_all', 'db:platforms:clear_all']
  end
end
