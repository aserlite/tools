# Projet de Développement Web avec DDEV

Ce projet permet de créer rapidement un environnement de développement pour différents types de projets web (WordPress, Laravel, etc.) en utilisant DDEV, un outil de conteneurisation pour les environnements de développement PHP.

Les projets sont crées dans un sous dossier `sites`

## Objectif

L'objectif de ce projet est de simplifier la mise en place d'un environnement de développement local pour les développeurs web en automatisant les étapes de configuration et d'initialisation des projets avec DDEV.

## Structure du Projet

Le projet utilise un Makefile pour automatiser les commandes DDEV et un script Bash pour initialiser différents types de projets.

### Script Bash

Voici les principales fonctions du script Bash :

- `create_wordpress_project`: Télécharge et installe WordPress via WP-CLI.
- `create_laravel_project`: Installe un projet Laravel et configure l'environnement.
- `create_from_github`: Clone un projet depuis un dépôt GitHub.
- `create_from_scratch`: Crée un projet PHP minimaliste.

### Makefile

Le Makefile comprend plusieurs commandes pour gérer le cycle de vie du projet avec DDEV :

- `make help` : Affiche l'aide des commandes disponibles.
- `make up` / `make start` : Démarre le projet.
- `make stop` / `make do` : Arrête le projet.
- `make restart` : Redémarre le projet DDEV.
- `make stop-all` : Arrête tous les projets
- `make logs` : Affiche les logs.
- `make php` : Se connecter au conteneur PHP en tant qu'utilisateur www-data.
- `make exa` : Se connecter au conteneur PHP en tant qu'utilisateur root.
- `make info` : Affiche les informations de l'application.
- `make ssh` : Ouvre une session SSH dans le conteneur principal.
- `make mysql` : Se connecter à la base de données MySQL.
- `make composer` : Exécuter une commande Composer.
- `make install` : Installer les dépendances Composer.
- `make clean` : Nettoyer les fichiers temporaires et les conteneurs.
- `make config` : Recharger la configuration DDEV.
- `make reload` : Recharger les services sans redémarrer les conteneurs.
- `make createdb` : Créer une base de données.

