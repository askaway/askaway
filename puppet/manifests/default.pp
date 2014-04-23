$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

# Pick a Ruby version modern enough, that works in the currently supported Rails
# versions, and for which RVM provides binaries.
$ruby_version = '2.1'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class { 'apt':
  always_apt_update    => true
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# NodeJS runtime.
apt::ppa { 'ppa:chris-lea/node.js': }
package { 'nodejs':
  ensure => installed,
  require => Apt::Ppa['ppa:chris-lea/node.js']
}
exec { 'npm_install_phantomjs':
  command => "npm install -g phantomjs",
  require => Package['nodejs']
}

# --- Ruby ---------------------------------------------------------------------

package { 'ruby':
  ensure => installed
}
package { 'ruby-dev':
  ensure => installed
}
package { 'rubygems':
  ensure => installed
}
exec { 'install_bundler':
  command => "gem install bundler --no-rdoc --no-ri",
  creates => '/usr/local/bin/bundle',
  require => Package['rubygems']
}

# --- Locale -------------------------------------------------------------------

# Needed for docs generation.
exec { 'update-locale':
  command => 'update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8'
}

# --- AskAway ------------------------------------------------------------------

exec { 'askaway_bundle_install':
  # Install askaway dependencies
  command => "${as_vagrant} 'bundle install --without production'",
  cwd => "/var/www",
  require => [Exec['install_bundler'], Package['ruby-dev']]
}

exec { 'askaway_migrate':
  # Install askaway dependencies
  command => "${as_vagrant} 'bundle exec rake db:migrate'",
  cwd => "/var/www",
  require => Exec['askaway_bundle_install']
}

exec { 'rails_server':
  # Run 'rails server'
  command => "${as_vagrant} 'bundle exec rails server -d'",
  cwd => "/var/www",
  require => Exec['askaway_migrate']
}
