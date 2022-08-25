const process = require("process")
const core = require('@actions/core')
const exec = require('@actions/exec')
const io = require('@actions/io')

async function run() {
  process.chdir(process.env["GITHUB_WORKSPACE"])

  const baltoGemfile = 'balto-syntax_tree.gemfile'

  try {
    await exec.exec('ruby', [`${__dirname}/action/create_minimal_gemfile.rb`])

    const bundle = await io.which("bundle", true)
    const customEnv = process.env
    customEnv.BUNDLE_GEMFILE = baltoGemfile
    customEnv.BUNDLE_APP_CONFIG = '/dev/null'

    await exec.exec(bundle, ['install'], { env: customEnv })
    await exec.exec(
      bundle, 
      ['exec', `${__dirname}/action/action.rb`],
      { env: customEnv }
    )
  } catch (e) {
    core.setFailed(e.message)
  } finally {
    await exec.exec('git', ['clean', '-dfq', baltoGemfile, `${baltoGemfile}.lock`, 'Gemfile.lock'])
  }
}

run()
