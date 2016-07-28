# === Class: teleport::params
#
# This class is meant to be called from the main class
# It sets variables according to platform
class teleport::params {

  $version         = 'v1.0.0'
  $archive_path    = '/tmp/teleport.tar.gz'
  $extract_path    = "/opt/teleport-${version}"
  $bin_dir         = '/usr/local/bin'
  $assets_dir        = '/usr/local/share/teleport'
  $config_path     = '/etc/teleport.yaml'
  $nodename        = $::fqdn

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      if versioncmp($::operatingsystemrelease, '7.0') < 0 {
        $init_style  = 'init'
      } else {
        $init_style  = 'systemd'
      }
    }
    'Debian': {
      if versioncmp($::operatingsystemrelease, '8.0') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style = 'systemd'
      }
    }
    'Ubuntu': {
      if versioncmp($::operatingsystemrelease, '15.04') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style = 'systemd'
      }
    }
    default: { fail('Unsupported OS') }
  }
}
