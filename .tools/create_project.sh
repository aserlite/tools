#!/bin/bash

# Couleurs pour les messages
RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m' # Pas de couleur

validate_project_name() {
    if [[ -z "$projectName" ]]; then
        echo -e "${RED}Erreur: Le nom du projet ne peut pas être vide.${NC}"
        exit 0
    fi

    if [[ ! "$projectName" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo -e "${RED}Erreur: Le nom du projet '$projectName' contient des caractères invalides. Utilisez uniquement des lettres, des chiffres et des tirets.${NC}"
        exit 0
    fi
}

check_prerequisites() {
    local missing_tools=()
    for tool in ddev wp composer git; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo -e "${RED}Erreur: Les outils suivants ne sont pas installés : ${missing_tools[*]}. Veuillez les installer et réessayer.${NC}"
        exit 0
    fi
}

create_wordpress_project() {
    echo "Création d'un projet WordPress: $projectName"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp

    if ! command -v wp &> /dev/null; then
        echo -e "${RED}WP-CLI n'a pas été installé correctement.${NC}"
        exit 0
    fi

    wp core download
    wp config create --dbname=db --dbuser=db --dbpass=db --dbhost=db --skip-check
    echo "WordPress a été installé avec succès."
    rm wp-cli.phar
    ddev_init
    exit 0
}

create_laravel_project() {
    echo "Création d'un projet Laravel: $projectName"
    composer create-project --prefer-dist laravel/laravel .
    sed -i -e "s/APP_NAME=Laravel/APP_NAME=$projectName/g" .env
    sed -i -e "s|APP_URL=http://localhost|APP_URL=https://$projectName.ddev.site|g" .env
    sed -i -e "s/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/g" .env
    sed -i -e "s/# DB_HOST=127.0.0.1/DB_HOST=db/g" .env
    sed -i -e "s/# DB_DATABASE=laravel/DB_DATABASE=db/g" .env
    sed -i -e "s/# DB_USERNAME=root/DB_USERNAME=db/g" .env
    sed -i -e "s/# DB_PASSWORD=/DB_PASSWORD=db/g" .env
    cp ../../.tools/Laravel/MakefileLaravel.mk MakefileLaravel.mk
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
    echo "-----------------------------------------------------"
}

ddev_init() {
    ddev config --project-name="$projectName" --database=mysql:8.0
    ddev config --webserver-type=apache-fpm
    ddev get ddev/ddev-phpmyadmin
    cp ../.tools/MakefileDDEV.mk Makefile
    ddev start
}

check_prerequisites

cd ./sites || exit
read -rp "Nom du projet: " projectName
validate_project_name
echo "Projet: $projectName"

if [ -d "$projectName" ]; then
    echo -e "${RED}Erreur: Le dossier '$projectName' existe déjà. Le script va s'arrêter.${NC}"
    exit 0
fi

mkdir "$projectName" && cd "$projectName" || exit

while true; do
    show_menu
    read -p "Votre choix (1-4): " choice
    case $choice in
        1) create_wordpress_project ;;
        2) create_laravel_project ;;
        3) create_from_github ;;
        4) create_from_scratch ;;
        *) printf "\n\n${RED}Choix invalide. Veuillez choisir une option de 1 à 4.${NC}\n" ;;
    esac
done

echo "Le projet a été créé"
