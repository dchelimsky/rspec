
if HAVE_HEEL

namespace :heel do

  desc 'start the heel server to view website (not for Windows)'
  task :start do
    sh "heel --root #{SITE.output_dir} --daemonize"
  end
  
  desc 'stop the heel server'
  task :stop do
    sh "heel --kill"
  end

  task :autorun do
    heel_exe = File.join(Gem.bindir, 'heel')
    @heel_spawner = Spawner.new(Spawner.ruby, heel_exe, '--root', SITE.output_dir, :pause => 86_400)
    @heel_spawner.start
  end

  task :autobuild => :autorun do
    at_exit {@heel_spawner.stop if defined? @heel_spawner and not @heel_spawner.nil?}
  end

end

task :autobuild => 'heel:autobuild'

end  # HAVE_HEEL

# EOF
