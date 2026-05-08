#!/bin/bash
# Migration git-workflow: 1.0.0 → 1.1.0
# Ajoute une règle pour les commits signés

set -e  # Quit on error

# Vérifie la version actuelle
CURRENT_VERSION=$(grep -m1 "^version:" SKILL.md | cut -d' ' -f2)
if [ "$CURRENT_VERSION" != "1.0.0" ]; then
  echo "Erreur: version actuelle est $CURRENT_VERSION (attendu: 1.0.0)"
  exit 1
fi

# Sauvegarde
cp SKILL.md SKILL.md.bak

# Applique les changements
echo "Ajout de la règle git_commit_signing..."
sed -i '/rules:/a\  git_commit_signing: "required"' SKILL.md

# Met à jour la version
sed -i 's/version: 1.0.0/version: 1.1.0/' SKILL.md

echo "Migration terminée: 1.0.0 → 1.1.0"
