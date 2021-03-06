lib_dir = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib_dir)
$LOAD_PATH.uniq!

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

gem 'rspec', '~> 1.2.9'
begin
  require 'spec/rake/spectask'
rescue LoadError
  STDERR.puts "Please install rspec:"
  STDERR.puts "sudo gem install rspec"
  exit(1)
end

require File.join(File.dirname(__FILE__), 'lib/google/api_client', 'version')

PKG_DISPLAY_NAME   = 'Google API Client'
PKG_NAME           = PKG_DISPLAY_NAME.downcase.gsub(/\s/, '-')
PKG_VERSION        = Google::APIClient::VERSION::STRING
PKG_FILE_NAME      = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_HOMEPAGE       = 'http://code.google.com/p/google-api-ruby-client/'

RELEASE_NAME       = "REL #{PKG_VERSION}"

PKG_AUTHOR         = "Bob Aman"
PKG_AUTHOR_EMAIL   = "bobaman@google.com"
PKG_SUMMARY        = 'Package Summary'
PKG_DESCRIPTION    = <<-TEXT
The Google API Ruby Client makes it trivial to discover and access supported
APIs.
TEXT

PKG_FILES = FileList[
    'lib/**/*', 'spec/**/*', 'vendor/**/*',
    'tasks/**/*', 'website/**/*',
    '[A-Z]*', 'Rakefile'
].exclude(/database\.yml/).exclude(/[_\.]git$/)

RCOV_ENABLED = (RUBY_PLATFORM != 'java' && RUBY_VERSION =~ /^1\.8/)
if RCOV_ENABLED
  task :default => 'spec:verify'
else
  task :default => 'spec'
end

WINDOWS = (RUBY_PLATFORM =~ /mswin|win32|mingw|bccwin|cygwin/) rescue false
SUDO = WINDOWS ? '' : ('sudo' unless ENV['SUDOLESS'])

Dir['tasks/**/*.rake'].each { |rake| load rake }
