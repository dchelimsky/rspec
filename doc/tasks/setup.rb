
require 'webby'

SITE = Webby.site

# Webby defaults
SITE.content_dir   = 'src'
SITE.output_dir    = 'output'
SITE.layout_dir    = 'layouts'
SITE.template_dir  = 'templates'
SITE.exclude       = %w[tmp$ bak$ ~$ CVS \.svn]
  
SITE.page_defaults = {
  'extension' => 'html',
  'layout'    => 'default'
}

# Items used to deploy the webiste
SITE.host       = 'user@hostname.tld'
SITE.remote_dir = '/not/a/valid/dir'
SITE.rsync_args = %w(-av --delete)

# Options passed to the 'tidy' program when the tidy filter is used
SITE.tidy_options = '-indent -wrap 80'

# Load up the other rake tasks
FileList['tasks/*.rake'].each {|task| import task}

# Conditional dependencies
%w(heel).each do |lib|
  Object.instance_eval {const_set "HAVE_#{lib.upcase}", try_require(lib)}
end

# EOF
