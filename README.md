# IA & Cloud Status Monitor

Monitoring automatisé des services IA et Cloud avec [Robot Framework](https://robotframework.org/).

Vérifie en temps réel la **disponibilité** et les **incidents** sur les principales plateformes.

---

## Services monitorés

### Intelligence Artificielle
| Service | Type de check |
|---------|--------------|
| Claude (Anthropic) | Disponibilité + Status Page |
| ChatGPT (OpenAI) | Disponibilité + Status Page |
| Gemini (Google) | Disponibilité |
| Mistral AI | Disponibilité |
| Perplexity | Disponibilité |
| HuggingFace | Disponibilité |

### Cloud
| Service | Type de check |
|---------|--------------|
| AWS | Disponibilité |
| Cloudflare | Disponibilité + Status Page |

---

## Installation

```bash
# Cloner le repo
git clone https://github.com/voidsponge/IA_Status_Robotframework.git
cd IA_Status_Robotframework

# Créer et activer le virtual environment
python3 -m venv venv
source venv/bin/activate        # Linux/Mac
# venv\Scripts\activate         # Windows

# Installer les dépendances
pip install robotframework robotframework-requests
```

---

## Utilisation

```bash
source venv/bin/activate

# Lancer tous les tests
robot --outputdir results/monitor tests/monitor/

# Seulement les services IA
robot --outputdir results --include ia tests/monitor/

# Seulement AWS & Cloudflare
robot --outputdir results --include cloud tests/monitor/

# Seulement les checks d'incidents
robot --outputdir results --include status tests/monitor/

# Seulement les checks de disponibilité
robot --outputdir results --include ping tests/monitor/
```

Les rapports HTML sont générés automatiquement dans le dossier `results/` :
- `report.html` — vue d'ensemble
- `log.html` — détail de chaque test

---

## Structure du projet

```
├── resources/
│   └── monitor.resource          # Keywords réutilisables (check endpoint, status page)
├── tests/
│   └── monitor/
│       ├── ai_services.robot     # Tests IA (Claude, ChatGPT, Gemini, Mistral...)
│       └── cloud_services.robot  # Tests Cloud (AWS, Cloudflare)
├── .gitignore
└── README.md
```

---

## Exemple de sortie

```
Claude Est Accessible              Claude: UP (status=403) | 160ms     | PASS |
ChatGPT Est Accessible             ChatGPT: UP (status=403) | 197ms   | PASS |
Gemini Est Accessible              Gemini: UP (status=200) | 485ms    | PASS |
Anthropic (Claude) N'a Pas D'incident    Anthropic: All Systems Operational  | PASS |
Cloudflare N'a Pas D'incident      Cloudflare: Minor Service Outage   | FAIL |
```

> Un status 403 signifie que le serveur répond mais bloque les requêtes automatisées — le service est **UP**. Seuls les status 5xx sont considérés comme **DOWN**.

---

## Tags disponibles

| Tag | Description |
|-----|-------------|
| `ia` | Tous les services IA |
| `cloud` | AWS & Cloudflare |
| `ping` | Checks de disponibilité |
| `status` | Checks d'incidents via status pages |
| `claude` | Claude / Anthropic |
| `chatgpt` | ChatGPT / OpenAI |
| `gemini` | Google Gemini |
| `mistral` | Mistral AI |
| `perplexity` | Perplexity |
| `huggingface` | HuggingFace |
| `aws` | Amazon Web Services |
| `cloudflare` | Cloudflare |

---

## Ajouter un service

Ajouter un nouveau service dans `tests/monitor/ai_services.robot` :

```robot
*** Variables ***
${NEW_SERVICE_URL}    https://new-service.com

*** Test Cases ***
New Service Est Accessible
    [Tags]    ia    new-service    ping
    Check Endpoint Responds    New Service    ${NEW_SERVICE_URL}
```

---

Built with Robot Framework
