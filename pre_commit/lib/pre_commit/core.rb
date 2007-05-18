class PreCommit::Core < PreCommit
  def pre_commit
    website
    rake_invoke :examples
    rake_invoke :translated_specs
    rake_invoke :failing_examples_with_html
  end

  def website
    clobber
    rake_invoke :verify_rcov
    rake_invoke :spec_html
    webgen
    rake_invoke :failing_examples_with_html
    rake_invoke :examples_specdoc
    rake_invoke :rdoc
    rake_invoke :rdoc_rails
  end

  def clobber
    rm_rf '../doc/output'
    rm_rf 'translated_specs'
  end

  def webgen
    Dir.chdir '../doc' do
      output = nil
      IO.popen('webgen 2>&1') do |io|
        output = io.read
      end
      raise "ERROR while running webgen: #{output}" if output =~ /ERROR/n || $? != 0
    end
    spec_page = File.expand_path(File.dirname(__FILE__) + '/../../../doc/output/tools/spec.html')
    spec_page_content = File.open(spec_page).read
    raise "#{'!'*400}\nIt seems like the output in the generated documentation is broken (no dots: ......)\n. Look in #{spec_page}" unless spec_page_content =~/\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\./m    
  end

  def rdoc
    rake_invoke :examples_specdoc
  end

  def rdoc_rails
    Dir.chdir '../rspec_on_rails' do
      rake = (PLATFORM == "i386-mswin32") ? "rake.cmd" : "rake"
      `#{rake} rdoc`
    end
  end
end
