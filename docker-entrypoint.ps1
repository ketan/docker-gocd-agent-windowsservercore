$ErrorActionPreference = "Stop"

gci env:* | sort-object name

$gocdAgentDir = "C:\go"
$gocdAgentConfigDir = "${gocdAgentDir}\config"
# create the auto register properties file
New-Item -Type Directory -Path "${gocdAgentConfigDir}" | Out-Null
Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" -Value ""

if (Test-Path env:GO_EA_SERVER_URL) { 
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.key=${env:GO_EA_AUTO_REGISTER_KEY}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.environments=${env:GO_EA_AUTO_REGISTER_ENVIRONMENT}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.elasticAgent.agentId=${env:GO_EA_AUTO_REGISTER_ELASTIC_AGENT_ID}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.elasticAgent.pluginId=${env:GO_EA_AUTO_REGISTER_ELASTIC_PLUGIN_ID}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.hostname=${env:AGENT_AUTO_REGISTER_HOSTNAME}"

  $env:GO_SERVER_URL="${GO_EA_SERVER_URL}"

  # unset variables, so we don't pollute and leak sensitive stuff to the agent process...
  $env:GO_EA_AUTO_REGISTER_KEY = ''
  $env:GO_EA_AUTO_REGISTER_ENVIRONMENT = ''
  $env:GO_EA_AUTO_REGISTER_ELASTIC_AGENT_ID = ''
  $env:GO_EA_AUTO_REGISTER_ELASTIC_PLUGIN_ID = ''
  $env:GO_EA_SERVER_URL = ''
  $env:AGENT_AUTO_REGISTER_HOSTNAME = ''
} else {
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.key=${env:AGENT_AUTO_REGISTER_KEY}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.resources=${env:AGENT_AUTO_REGISTER_RESOURCES}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.environments=${env:AGENT_AUTO_REGISTER_ENVIRONMENTS}"
  Add-Content -Path "${gocdAgentConfigDir}\autoregister.properties" "agent.auto.register.hostname=${env:AGENT_AUTO_REGISTER_HOSTNAME}"

  # unset variables, so we don't pollute and leak sensitive stuff to the agent process...
  $env:AGENT_AUTO_REGISTER_KEY = ''
  $env:AGENT_AUTO_REGISTER_RESOURCES = ''
  $env:AGENT_AUTO_REGISTER_ENVIRONMENTS = ''
  $env:AGENT_AUTO_REGISTER_HOSTNAME = ''
}

gci env:* | sort-object name
Write-Host "Executing GoCD agent"
Set-Location -Path $gocdAgentDir

if ($args.Count -eq 0) {
  # no args specified, just run `agent.cmd`
  $Command = "${gocdAgentDir}\agent.cmd" -NoNewWindow -Wait
  & $Command
} else {
  # args specified, execute the command with args.
  $Command = $args[0]
  If ($args.Count -gt 1) {
      $Arguments = $args[1..($args.Count - 1)]
  }
  & Start-Process $Command -ArgumentList $Arguments -NoNewWindow -Wait
}

# Start-Process "cmd" -ArgumentList '/c set' -NoNewWindow -Wait
# Start-Process "${gocdAgentDir}\agent.cmd" -NoNewWindow -Wait
