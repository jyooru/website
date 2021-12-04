---
layout: page
title: Credits
---

We live in a world where most people have no idea how important open source is to our everyday lives. This page mentions the software I depend on to build and host this website. I hope that it highlights the importance of open source, especially considering this website is a microscopic part of the content available on the internet and yet it still depends on so many people and their work.

I'm not able to list every person and project this website depends on, but it's all still safely recorded elsewhere:

- {% github_repository 'jyooru' 'website' %} contains all the code and dependencies used to build this website. The history of each dependency's exact version is stored in a lockfile inside this repository. Also, this website is open source - <a href="/license">view the license.</a>
- {% github_repository 'jyooru' 'dotfiles' %} contains all the code and dependencies used to host this website. The history of each dependency's exact version is stored in a lockfile inside this repository. Also, the configuration behind my cluster is open source - <a href="https://github.com/jyooru/dotfiles/blob/main/LICENSE" target="_blank" rel="noopener">view the license.</a>

## Building

## Hosting

This website is hosted on my [cluster](/projects/cluster). All the code and dependencies behind my cluster can be found in my dotfiles, {% github_repository 'jyooru' 'dotfiles' %}. Here are some highlights, specific to hosting this website:

- **Operating System Kernel**: Linux - <a href="https://kernel.org" target="_blank" rel="noopener">https://kernel.org</a>
  <p>The Linux kernel is a free and open source operating system kernel. The kernel is a core component of an operating system, providing the most basic level of control over all of the computer's hardware. As Linux is free and open source, it can be tailored for any kind of computing scenario, from personal computers to servers to supercomputers. Each node in my cluster runs Linux.</p>
- **Operating System / Linux Distribution**: NixOS - <a href="https://nixos.org" target="_blank" rel="noopener">https://nixos.org</a>
  <p>NixOS is a Linux distribution built on top of the Nix package manager. Nix is declarative, reliable and <a href="https://r13y.com/" target="_blank" rel="noopener">reproducible</a>. NixOS takes this a step further, featuring declarative configuration for the whole operating system, making a system reliable and completely reprodcible. Each node in my cluster runs NixOS.
- **Software Containerisation**: Docker - <a href="https://docker.com" target="_blank" rel="noopener">https://docker.com</a>
  <p>Docker is a platform for developing, shipping and running applications inside isolated containers. Each node in my cluster currently runs Caddy inside a Docker container to respond to incoming HTTP requests and serve this website.</p>
- **HTTP Load Balancer**: nginx - <a href="https://nginx.org" target="_blank" rel="noopener">https://nginx.org</a>
  <p>nginx is a HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server. It enables me to reverse proxy incoming HTTP connections by load balancing each connection to any node running Caddy in my cluster using the PROXY protocol. Each node in my cluster runs nginx to spread incoming HTTP connections across the whole cluster through a Nebula tunnel and serve this website.</p>
- **HTTP Server**: Caddy - <a href="https://caddyserver.com/" targe="_blank" rel="noopener">https://caddyserver.com</a>
  <p>Caddy is a HTTP server designed to be simple, featuring a human readable configuration file and automatic TLS certificate renewals. Each node in my cluster runs Caddy to receive direct HTTP requests from other nodes' load balanced HTTP requests from the internet, such as this website.</p>
- **Overlay Network**: Nebula - {% github_repository 'slackhq' 'nebula' %}
  <p>Nebula is a peer to peer software defined networking tool with a focus on performance, simplicity and security. Each node in my cluster is connected together flexibly and securely, using authentication and encryption. All HTTP requests are load balanced through a Nebula tunnel.</p>
