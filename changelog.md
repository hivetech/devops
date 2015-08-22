# Change Log

All notable changes to this project will be documented in this file, following [keepachangelog](http://keepachangelog.com/) recommendations, while version follows [SemVer](http://semver.org/).

---

## [0.1.2] - 2015-08-15
### Added
- DigitalOcean mesos slave droplet template for packer
- Makefile
- basic droplet creation with terraform
- mesos-slave and master droplets
- Graylog server and web containers and docker-compose setup
- pull graylog images on master when building with packer
- Graylog tasks for marathon

### Changed
- nice ui for bootstrap script
- re-organize directories
- improve `build_component` with proper context and tags
- split scripts into single-purpose ones
- containers provisioning on master
- execution mode for scripts
- simpler names for jobs

### Deleted
- remove chronos pull from master as it will be deployed on slaves

---

## [0.1.1] - 2015-08-12
### Added
- components Dockerfile
- bootstrap script and bash sugar
- marathon and chronos job examples
- basic readme instructions
