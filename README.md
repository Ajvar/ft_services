# ft_services - a 42 project
This project aims to create a reliable K8's cluster with persistent databases.

# ⚖ EASY LOAD BALANCING 
  MetalLB has a feature that allows you to share the same IP :https://metallb.universe.tf/usage/#ip-address-sharing
  So all your services will share the same entrypoint, they will use different ports.
  You can communicate this unique IP to your containers using the env filed in your container specs
  For instance, if a service config file needs another service IP you can copy this unique IP to the config.
