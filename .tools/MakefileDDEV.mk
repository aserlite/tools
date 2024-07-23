.DEFAULT_GOAL := help
.PHONY: help up start restart logs stop php exa info ssh mysql drush composer install clean config reload

# Commande par défaut pour afficher l'aide
help: ## Display help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Démarrer le projet
up: ## Start Project
	ddev start

start: up ## Alias for up

# Redémarrer le projet
restart: ## Restart Ddev
	ddev restart

# Afficher les logs
logs: ## Logs
	ddev logs -f

# Arrêter le projet
do: ## Stop Project
	ddev stop

stop: do ## Alias for do

stop-all: # Stop all projects
	ddev poweroff

# Se connecter au conteneur PHP en tant qu'utilisateur www-data
php: ## Connect to PHP
	ddev exec --user=www-data php /bin/bash

# Se connecter au conteneur PHP en tant qu'utilisateur root
exa: ## Connect to PHP Admin
	ddev exec --user=root php /bin/bash

# Afficher les informations de l'application
info: ## Display application information
	ddev describe

# Ouvrir une session SSH dans le conteneur principal
ssh: ## SSH into the main container
	ddev ssh

# Se connecter à la base de données MySQL
mysql: ## Connect to MySQL
	ddev mysql

# Exécuter une commande Composer
composer: ## Run Composer commands
	ddev composer $(cmd)

# Installer les dépendances Composer
install: ## Install Composer dependencies
	ddev composer install

# Nettoyer les fichiers temporaires et les conteneurs
clean: ## Clean temporary files and containers
	ddev stop && ddev poweroff

# Recharger la configuration DDEV
config: ## Reload DDEV configuration
	ddev config

# Recharger les services sans redémarrer les conteneurs
reload: ## Reload services without restarting containers
	ddev restart --no-cache

# Créer une base de données
createdb: ## Create database
	ddev exec mysql -e "CREATE DATABASE IF NOT EXISTS $(DB_NAME);"

