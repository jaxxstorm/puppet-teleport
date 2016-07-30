# === Class: teleport
#
# Install, configures and manages teleport
#
# === Parameters
#
# [*version*]
#  Version of teleport to download
#
# [*archive_path*]
#  Where to download the teleport tarball
#
# [*extract_path*]
#  Directory to extract teleport
#
# [*bin_dir*]
#  Where to symlink teleport binaries
#
# [*assets_dir*]
#  Where to sylink the teleport web assets
#
# [*nodename*]
#  Teleport nodename. 
#  Defaults to $::fqdn fact
#
# [*data_dir*]
#  Teleport data directory
#  Defaults to undef (meaning teleport uses its
#  default of '/var/lib/teleport')
#
# [*auth_token*]
#  The auth token to use when joining the cluster
#  Defaults to undef
#
# [*advertise_ip*]
#  When running in NAT'd environments, designates
#  an IP for teleport to advertise.
#  Defaults to undef
#
# [*storage_backend*]
#  Which storage backend to use.
#  Defaults to undef (meaning teleport uses its
#  default of boltdb
#
# [*max_connections*]
#  Configure max connections for teleport
#  Defaults to 100
#
# [*max_users*]
#  Teleport max users
#  Defaults to 250
#
# [*log_dest*]
#  Log destination
#  Defaults to stderr
#
# [*log_level*]
#  Log output level
#  Defaults to "ERROR"
#
# [*config_path*]
#  Path to config file for teleport
#  Defaults to /etc/teleport.yaml
#
# [*auth_servers*]
#  An array of auth servers to connect to
#
# [*auth_enable*]
#  Whether to start the auth service
#  Defaults to false
#
# [*auth_listen_addr*]
#  Address to listen for auth_service
#
# [*auth_listen_port*]
#  Port to listen on for auth server
#
# [*auth_service_tokens*]
#  The provisioning tokens for the auth tokens
#  Defaults to an empty array
#
# [*cluster_name*]
#  The cluster name. If none specified, uses a GUID
#  Defaults to undef
#
# [*ssh_enable*]
#  Whether to start SSH service
#  Defaults to true
#
# [*ssh_listen_addr*]
#  Address to listen on for SSH connections
#  Defaults to 0.0.0.0
#
# [*ssh_listen_port*]
#  Port to listen on for SSH connection
#
# [*labels*]
#  A hash of labels to assign to hosts
#
# [*proxy_enable*]
#  Where to start the proxy service
#  Defaults to false
#
# [*proxy_listen_addr*]
#  Address to listen on for proxy
#
# [*proxy_listen_port*]
#  Port to listen on for proxy connection
#
# [*proxy_web_listen_address*]
#  Address to listen on for web proxy
#
# [*proxy_web_listen_port*]
#  Port to listen on for web proxy connections
#
# [*proxy_ssl*]
#  Enable or disable SSL support
#  Default is false
#
# [*proxy_ssl_key*]
#  Path to SSL key for proxy
#
# [*proxy_ssl_cert*]
#  Path to SSL cert for proxy
#
# [*init_style*]
#  Which init system to use to start the service. Currently only
#  systemd is supported
#
# [*manage_service*]
#  Whether puppet should manage and configure the service
#
# [*service_ensure*]
#  State of the teleport service
#
# [*service_enable*]
#  Whether the service should be enabled on startup
#
class teleport (
  $version               = $teleport::params::version,
  $archive_path          = $teleport::params::archive_path,
  $extract_path          = $teleport::params::extract_path,
  $bin_dir               = $teleport::params::bin_dir,
  $assets_dir            = $teleport::params::assets_dir,
  $nodename              = $teleport::params::nodename,
  $data_dir              = undef,
  $auth_token            = undef,
  $advertise_ip          = undef,
  $storage_backend       = undef,
  $max_connections       = 1000,
  $max_users             = 250,
  $log_dest              = 'stderr',
  $log_level             = 'ERROR',
  $config_path           = $teleport::params::config_path,
  $auth_servers          = ['127.0.0.1:3025'],
  $auth_enable           = false,
  $auth_listen_addr      = '127.0.0.1',
  $auth_listen_port      = '3025',
  $auth_service_tokens   = [],
  $cluster_name          = undef,
  $ssh_enable            = true,
  $ssh_listen_addr       = '0.0.0.0',
  $ssh_listen_port       = '3022',
  $labels                = {},
  $proxy_enable          = false,
  $proxy_listen_addr     = '127.0.0.1',
  $proxy_listen_port     = '3023',
  $proxy_web_listen_addr = '127.0.0.1',
  $proxy_web_listen_port = '3080',
  $proxy_ssl             = false,
  $proxy_ssl_key         = undef,
  $proxy_ssl_cert        = undef,
  $init_style            = $teleport::params::init_style,
  $manage_service        = true,
  $service_ensure        = 'running',
  $service_enable        = true
) inherits teleport::params {

  validate_array($auth_servers)
  validate_bool($auth_enable)
  validate_bool($ssh_enable)
  validate_hash($labels)
  validate_bool($proxy_enable)
  validate_bool($proxy_ssl)
  validate_bool($manage_service)
  validate_re($service_ensure, '^(running|stopped)$')
  validate_bool($service_enable)
  validate_array($auth_service_tokens)

  anchor { 'teleport_first': }
  ->
  class { 'teleport::install': } ->
  class { 'teleport::config': } ->
  class { 'teleport::service': } ->
  anchor { 'teleport_final': }

}


