# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.0] - 2020-09-12
This release now uses PDK and increases dependency compatibility.

## Changed
- Increased compatible stdlib dependency versions in metadata ([#25])
- Convert to PDK

## [3.0.0] - 2020-04-07
This release modifies the behaviour of `purge_unmanaged` parameter to include
files in "conf.d" and "private" directories.

While in theory this is a breaking change (hence the version increase), it
should rarely have any real effects. In any case, be advised that unmanaged
files in conf.d and private directories will be purged if you have
`purge_unmanaged` enabled (which it is by default).

### Changed
- `purge_unmanaged` now also purges "conf.d" and "private" directories ([#22])

## [2.3.0] - 2020-04-07
This release solely changes documentation and metadata.

### Changed
- Increased compatible dependency versions in metadata ([#23])

## [2.2.0] - 2020-03-20
This release adds support for additional content in extconfig files.

### Added
- Add support for additional content in extconfig files ([#19])

## [2.1.0] - 2019-03-23
This release solely changes documentation and metadata.

### Changed
- Increased compatible dependency versions in metadata ([#15] & [#16])

## [2.0.0] - 2019-02-04
This release includes one breaking change, the switch to "hash" merge behaviour
for `$dovecot::poolmon_config`. This will most likely not affect your
configuration, but in theory it might, so this is released as a new major
version in conformance with SemVer.

### Changed
- `$dovecot::poolmon_config` now uses "hash" merge behaviour ([#13]).

## [1.2.0] - 2018-12-10
This release mainly fixes and improves poolmon service management

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

[Unreleased]: https://github.com/oxc/puppet-dovecot/compare/v3.1.0...HEAD
[3.1.0]: https://github.com/oxc/puppet-dovecot/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/oxc/puppet-dovecot/compare/v2.3.0...v3.0.0
[2.3.0]: https://github.com/oxc/puppet-dovecot/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/oxc/puppet-dovecot/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/oxc/puppet-dovecot/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/oxc/puppet-dovecot/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/oxc/puppet-dovecot/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/oxc/puppet-dovecot/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/oxc/puppet-dovecot/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/oxc/puppet-dovecot/compare/v0.1.0...v1.0.0
[#25]: https://github.com/oxc/puppet-dovecot/pull/25
[#23]: https://github.com/oxc/puppet-dovecot/pull/23
[#22]: https://github.com/oxc/puppet-dovecot/pull/22
[#19]: https://github.com/oxc/puppet-dovecot/issues/19
[#16]: https://github.com/oxc/puppet-dovecot/issues/16
[#15]: https://github.com/oxc/puppet-dovecot/pull/15
[#13]: https://github.com/oxc/puppet-dovecot/pull/13
[#12]: https://github.com/oxc/puppet-dovecot/pull/12
[#8]: https://github.com/oxc/puppet-dovecot/issues/8
[#6]: https://github.com/oxc/puppet-dovecot/issues/6
