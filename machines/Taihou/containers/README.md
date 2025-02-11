# Containers
ollama-intel: Adapted from [eleiton/ollama-intel-arc](https://github.com/eleiton/ollama-intel-arc)

Needs to be built using

```
   podman build -t "ollama-intel-arc:latest" .
```

Then, the systemd service defined on the home-manager settings on `users/stereomato/hm/default.nix` will run podman with this container.

# Notes
As of writing (11 Feb 2025), there's a bug that doesn't let any software upload models to the running ollama. As such, entering the container, running the commands on serve.sh to set up the environment, and using the ollama command in that file with `create modelname -f /path/to/Modelfile` can be used to add models