# LiteLLM Proxy Server

This directory contains the configuration for running a LiteLLM proxy server as a Docker container via NixOS.

## NixOS Setup

The LiteLLM proxy is configured as a Docker container in `nixos/docker.nix`. Key components:

- Uses the official LiteLLM image: `ghcr.io/berriai/litellm:main-latest`
- Exposes the service on `localhost:4000`
- Automatically loads API keys from the secrets directory
- Mounts the appropriate configuration file based on the selected model

```nix
# Configuration selection in docker.nix
modelConfig = "claude";  # Change to use different config files (openai, gemini)
```

## Adding New Providers

To add a new LLM provider:

1. Create a new YAML configuration file in `dotfiles/litellm/configs/`
2. Add API key path to `nixos/docker.nix`
3. Update environment variables in the container definition

Example for a new provider:

```nix
# In docker.nix
newProviderKeyFile = "${secretsDir}/new_provider_api_key.txt";
newProviderKey = readFileIfExists newProviderKeyFile;

# Add to environment variables
environment = {
  # Existing variables...
  NEW_PROVIDER_API_KEY = newProviderKey;
};
```

## Provider Configuration

Provider configurations are stored in YAML files in the `configs/` directory:

- `claude.yaml` - Anthropic Claude models
- `openai.yaml` - OpenAI models
- `gemini.yaml` - Google Gemini models

Example configuration structure:

```yaml
model_list:
  - model_name: public-model-name 
    litellm_params:
      model: provider/actual-model-name

environment_variables:
  PROVIDER_API_KEY: ${PROVIDER_API_KEY}
  
litellm_settings:
  drop_params: True
  num_retries: 3
  routing_strategy: simple-shuffle
  allowed_fails: 1
```

## Usage Examples

### Anthropic Claude

```bash
curl -X POST http://localhost:4000/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-7-sonnet",
    "messages": [
      {"role": "user", "content": "What is the meaning of life?"}
    ]
  }'
```

### With System Message

```bash
curl -X POST http://localhost:4000/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-7-sonnet",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant that gives concise answers."},
      {"role": "user", "content": "What is the meaning of life?"}
    ]
  }'
```

### With Streaming

```bash
curl -X POST http://localhost:4000/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-7-sonnet",
    "messages": [
      {"role": "user", "content": "Write a short poem about coding."}
    ],
    "stream": true
  }'
```

## Troubleshooting

- If the service isn't responding, check the Docker container logs:
  ```bash
  docker logs litellm-proxy
  ```
- Verify your API keys are correctly stored in the secrets directory
- Ensure the firewall allows connections to port 4000