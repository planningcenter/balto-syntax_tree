require "ostruct"

require_relative "./install_gems"

class RubyFileMatcher
  # From https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
  FILENAMES = %w[
    .irbrc
    .pryrc
    .simplecov
    Appraisals
    Berksfile
    Brewfile
    Buildfile
    Capfile
    Dangerfile
    Deliverfile
    Fastfile
    Gemfile
    Guardfile
    Jarfile
    Mavenfile
    Podfile
    Puppetfile
    Rakefile
    Snapfile
    Steepfile
    Thorfile
    Vagrantfile
    buildfile
  ].freeze

  EXTENSIONS = %w[
    rb
    builder
    eye
    fcgi
    gemspec
    god
    jbuilder
    mspec
    pluginspec
    podspec
    prawn
    rabl
    rake
    rbi
    rbuild
    rbw
    rbx
    ru
    ruby
    spec
    thor
    watchr
  ].freeze

  def self.match?(path)
    File.fnmatch?("**/#{FILENAMES.join(",")}", path, File::FNM_EXTGLOB) ||
      File.fnmatch?("**/*.{#{EXTENSIONS.join(",")}}", path, File::FNM_EXTGLOB)
  end
end

def debug(msg)
  if ENV['ACTIONS_STEP_DEBUG'].to_s.downcase == "true"
    puts msg
  end
end

event = JSON.parse(
  File.read(ENV["GITHUB_EVENT_PATH"]),
  object_class: OpenStruct
)
compare_sha = event.pull_request.base.sha
stree_exe = ENV['INPUT_SMARTGEMINSTALL'].to_s.downcase == "false" ? "bundle exec stree" : "stree"

changed_files_cmd = "git diff --name-only #{compare_sha} --diff-filter AM"
puts "Looking for changed files..."
debug "command: #{changed_files_cmd}"
changed_ruby_files = `#{changed_files_cmd}`.each_line(chomp: true).select { |f| RubyFileMatcher.match?(f) }
debug "Found files: #{changed_ruby_files}"

stree_cmd = "#{stree_exe} write #{changed_ruby_files.join(" ")}"
puts "Running stree write..."
debug "command: #{stree_cmd}"
`#{stree_cmd}`
