# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Manage /etc/dovecot/private directory (if enabled, default on Debian-based systems),
  to prevent log noise and service notifies after package updates
- Add SysVinit support for poolmon service ([#12])

### Fixes
- Fix poolmon systemd service generation ([#12])

## [1.1.0] - 2018-06-02
This release adds support for managing external config files

### Added
- Support for external config files as required for some userdb/passdb drivers ([#6])
- Make config files mode configurable

### Fixes
- Fixed `dovecot::create_config_file_resources()` not respecting `$include_in_main_config` ([#8])

## [1.0.1] - 2018-01-28
This release only contains minor non-functional and documentation changes

### Fixes
- Fix links in this changelog
- Lint fixes

## [1.0.0] - 2018-01-28
First stable release, now requires Puppet 4.9

### Added
- Support support for other operating systems (RedHat, Debian and FreeBSD)
- New parameters for service configuration (`$service_enable`, `$service_ensure`,
  `$service_name` to customize the service name, `$package_ensure` to allow 'latest' or 
  a specific version number)
- Add poolmon support

### Changed
- Minium required puppet version is now 4.9 for Hiera 5 support
- Module structure has been completely rewritten, uses standard module layout now
- Rename parameter `$packages_install` to `$package_manage`
- Lots of lint/style changes

### Fixed
- `require` on service would fail if `$package_manage` was `false`

## 0.1.0 - 2017-07-31
Initial release

[Unreleased]: https://github.com/oxc/puppet-dovecot/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/oxc/puppet-dovecot/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/oxc/puppet-dovecot/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/oxc/puppet-dovecot/compare/v0.1.0...v1.0.0
[#12]: https://github.com/oxc/puppet-dovecot/pull/12
[#8]: https://github.com/oxc/puppet-dovecot/issues/8
[#6]: https://github.com/oxc/puppet-dovecot/issues/6
