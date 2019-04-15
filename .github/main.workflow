workflow "Build and Detect" {
  on = "push"
  resolves = "Deploy branch filter"
}

action "Get dependencies" {
  uses = "./elixir-cli"
  args = ["deps.get"]
}

action "Clean" {
  needs = ["Get dependencies"]
  uses = "./elixir-cli"
  args = ["clean"]
}

action "Compile" {
  needs = ["Clean"]
  uses = "./elixir-cli"
  args = ["compile"]
}

action "Create Release" {
  needs = ["Compile"]
  uses = "./elixir-cli"
  env = {
      MIX_ENV = dev
  }
  args = ["release"]
}

action "Synopsys detect" {
  needs = ["Create Release"]
  uses = "https://github.com/gautambaghel/ducky-crm/actions-detect@master"
  secrets = ["BLACKDUCK_API_TOKEN", "BLACKDUCK_URL"]
  args = "--detect.tools=SIGNATURE_SCAN --detect.project.name=$GITHUB_REPOSITORY"
}

action "Deploy branch filter" {
  needs = ["Synopsys detect"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}
