module PreCommit
  class RspecOnRails
    attr_reader :actor
    def initialize(actor)
      @actor = actor
    end

    def pre_commit
      dir = File.dirname(__FILE__)
      railses = File.expand_path("#{dir}/../../../example_rails_app/vendor/rails")
      used_railses = []
      Dir["#{railses}/*"].reverse.each do |rails_dir|
        rails_version = rails_dir[railses.length+1..-1]
        ENV['RSPEC_RAILS_VERSION'] = rails_version
        used_railses << rails_version
        rspec_pre_commit(rails_version)
      end
      puts "All specs passed against the following versions of Rails: #{used_railses.join(", ")}"
    end

    def rspec_pre_commit(rails_version=ENV['RSPEC_RAILS_VERSION'])
      begin
        puts "#####################################################"
        puts "running pre_commit against rails #{rails_version}"
        puts "#####################################################"
        rm_rf 'vendor/plugins/rspec_on_rails'
        silent_sh "svn export ../rspec_on_rails vendor/plugins/rspec_on_rails"

        create_purchase unless rails_version == '1.1.6'
        ensure_db_config
        clobber_sqlite_data
        rake_sh "db:migrate"
        generate_rspec
        rake_sh "spec"
        rake_sh "spec:plugins"
        destroy_purchase
      ensure
        rm_rf 'vendor/plugins/rspec_on_rails'
      end
    end

    def create_purchase
      generate_purchase
      migrate_up
    end

    def install_plugin
      rm_rf 'vendor/plugins/rspec_on_rails'
      puts "installing rspec_on_rails ..."
      result = silent_sh("svn export ../rspec_on_rails vendor/plugins/rspec_on_rails")
      raise "Failed to install plugin:\n#{result}" if error_code?
    end

    def uninstall_plugin
      rm_rf 'vendor/plugins/rspec_on_rails'
    end

    def generate_rspec
      result = silent_sh("ruby script/generate rspec --force")
      raise "Failed to generate rspec environment:\n#{result}" if error_code? || result =~ /^Missing/
    end

    def ensure_db_config
      config_path = 'config/database.yml'
      unless File.exists?(config_path)
        message = <<-EOF
        #####################################################
        Could not find #{config_path}

        You can get rake to generate this file for you using either of:
          rake rspec:generate_mysql_config
          rake rspec:generate_sqlite3_config

        If you use mysql, you'll need to create dev and test
        databases and users for each. To do this, standing
        in rspec_on_rails, log into mysql as root and then...
          mysql> source db/mysql_setup.sql;

        There is also a teardown script that will remove
        the databases and users:
          mysql> source db/mysql_teardown.sql;
        #####################################################
        EOF
        raise message.gsub(/^        /, '')
      end
    end

    def generate_mysql_config
      copy 'config/database.mysql.yml', 'config/database.yml'
    end

    def generate_sqlite3_config
      copy 'config/database.sqlite3.yml', 'config/database.yml'
    end

    def clobber_db_config
      rm 'config/database.yml'
    end

    def clobber_sqlite_data
      rm_rf 'db/*.db'
    end

    def generate_purchase
      generator = "ruby script/generate rspec_resource purchase order_id:integer created_at:datetime amount:decimal keyword:string description:text --force"
      notice = <<-EOF
      #####################################################
      #{generator}
      #####################################################
      EOF
      puts notice.gsub(/^      /, '')
      result = silent_sh(generator)
      raise "rspec_resource failed. #{result}" if error_code? || result =~ /not/
    end

    def migrate_up
      rake_sh "db:migrate", 'VERSION' => 5
    end

    def destroy_purchase
      migrate_down
      rm_generated_purchase_files
    end

    def migrate_down
      notice = <<-EOF
      #####################################################
      Migrating down and reverting config/routes.rb
      #####################################################
      EOF
      puts notice.gsub(/^      /, '')
      rake_sh "db:migrate", 'VERSION' => 4
      output = silent_sh("svn revert config/routes.rb")
      raise "svn revert failed: #{output}" if error_code?
    end

    def rm_generated_purchase_files
      puts "#####################################################"
      puts "Removing generated files:"
      generated_files = %W{
        app/helpers/purchases_helper.rb
        app/models/purchase.rb
        app/controllers/purchases_controller.rb
        app/views/purchases
        db/migrate/005_create_purchases.rb
        spec/models/purchase_spec.rb
        spec/controllers/purchases_controller_spec.rb
        spec/fixtures/purchases.yml
        spec/views/purchases
      }
      generated_files.each do |file|
        rm_rf file
      end
      puts "#####################################################"
    end

    protected
    def rake_invoke(task_name)
      Rake::Task[task_name].invoke
    end

    def rake_sh(task_name, env_hash={})
      env = env_hash.collect{|key, value| "#{key}=#{value}"}.join(' ')
      output = silent_sh("rake #{task_name} #{env} --trace") do |line|
        puts line unless line =~ /^running against rails/ || line =~ /^\(in /
      end
      raise "ERROR while running rake: #{output}" if output =~ /ERROR/n || error_code?
    end

    def silent_sh(cmd, &block)
      output = nil
      IO.popen(cmd) do |io|
        io.each_line do |line|
          block.call(line) if block
        end
        output = io.read
      end
      output
    end

    def error_code?
      $? != 0
    end

    def method_missing(method_name, *args, &block)
      if actor.respond_to?(method_name)
        actor.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end
