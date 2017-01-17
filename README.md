# Trash-email-alias
A dovecot sieve 's script and configuration to generate a temporary random alias.

# Usage
Just send an email to the configured em-mail generator. It will respond you and indicate what is your alias.
You can test it by sending a mail to [ getalias Arobaze tinad.fr ].

# Configure

You need an e-mail server with dovecot and sieve. The mail box  structure is the classical one.
Add a column named "temporary" type Boolean, default 0 to the table alias. So alias table structure is:

    +-----------+--------------+------+-----+---------------------+-------+
    | Field     | Type         | Null | Key | Default             | Extra |
    +-----------+--------------+------+-----+---------------------+-------+
    | address   | varchar(255) | NO   | PRI |                     |       |
    | goto      | text         | NO   |     | NULL                |       |
    | domain    | varchar(255) | NO   |     |                     |       |
    | created   | datetime     | NO   |     | 0000-00-00 00:00:00 |       |
    | modified  | datetime     | NO   |     | 0000-00-00 00:00:00 |       |
    | active    | tinyint(1)   | NO   |     | 1                   |       |
    | temporary | tinyint(1)   | NO   |     | 0                   |       |
    +-----------+--------------+------+-----+---------------------+-------+



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

 Change your mysql credentials on  cron/purge.sh and execute/genalias.sh
 In my case, this files are owned by the unix user "dovecot".
 
 Add purge.sh on your crontab. Every 10 minutes is enougth.
 
 Add the filters on yours sieve rules. Sample on this repo ./global.sieve file.
