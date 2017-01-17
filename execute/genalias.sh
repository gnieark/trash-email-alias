#!/bin/bash
#Gnieark https://blog-du-grouik.tinad.fr 2017 
#GNU GPL V2 license
#
#This script generate the random alias: Create it on postfix bdd
#
#First and only param is the mail "GOTO"


if [ -z "$1" ]
  then
    echo "Error, argument missing. usage: $0 mail@domaine.com"
    exit 2
fi

MYSQLPATH="/usr/bin/mysql"
MYSQLDB="postfix"
MYSQLUSER="postfix"
MYSQLPWD="******"
OPENSSLPATH="/usr/bin/openssl"
DOMAIN="tinad.fr"
LOGGERPATH="/usr/bin/logger"
LOGFILE="/var/log/genalias.log"

#escape mail:
printf -v MAIL "%q" "$1"

#Check if the sender is already knowed on the database
EXISTS=`$MYSQLPATH -B -u $MYSQLUSER -p$MYSQLPWD -D $MYSQLDB --disable-column-names -e "SELECT count(*) FROM alias WHERE goto='$MAIL'"`

if [ $EXISTS -eq 0 ]; then
  #unknowed user *************************************************
  #Generate random string for the alias. If already exists, retry.
  COUNT=1
  while [  $COUNT -gt 0 ]; do
    #gererate random
    RD=$($OPENSSLPATH rand -base64 8)
    #Delete = char at the end of string
    PART=${RD::-1}
    COUNT=`$MYSQLPATH -B -u $MYSQLUSER -p$MYSQLPWD -D $MYSQLDB --disable-column-names -e "SELECT count(*) FROM alias WHERE address='$PART@$DOMAIN'"`
  done
  ALIASFULL=$PART@$DOMAIN

#Feed the database
$MYSQLPATH -u $MYSQLUSER -p$MYSQLPWD  $MYSQLDB << EOF
  INSERT INTO alias(address,goto,domain,created,modified,active,temporary) VALUES
  ('$PART@$DOMAIN',
  '$MAIL',
  '$DOMAIN',
  NOW(),
  NOW(),
  '1',
  '1'
  );
EOF

else 
#user is already knowed, simply reactivate his alias************
$MYSQLPATH -u $MYSQLUSER -p$MYSQLPWD  $MYSQLDB << EOF
  UPDATE alias SET
    modified=NOW(),
    active='1'
  WHERE goto='$MAIL'
  AND temporary='1';
EOF
#get his alias
ALIASFULL=`$MYSQLPATH -B -u $MYSQLUSER -p$MYSQLPWD -D $MYSQLDB --disable-column-names -e "SELECT address FROM alias WHERE goto='$MAIL'"`
 
fi

printf "Hi, Your requested alias is $ALIASFULL, You will receive all mails sending to this alias during one hour from now. Thanks for using this service."
$LOGGERPATH -s "Activate alias $ALIASFULL FOR $MAIL" 2> $LOGFILE
exit 0	