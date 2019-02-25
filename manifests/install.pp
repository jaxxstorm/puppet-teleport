# === Class: teleport::install
#
# Installs teleport
class teleport::install {

  include ::archive

  file { $teleport::extract_path:
    ensure => directory,
  } ->
  archive { $teleport::archive_path:
    ensure       => present,
    extract      => true,
    extract_path => $teleport::extract_path,
    source       => "https://get.gravitational.com/teleport-v${teleport::version}-linux-amd64-bin.tar.gz",
    creates      => "${teleport::extract_path}/teleport"
  } ->
  file {
    "${teleport::bin_dir}/tctl":
      ensure => link,
      target => "${teleport::extract_path}/teleport/tctl";
    "${teleport::bin_dir}/teleport":
      ensure => link,
      target => "${teleport::extract_path}/teleport/teleport";
    "${teleport::bin_dir}/tsh":
      ensure => link,
      target => "${teleport::extract_path}/teleport/tsh";
    $teleport::assets_dir:
      ensure => link,
      target => "${teleport::extract_path}/teleport"
  }
}
