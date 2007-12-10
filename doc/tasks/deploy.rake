
require 'rake/contrib/sshpublisher'

namespace :deploy do

  desc 'deploy to the server using rsync'
  task :rsync do
    cmd = "rsync #{SITE.rsync_args.join(' ')} "
    cmd << "#{SITE.output_dir}/ #{SITE.host}:#{SITE.remote_dir}"
    sh cmd
  end

  desc 'deploy to the server using ssh'
  task 'ssh' do
    Rake::SshDirPublisher.new(
        SITE.host, SITE.remote_dir, SITE.output_dir
    ).upload
  end

end  # deploy

# EOF
