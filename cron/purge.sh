#!/bin/bash
#Gnieark https://blog-du-grouik.tinad.fr 2017 
#GNU GPL V2 license
#inactivate alias olders than on 
MYSQLPATH="/usr/bin/mysql"
MYSQLDB="postfix"
MYSQLUSER="postfix"
MYSQLPWD="******"
TTL="3600"

$MYSQLPATH -u $MYSQLDB -p$MYSQLPWD << EOF
  UPDATE alias
  SET active='0'
  WHERE DOMAIN='tinad.fr'
  AND active = '1'
  AND created < (UNIX_TIMESTAMP() - $TTL)
  AND temporary='1';
EOF