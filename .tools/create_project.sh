#!/bin/bash

create_wordpress_project() {
    echo "Création d'un projet WordPress: $projectName"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp

    if ! command -v wp &> /dev/null; then
        echo "WP-CLI n'a pas été installé correctement."
        exit 1
    fi

    wp core download
    wp config create --dbname=db --dbuser=db --dbpass=db --dbhost=db --skip-check
    echo "WordPress a été installé avec succès."
    ddev_init
    exit 0
}

create_laravel_project() {
    echo "Création d'un projet Laravel: $projectName"
    composer create-project --prefer-dist laravel/laravel .
    sed -i -e "s/APP_NAME=Laravel/APP_NAME=$projectName/g" .env
    sed -i -e "s/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/g" .env
    sed -i -e "s/# DB_HOST=127.0.0.1/DB_HOST=db/g" .env
    sed -i -e "s/# DB_DATABASE=laravel/DB_DATABASE=db/g" .env
    sed -i -e "s/# DB_USERNAME=root/DB_USERNAME=db/g" .env
    sed -i -e "s/# DB_PASSWORD=/DB_PASSWORD=db/g" .env
    cp ../../../.tools/Laravel/MakefileLaravel.mk Makefile
    cp ../../../.tools/Laravel/.htaccess.laravel .htaccess
    ddev_init
    exit 0
}

create_from_github() {
    read -p "Lien vers le GitHub: " repoLink
    git clone --recursive "$repoLink" htdocs/
    ddev_init
    exit 0
}

create_from_scratch() {
    echo "<?php echo 'Hello World';" > index.php
    echo "Les fichiers du projet $projectName sont créés"
    ddev_init
    exit 0
}

show_menu() {
    echo "-----------------------------------------------------"
    echo "Choisissez le type de projet à créer :"
    echo "1. WordPress"
    echo "2. Laravel"
    echo "3. Projet depuis un lien GitHub"
    echo "4. Projet from scratch"
}

ddev_init(){
    cd ../
    ddev config --project-name="$projectName" --docroot=htdocs --projecttype=php
    ddev config --webserver-type=apache-fpm
    ddev get ddev/ddev-phpmyadmin
    cp ../../.tools/MakefileDDEV.mk Makefile
    ddev start
}

cd ./sites || exit
read -rp "Nom du projet: " projectName
echo "Projet: $projectName"

if [ -d "$projectName" ]; then
    echo "Erreur: Le dossier '$projectName' existe déjà. Le script va s'arrêter."
    exit 1
fi

mkdir "$projectName" && cd "$projectName" || exit
mkdir htdocs
cd ./htdocs || exit

while true; do
    show_menu
    read -p "Votre choix (1-4): " choice
    case $choice in
        1) create_wordpress_project ;;
        2) create_laravel_project ;;
        3) create_from_github ;;
        4) create_from_scratch ;;
        *) printf "\n \n Choix invalide. Veuillez choisir une option de 1 à 4.\n" ;;
    esac
done

echo "Le projet a été créé"

