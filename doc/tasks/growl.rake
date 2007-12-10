
desc 'send log events to Growl (Mac OS X only)'
task :growl do
  Logging::Logger['Webby'].add(Logging::Appenders::Growl.new(
    "Webby",
    :layout => Logging::Layouts::Pattern.new(:pattern => "%5l - Webby\000%m"),
    :coalesce => true,
    :separator => "\000"
  ))
end

# EOF
