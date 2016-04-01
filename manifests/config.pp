# === Class teleport::config
#
# This class is called from teleport::init to install the config file
#
# == Parameters
#
# [*config_path*]
#   Path to teleport config file
#
class teleport::config {

  if $teleport::init_style {
  
    case $teleport::init_style {
      'systemd': {
        file { '/lib/systemd/system/teleport.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('teleport/teleport.systemd.erb'),
        }~>
        exec { 'teleport-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'init': {
        file { '/etc/init.d/teleport':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('teleport/teleport.init.erb')
        }
      }
      default: { fail('OS not supported') }
    }
  }

  file { $teleport::config_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
    notify  => Service['teleport'],
    content => template('teleport/teleport.yaml.erb')
  }

}
