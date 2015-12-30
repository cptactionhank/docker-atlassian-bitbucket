# Atlassian Bitbucket in a Docker container

> Version 3.11.1

[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-stash/3.11.1.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-stash) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-stash.svg)](https://github.com/cptactionhank/docker-atlassian-stash/issues) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-stash.svg)](https://github.com/cptactionhank/docker-atlassian-stash/stargazers) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-stash.svg)](https://github.com/cptactionhank/docker-atlassian-stash/network) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-stash.svg)](https://hub.docker.com/r/cptactionhank/atlassian-stash/) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-stash.svg)](https://hub.docker.com/r/cptactionhank/atlassian-stash/)

A containerized installation of Atlassian Bitbucket setup with a goal of keeping the installation as default as possible, but with a few Docker related twists.

Want to help out, check out the contribution section.

## I'm in the fast lane! Get me started

To quickly get started with running a Bitbucket instance, first run the following command:
```bash
docker run --detach --publish 7990:7990 cptactionhank/atlassian-stash:3.11.1
```

Then use your browser to navigate to `http://[dockerhost]:7990` and finish the configuration.

## The slower road to get started

For a more in-depth documentation on how to get started please visit the website made for this purpose. [cptactionhank.github.io/docker-atlassian-stash](https://cptactionhank.github.io/docker-atlassian-stash)

## Contributions

This has been made with the best intentions and current knowledge and thus it shouldn't be expected to be flawless. However you can support this repository with best-practices and other additions by creating and sending pull-requests. Continuous Integration has been setup to build the repository Dockerfile and run acceptance tests against a running Atlassian Bitbucket container to ensure it is working as expected.

CircleCI has been setup to automatically deploy new version branches when successfully building a new version of Atlassian Bitbucket in the `master` branch (a builder branch) and serves as the `latest` image tag as well. Furthermore an `eap` branch has been setup to automatically build and commit updates to ensure the `eap` branch contains the latest version of Atlassian Bitbucket Early Access Preview.

Out of date documentation?, lack of tests?, etc. you can help out by either creating an issue and open a discussion or sending a pull request with modifications to the appropriate branch. Please ensure that the current acceptance tests do run successfully for easier merging with the repository.

Acceptance tests are performed by CircleCI with Ruby using the RSpec, Capybara, and PhantomJS frameworks.
