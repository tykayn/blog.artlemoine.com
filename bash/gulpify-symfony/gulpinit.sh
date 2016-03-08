#!/bin/bash
#
# script pour faire du browsersync dans un projet symfony
# il doit être lancé depuis la racine du projet symfony
NORMAL="\\033[0;39m"
BLEU="\\033[1;34m"
CYAN="\\033[1;36m"
touch Gulpfile.js;
echo "Gulpifions votre application symfony2! Ce script doit être lancé depuis la racine du projet symfony";
echo "copie des fichiers gulp";
cp init/Gulpfile.js* .;
SERVERNAME="symfony.dev";
NEWSERVERNAME=$SERVERNAME;
#echo -n "vous devez créer un virtualhost, choisissez son nom ( $SERVERNAME ): ";
echo -e "$BLEU vous devez créer un virtualhost, choisissez son nom. \n faites entrée si ok, ou bien écrivez un autre nom $NORMAL";
read  -p  " ( $SERVERNAME ): " NEWSERVERNAME ;
NEWSERVERNAME=${NEWSERVERNAME:=$SERVERNAME}
echo  -e "$BLEU nouveau serveur: $CYAN $NEWSERVERNAME $BLEU" ;

FOLDERSYMFONY=$(pwd);

read -p "modification du virtualhost, choisissez le dossier de votre projet ( $FOLDERSYMFONY ) " NEWFOLDERSYMFONY;
NEWFOLDERSYMFONY=${NEWFOLDERSYMFONY:=$FOLDERSYMFONY}
echo "replacing servername in config temp file"
cp init/virtualHostSymfony.conf init/tmpVirtualHostSymfony.conf
sed -i 's/myservername.dev/'$NEWSERVERNAME'/g' init/tmpVirtualHostSymfony.conf
echo  -e "$BLEU virtual host: $CYAN $NEWSERVERNAME $BLEU" ;
VHOSTCONTENT=$(cat init/tmpVirtualHostSymfony.conf);
echo -e "$CYAN $VHOSTCONTENT $NORMAL";
echo -e "copying replaced config in sites-available"
sudo cp init/tmpVirtualHostSymfony.conf /etc/apache2/sites-available/$NEWSERVERNAME.conf ;
echo -e "$CYAN success  $NORMAL";
ls -larth /etc/apache2/sites-available/ |grep $NEWSERVERNAME;
echo -e "$CYAN enabling new server $NEWSERVERNAME.conf $NORMAL"
sudo a2ensite $NEWSERVERNAME.conf ;
echo -e "$CYAN success  $NORMAL";
echo  -e "$BLEU  restarting apache2 $NORMAL" ;
echo "restart apache2"

sudo service apache2 stop;
sudo service apache2 start;

echo  -e "$BLEU  installation des dépendances gulp dans package.json $NORMAL" ;
echo  -e "$BLEU  lancement du serveur gulp syncronisé $NORMAL" ;
npm i -D gulp browser-sync --save-dev;
echo  -e "$CYAN  ça c'est fait $NORMAL" ;
echo  -e "$BLEU  lancer gulp $NORMAL" ;
gulp