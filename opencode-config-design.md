# Conception de la config opencode globale

> Résumé de session — à reprendre avec Claude Code pour l'implémentation

---

## Objectif

Construire une config opencode **cross-projets** hébergée sur un repo GitHub public, installable via un script bootstrap. Le skill `init-project` est le seul skill global — il génère tout ce qui est spécifique au projet localement.

---

## Architecture des fichiers

### Global (`~/.config/opencode/`)

```
~/.config/opencode/
├── AGENTS.md                        ← comportement général de l'agent
├── opencode.json                    ← providers, MCP, instructions fixes
├── agents/
│   └── reviewer.md                  ← sous-agent de double check
└── skills/
    └── init-project/
        └── SKILL.md                 ← le seul skill global
```

### Généré dans le projet par `init-project`

```
<projet>/
├── AGENTS.md                        ← adapté au projet
└── .opencode/skills/
    ├── git-workflow/SKILL.md
    ├── mcp/SKILL.md
    ├── todoist/SKILL.md
    ├── sql-conventions/SKILL.md     ← si stack SQL
    ├── csharp-patterns/SKILL.md     ← si stack C#
    └── ...                          ← autres skills selon stack
```

---

## AGENTS.md global — contenu attendu

- **Langue** : communication avec l'utilisateur en français, code/commits/commentaires en anglais, thinking interne libre
- **Index des skills** : liste les skills dispo avec instructions de chargement **à la demande** (lazy loading — ne pas tout charger systématiquement)
- **Double check** : après chaque tâche, invoquer obligatoirement `@reviewer` avant de rendre la main à l'utilisateur

---

## reviewer.md — sous-agent global

- Mode : `subagent`
- Outils : lecture seule (pas de write/edit/bash)
- Rôle : relire le travail effectué par l'agent build, signaler les problèmes

---

## Skill init-project — comportement attendu

### Questions posées à l'utilisateur

1. Nom/préfixe projet (ex: `ONEGA`, `MAESTRO`) → utilisé pour les IDs Todoist
2. Stack technique → détermine quels skills générer
3. MCP à activer → lire la config opencode pour lister les MCP dispos, demander lesquels activer
4. BUILD_CHECK activé ou non

### Ce qu'il génère

- `AGENTS.md` projet adapté à la stack et aux choix
- Skills projet dans `.opencode/skills/` (versions adaptées des templates globaux)
- Le skill `mcp.md` avec uniquement les MCP retenus

---

## Flags dans AGENTS.md projet

```
BUILD_CHECK: true | false
```

Si `true` → l'agent lance un build après ses modifications pour valider.  
Si `false` → pas de build (utile quand le build est trop long/coûteux).

---

## Intégration Todoist (via MCP)

### IDs de tâches

- Format : `PREFIXE-N` (ex: `ONEGA-42`)
- Le numéro est calculé dynamiquement : liste les tâches existantes, prend le dernier numéro + 1
- Pas de compteur stocké — les trous sont acceptables

### Workflow

| Moment | Action |
|--------|--------|
| Démarrage de session | Résumé des tâches en cours + backlog prioritaire |
| Début de tâche | Créer ou passer la tâche en "en cours" |
| Fin de tâche | @reviewer valide → tâche marquée terminée |
| Bug détecté | Créer une tâche bug avec contexte (fichier, description, sévérité) |
| Spec manquante | Créer une tâche dans le backlog |
| Build KO ou review KO | Créer une sous-tâche de fix |
| Travail identifié dans le code (TODO, dette technique) | Créer une tâche backlog |

---

## Installation / Distribution

### Repo GitHub public

```
opencode-config/
├── AGENTS.md
├── opencode.json
├── agents/
│   └── reviewer.md
├── skills/
│   └── init-project/
│       └── SKILL.md
└── install.sh
```

### Script install.sh

- Clone le repo
- Crée les symlinks vers `~/.config/opencode/`
- Utilisable via :

```bash
curl -fsSL https://raw.githubusercontent.com/<user>/opencode-config/main/install.sh | bash
```

### Instructions distantes dans opencode.json

```json
{
  "instructions": [
    "https://raw.githubusercontent.com/<user>/opencode-config/main/AGENTS.md"
  ]
}
```

---

## Points ouverts / à décider

- Contenu détaillé de chaque skill technique (git-workflow, csharp-patterns, sql-conventions...)
- Organisation Todoist : projets, labels, sections à définir
- Quels MCP sont configurés globalement (Azure DevOps custom, Context7, filesystem, git...)
- Modèles assignés aux agents build/plan/reviewer

---

## Prochaine étape

Rédiger les fichiers dans cet ordre :
1. `AGENTS.md` global
2. `agents/reviewer.md`
3. `skills/init-project/SKILL.md`
4. Skills techniques (git, sql, csharp...)
5. `install.sh`
