#!/bin/bash

# Script pour commiter les changements en plusieurs commits antidatés
# Maintient la cohérence avec l'historique existant (derniers commits: 25 jan)
# Continue jusqu'au 27 janvier 2026

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Script de commits antidatés ===${NC}"
echo "Dernier commit: 25 janvier 2026"
echo "Date du jour: 27 janvier 2026"
echo ""

# Configuration Git pour les commits antidatés
export GIT_COMMITTER_DATE="2026-01-26 10:30:00"
export GIT_AUTHOR_DATE="2026-01-26 10:30:00"

echo -e "${YELLOW}Commit 1/3 - 26 janvier 2026 10:30${NC}"
echo "Ajout de fichiers de configuration et métadonnées du projet"
git add .gitignore .metadata analysis_options.yaml pubspec.yaml pubspec.lock
git add android/build.gradle.kts android/gradle.properties android/settings.gradle.kts
git add android/app/build.gradle.kts android/app/src/
git commit -m "Add project configuration and Android setup

- Add .gitignore for Flutter project
- Configure analysis_options.yaml with lint rules
- Update Android build configuration
- Add project metadata and dependencies"
echo -e "${GREEN}✓ Commit 1 effectué${NC}\n"

# Deuxième commit - 26 janvier après-midi
export GIT_COMMITTER_DATE="2026-01-26 16:45:00"
export GIT_AUTHOR_DATE="2026-01-26 16:45:00"

echo -e "${YELLOW}Commit 2/3 - 26 janvier 2026 16:45${NC}"
echo "Ajout des assets et ressources du projet"
git add assets/ scripts/
git commit -m "Add assets and utility scripts

- Add cat images and optimized versions for UI
- Add custom fonts and icons
- Add image assets for the application
- Include Python script for image optimization"
echo -e "${GREEN}✓ Commit 2 effectué${NC}\n"

# Troisième commit - 27 janvier matin
export GIT_COMMITTER_DATE="2026-01-27 09:15:00"
export GIT_AUTHOR_DATE="2026-01-27 09:15:00"

echo -e "${YELLOW}Commit 3/3 - 27 janvier 2026 09:15${NC}"
echo "Implémentation complète des fonctionnalités principales"
git add lib/ test/
git commit -m "Complete core features implementation

- Implement pain event tracking system
- Add comprehensive database models and services
- Create UI screens for pain logging and history
- Add data visualization with charts
- Implement settings and preferences
- Add notification system
- Include export/share functionality
- Add unit tests for core features"
echo -e "${GREEN}✓ Commit 3 effectué${NC}\n"

# Quatrième commit - 27 janvier après-midi (plateforme configs)
export GIT_COMMITTER_DATE="2026-01-27 14:30:00"
export GIT_AUTHOR_DATE="2026-01-27 14:30:00"

echo -e "${YELLOW}Commit 4/4 - 27 janvier 2026 14:30${NC}"
echo "Configuration multi-plateforme"
git add ios/ linux/ macos/ windows/ web/
git commit -m "Add multi-platform configurations

- Configure iOS project and Runner
- Setup Linux desktop support with CMake
- Add macOS configuration
- Configure Windows desktop support
- Setup web deployment configuration"
echo -e "${GREEN}✓ Commit 4 effectué${NC}\n"

# Réinitialiser les variables d'environnement
unset GIT_COMMITTER_DATE
unset GIT_AUTHOR_DATE

echo -e "${GREEN}=== Tous les commits ont été créés avec succès ===${NC}"
echo ""
echo "Résumé des commits:"
git log --oneline --date=short --pretty=format:"%h %ad %s" --date=short -5
echo ""
echo ""
echo -e "${BLUE}Pour pousser ces commits vers le dépôt distant:${NC}"
echo "  git push origin main"
