# ft_services - a 42 project
This project aims to create a reliable K8's cluster with persistent databases.

# ⚖ EASY LOAD BALANCING 
  MetalLB has a feature that allows your services share the same IP: https://metallb.universe.tf/usage/#ip-address-sharing
  All your services will share the same entrypoint, they will use different ports.
  You can communicate this unique IP to your containers using the env field in your container specs
