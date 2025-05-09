# LiteLLM Proxy Server

This directory contains the configuration for running a LiteLLM proxy server using Docker Compose.

## Docker Compose Setup

The LiteLLM proxy is configured to run as a Docker container:

- Uses the official LiteLLM image: `ghcr.io/berriai/litellm:main-latest`
- Exposes the service on `localhost:4000`
- Reads API keys from secret files at launch time
- Uses the configuration defined in `config.yaml`

## Running the Proxy

Use the provided shell script to start the container:

```bash
./launch-litellm.sh
```

This script:
- Reads API keys from the secret files
- Launches the Docker container with the correct environment variables

## Adding New Providers

To add a new LLM provider:

1. Update the `config.yaml` file to include the new provider's models
2. Add the API key to a new file in the secrets directory
3. Update the `launch-litellm.sh` script to read and export the new API key

Example for adding a new provider:

```bash
# In launch-litellm.sh
export NEW_PROVIDER_API_KEY=$(cat ~/.dotfiles/secrets/new_provider_api_key.txt)
```

## Provider Configuration

Provider configuration is defined in the `config.yaml` file.

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
  docker-compose logs
  ```
- Verify your API keys are correctly stored in the secrets directory
- Ensure the firewall allows connections to port 4000