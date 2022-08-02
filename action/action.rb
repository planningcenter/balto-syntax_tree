require "ostruct"

require_relative "./install_gems"

event = JSON.parse(
  File.read(ENV["GITHUB_EVENT_PATH"]),
  object_class: OpenStruct
)
compare_sha = event.pull_request.base.sha
stree_cmd = ENV['INPUT_SMARTGEMINSTALL'].to_s.downcase == "false" ? "bundle exec stree" : "stree"
`git diff --name-only #{compare_sha} --diff-filter AM --relative | xargs #{stree_cmd} write`
