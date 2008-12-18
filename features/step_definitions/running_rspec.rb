Given /^the file (.*)$/ do |relative_path|
  @path = File.expand_path(File.join(File.dirname(__FILE__), "..", "resources", relative_path))
  unless File.exist?(@path)
    raise "could not find file at #{@path}"
  end
end

When /^I run it with the (.*)$/ do |interpreter|
  stderr_file = Tempfile.new('rspec')
  stderr_file.close
  @stdout = case(interpreter)
    when /^ruby interpreter/
      args = interpreter.gsub('ruby interpreter','')
      ruby("#{@path}#{args}", stderr_file.path)
    when /^spec script/
      args = interpreter.gsub('spec script','')
      spec("#{@path}#{args}", stderr_file.path)
    when 'CommandLine object' then cmdline(@path, stderr_file.path)
    else raise "Unknown interpreter: #{interpreter}"
  end
  @stderr = IO.read(stderr_file.path)
  @exit_code = $?.to_i
end

Then /^the (.*) should match (.*)$/ do |stream, string_or_regex|
  written = case(stream)
    when 'stdout' then @stdout
    when 'stderr' then @stderr
    else raise "Unknown stream: #{stream}"
  end
  written.should smart_match(string_or_regex)
end
