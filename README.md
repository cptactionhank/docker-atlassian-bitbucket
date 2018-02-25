[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-bitbucket.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-bitbucket) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-bitbucket.svg)](https://github.com/cptactionhank/docker-atlassian-bitbucket/issues) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-bitbucket.svg)](https://github.com/cptactionhank/docker-atlassian-bitbucket/stargazers) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-bitbucket.svg)](https://github.com/cptactionhank/docker-atlassian-bitbucket/network) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-bitbucket.svg)](https://hub.docker.com/r/cptactionhank/atlassian-bitbucket/) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-bitbucket.svg)](https://hub.docker.com/r/cptactionhank/atlassian-bitbucket/) [![Sponsor by PayPal](https://img.shields.io/badge/sponsor-PayPal-blue.svg)](https://paypal.me/cptactionhank/5)

# Atlassian Bitbucket Server in a Docker container

This is a containerized installation of Atlassian Bitbucket Server with Docker, and it's a match made in heaven for us all to enjoy. The aim of this image is to keep the installation as straight forward as possible, but with a few Docker related twists. You can get started by clicking the appropriate link below and reading the documentation.

* [Atlassian JIRA Core](https://cptactionhank.github.io/docker-atlassian-jira)
* [Atlassian JIRA Software](https://cptactionhank.github.io/docker-atlassian-jira-software)
* [Atlassian JIRA Service Desk](https://cptactionhank.github.io/docker-atlassian-service-desk)
* [Atlassian Confluence](https://cptactionhank.github.io/docker-atlassian-confluence)
* [Atlassian Bitbucket Server](https://cptactionhank.github.io/docker-atlassian-bitbucket)

If you want to help out, you can check out the contribution section further down.

Note: newer versions of Atlassian Bitbucket Server includes an Elastic Search service as well, that is when you are not running Bitbucket in foreground mode. To include searching capability using the Elastic Search bundled system add-on it is necessary to setup an external service for this ie. starting an additional container running Elastic Search.

## I'm in the fast lane! Get me started

To quickly get started running a Bitbucket Server instance, use the following command:
```bash
docker run --detach --publish 7990:7990 cptactionhank/atlassian-bitbucket:latest
```

Then simply navigate your preferred browser to `http://[dockerhost]:7990` and finish the configuration.

## Contributions

This image has been created with the best intentions and an expert understanding of docker, but it should not be expected to be flawless. Should you be in the position to do so, I request that you help support this repository with best-practices and other additions.

Travis CI and CircleCI has been configured to build the Dockerfile and run acceptance tests on the Atlassian Bitbucket Server image to ensure it is working.

Travis CI has additionally been configured to automatically deploy new version branches when successfully building a new version of Atlassian Bitbucket Server in the `master` branch and serves as the base. Furthermore an `eap` branch has been setup to automatically build and commit updates to ensure this branch contains the latest version of Atlassian Bitbucket Server Early Access Program.

If you see out of date documentation, lack of tests, etc., you can help out by either
- creating an issue and opening a discussion, or
- sending a pull request with modifications (remember to read [contributing guide](https://github.com/cptactionhank/docker-atlassian-bitbucket/blob/master/CONTRIBUTING.md) before.)

Continuous Integration and Continuous Delivery is made possible with the great services from [GitHub](https://github.com), [Travis CI](https://travis-ci.org/), and [CircleCI](https://circleci.com/) written in [Ruby](https://www.ruby-lang.org/), using [RSpec](http://rspec.info/), [Capybara](https://jnicklas.github.io/capybara/), and [PhantomJS](http://phantomjs.org/) frameworks.
