task :pre_commit => [:core_pre_commit, :rails_pre_commit, :rails_demo_pre_commit, :ok_to_commit ]

task :core_pre_commit do
  Dir.chdir 'rspec' do    
    IO.popen("rake pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
  end
  raise "RSpec Core pre_commit failed" if $? != 0
end

task :rails_pre_commit do
  Dir.chdir 'rspec_on_rails' do    
    IO.popen("rake pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
    raise "RSpec on Rails pre_commit failed" if $? != 0
  end
end

task :rails_demo_pre_commit do
  Dir.chdir 'rspec_on_rails_demo' do    
    IO.popen("rake pre_commit --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
    raise "RSpec on Rails Demo pre_commit failed" if $? != 0
  end
end

task :ok_to_commit do |t|
  puts "OK TO COMMIT"
end
