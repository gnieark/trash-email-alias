# trash-email-alias
a dovecot sieve 's script and configuration to generate random alias

# usage
Just send an email to the configured em-mail generator. It will respond you and indicate what is your alias.
# Configure

Need dovecot and dovecot pigeon hole.
On /etc/dovecot/dovecot.conf my plugin section looks like:

  plugin {
    (...)
    sieve = ~/dovecot.sieve
    sieve_after = /var/www/vmail/sieve/global.sieve
    sieve_dir = ~/sieve
    #vacation
    sieve_extensions = +vacation-seconds
    sieve_vacation_min_period = 30m
    sieve_vacation_default_period = 10d
    sieve_vacation_max_period = 30d

    #ExtPrograms
    sieve_plugins = sieve_extprograms
    sieve_global_extensions = +vnd.dovecot.pipe +vnd.dovecot.filter +vnd.dovecot.execute

    sieve_pipe_bin_dir = /etc/sieve-pipe/bin
    sieve_filter_bin_dir = /etc/sieve-pipe/filter
    sieve_execute_bin_dir = /etc/sieve-pipe/execute
    (...)
  }

 