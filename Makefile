.DEFAULT_GOAL := help
.PHONY: help

# Commande par défaut pour afficher l'aide
help: ## Display help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

create: # Create a project
	@./.tools/create_project.sh

update: # Update the files
	git pull

purge: # Remove all sites
	@echo "Tous les sites vont être supprimés, êtes-vous sûr? [Y/N]"; \
	read response; \
	if [ "$$response" = "Y" ]; then \
	  	ddev poweroff; \
		rm -R ./sites; \
	  	ddev poweroff; \
		mkdir sites; \
	fi

remove-git: # Remove the git repository
	rm -R .git

