# Opencode Skills Manager

Ce dépôt contient un système de gestion des skills pour opencode, avec installation et mise à jour depuis GitHub.

## Structure
```
.
├── opencode             # Script principal
├── skills/              # Dossier des skills installés
│   └── git-workflow/    # Exemple de skill
│       ├── SKILL.md     # Fichier de configuration du skill
│       └── migrations/  # Scripts de migration
│           └── v1.0.0_to_v1.1.0.sh
```

## Commandes disponibles

### 1. Installer un skill
```bash
./opencode install <skill> [version]
```
Exemple :
```bash
./opencode install git-workflow
```

### 2. Mettre à jour un skill
```bash
./opencode update <skill>
```
Exemple :
```bash
./opencode update git-workflow
```

### 3. Vérifier les mises à jour disponibles
```bash
./opencode check-updates
```

## Configuration
Remplace `<ton-user>` dans le script `opencode` par ton nom d'utilisateur GitHub.

## Exemple d'utilisation
1. Installer un skill :
   ```bash
   ./opencode install git-workflow
   ```
2. Vérifier les mises à jour :
   ```bash
   ./opencode check-updates
   ```
3. Mettre à jour un skill :
   ```bash
   ./opencode update git-workflow
   ```
