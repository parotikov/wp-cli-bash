#!/bin/bash
red='\033[1;31m'
green='\033[1;32m'
NC='\033[0m' # No Color

##if test -f "index.php"; then echo "Dir not empty"; exit 1; fi

printf "\nSelect locale [1 - ru, 2 - en]: "

read language

case $language in
	1)
	locale="ru_RU"
	;;
	2)
	locale="en_EN" 
	;;
	*)
	printf "\n${red}Locale not selected.${NC} Bye \n\n"; exit 1;
esac
printf "\nDownloading...\n" 

wp core download --locale="$locale" || { 
##printf "\nDo you want to continue?\n"; 

  read -r -p "Do you want to continue? [y/N] " response
  response=${response,,}    # tolower
  if ! [[ $response =~ ^(yes|y)$ ]]  
  then 
    exit 1;
  fi

}
 
printf  "\nLets create wp_config.php"
printf "\nEnter dbname: "
read dbname

printf "\nEnter dbuser: "
read dbuser

printf "\nEnter dbpass: "
read dbpass
printf  "\nCreating wp-config.php...\n"

wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" || {
printf  "\n${red}Error${NC}: Seems that db connections cannot estabished. Please check db properties and try again. Bye\n\n"; exit 1;
}

printf  "\nNow enter site parameters: "

printf "\nEnter hostname without http and slashes: "
read domain

printf "\nEnter title: "
read title

printf "\nEnter admin login: "
read login

printf "Enter admin pass: "
read pass

printf "\nEnter admin email: "
read adm_email

printf  "\nInstalling, please wait... "
printf "\n"
if ! $(wp core is-installed); then
    wp core install --url=$domain --title="$title" --admin_user="$login" --admin_password="$pass" --admin_email="$adm_email"
fi
printf "\n" 

wp plugin delete akismet
wp plugin delete hello.php

plugins_array=(
	"contact-form-7" 
	"cyr3lat" 
	"all-in-one-seo-pack" 
	"google-sitemap-generator" 
	"hypercomments" 
	"shortcode-exec-php" 
	"w3-total-cache"
	"siteorigin-panels"
	"adminer"
	"all-in-one-wp-security-and-firewall"
  "http://prosto-tak.ru/wphide.zip"
	);

for i in "${plugins_array[@]}"
do
  read -r -p "Do you want to install $i? [y/N] " response
  response=${response,,}    # tolower
  if [[ $response =~ ^(yes|y)$ ]]  
  then 
    wp plugin install $i
	  wp plugin activate $i
  fi
done
