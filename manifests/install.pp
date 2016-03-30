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
    source       => "https://github.com/gravitational/teleport/releases/download/${teleport::version}/teleport-${teleport::version}-linux-amd64-bin.tar.gz",
    creates      => "${teleport::extract_path}/teleport/build"
  } ->
  file {
    "${teleport::bin_dir}/tctl":
      ensure => link,
      target => "${teleport::extract_path}/teleport/build/tctl";
    "${teleport::bin_dir}/teleport":
      ensure => link,
      target => "${teleport::extract_path}/teleport/build/teleport";
    "${teleport::bin_dir}/tsh":
      ensure => link,
      target => "${teleport::extract_path}/teleport/build/tsh";
    $teleport::data_dir:
      ensure => link,
      target => "${teleport::extract_path}/teleport/src/github.com/gravitational/teleport/web/dist"
  }


}
