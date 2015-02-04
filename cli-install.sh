#!/bin/bash

if test -f "index.php"; then echo "Dir not empty"; exit 1; fi

echo "Select locale:"
echo "1 ru"
echo "2 en"

read language

case $language in
	1)
	locale="ru_RU"
	;;
	2)
	locale="en_EN" 
	;;
	*)
	echo "locale not selected"
esac

wp core download --locale="$locale"

echo "\n Let create wp_config.php:"
echo "Enter dbname:"
read dbname

echo "Enter dbuser:"
read dbuser

echo "Enter dbpass:"
read dbpass
echo "\n Creating wp-config.php..."

wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass"
echo "\n Done. Now enter site parameters:"

echo "Enter domain url without http:// and / at the and:"
read domain

echo "Enter title:"
read title

echo "Enter admin login:"
read login

echo "Enter admin pass:"
read pass

echo "Enter admin email:"
read adm_email

echo "\n Installing, please wait..."

if ! $(wp core is-installed); then
    wp core install --url=$domain --title="$title" --admin_user="$login" --admin_password="$pass" --admin_email="$adm_email"
fi

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
	);

for i in "${plugins_array[@]}"
do
	wp plugin install $i
	wp plugin activate $i
done
