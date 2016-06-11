class puphpet::adminer {

  include ::puphpet::params
  include ::puphpet::nginx::params
  include ::puphpet::apache::params

  if array_true($puphpet::params::config['nginx'], 'install') {
    $webroot = $puphpet::nginx::params::nginx_webroot_location
    $require = Class['puphpet::nginx']
  } elsif array_true($puphpet::params::config['apache'], 'install') {
    $webroot = $puphpet::apache::params::default_vhost_dir
    $require = Class['puphpet::apache']
  } else {
    fail('adminer requires either Apache or Nginx installed')
  }

  if ! defined(File[$webroot]) {
    file { $webroot:
      replace => no,
      ensure  => directory,
      mode    => '0775',
    }
  }

  remote_file { "${webroot}/adminer.php":
    ensure  => present,
    source  => 'http://www.adminer.org/latest.php',
    require => [
      File[$webroot],
      $require
    ],
  }

}