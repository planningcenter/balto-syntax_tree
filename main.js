const process = require("process")
const exec = require("@actions/exec")

async function run() {
  process.chdir(process.env["GITHUB_WORKSPACE"])

  await exec.exec("ruby", [`${__dirname}/action/action.rb`])
}

run()
