# ⚡ BatteryOptimizer PRO ULTRA — Hibernation Intelligente

**Le gestionnaire d'hibernation et d'économie d'énergie le plus complet jamais écrit en `.bat` pur.**

Pas de service tiers, pas d'installateur douteux, pas de logiciel qui traîne en tâche de fond à consommer de la RAM pour rien. Un seul fichier `.bat`, auto-élevé, qui pilote Windows avec précision chirurgicale : hibernation pure (zéro veille classique, zéro décharge fantôme), surveillance d'inactivité avec alerte visuelle annulable, **détection de coupure secteur en temps réel avec sauvegarde d'urgence**, et tout un arsenal d'optimisations système et de réparations courantes — le tout piloté depuis un menu numéroté, sans jamais quitter la console.

Ce script ne se contente pas de "mettre en veille". Il **hiberne** — c'est-à-dire qu'il sauvegarde l'intégralité de l'état de la RAM sur le disque puis coupe complètement l'alimentation. Résultat : batterie à 0% de décharge quand l'ordinateur est éteint, et un redémarrage qui restitue exactement l'état de travail précédent, fenêtres et documents ouverts compris.

---

## 📦 Sommaire

- [Pourquoi ce script](#-pourquoi-ce-script)
- [Fonctionnalités clés](#-fonctionnalités-clés)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Guide du menu principal](#-guide-du-menu-principal)
  - [1 — Configurer l'hibernation intelligente](#1--configurer-lhibernation-intelligente)
  - [2 — Appliquer les optimisations batterie](#2--appliquer-les-optimisations-batterie)
  - [3 — Hiberner maintenant](#3--hiberner-maintenant)
  - [4 — Désactiver et supprimer l'hibernation auto](#4--désactiver-et-supprimer-lhibernation-auto)
  - [5 — Voir le statut complet de la batterie](#5--voir-le-statut-complet-de-la-batterie)
  - [6 — Nettoyer et accélérer le démarrage](#6--nettoyer-et-accélérer-le-démarrage)
  - [7 — Réparer la souris lente après hibernation](#7--réparer-la-souris-lente-après-hibernation)
  - [8 — Tout en un](#8--tout-en-un)
  - [9 — Gérer les seuils de court-circuit (coupure électrique)](#9--gérer-les-seuils-de-court-circuit-coupure-électrique)
- [Comment fonctionne le gardien en arrière-plan](#-comment-fonctionne-le-gardien-en-arrière-plan)
- [Fichiers créés par le script](#-fichiers-créés-par-le-script)
- [Désinstallation](#-désinstallation)
- [FAQ / Points d'attention](#-faq--points-dattention)
- [Avertissement](#-avertissement)

---

## 🎯 Pourquoi ce script

La veille classique de Windows continue de consommer de la batterie (RAM alimentée, réseau parfois actif, "Modern Standby" qui réveille le PC en arrière-plan). Sur un portable qu'on ferme sans éteindre, ça peut vider une batterie en une nuit.

Ce script part d'un principe simple : **la seule vraie économie, c'est l'extinction complète.** Il configure donc Windows pour ne plus jamais partir en veille classique, et automatise l'hibernation (RAM → disque → coupure totale) selon deux déclencheurs intelligents :

- **Inactivité** : plus personne n'utilise le PC depuis X temps → hibernation, après confirmation visuelle.
- **Coupure de courant / batterie critique** : le secteur est débranché ou le niveau de charge est dangereusement bas → alerte immédiate avec sauvegarde d'urgence, pour ne jamais perdre de travail.

Le tout tourne en fond via une **tâche planifiée Windows persistante**, pas un simple minuteur qui meurt à la fermeture de la fenêtre.

---

## ✨ Fonctionnalités clés

- 🔋 **Hibernation pure** — désactive totalement la veille classique et l'hybride ; seule l'hibernation réelle est utilisée.
- ⏱️ **Minuterie d'inactivité configurable** en secondes, minutes, heures, ou heures:minutes, avec alerte visuelle 30 secondes annulable au moindre mouvement de souris/clavier.
- 🔌 **Détection de coupure secteur en temps réel** — une fenêtre d'alerte demande confirmation avant d'hiberner pour sauvegarder le travail, et **s'annule automatiquement dès que le chargeur est rebranché**, sans attendre la fin du décompte.
- 🪫 **Seuils de batterie personnalisables ("court-circuit")** — définis un délai de sécurité différent selon le niveau de charge restant (ex : 15s au-dessus de 30%, 7s en dessous, 3s en dessous de 5%) : plus la batterie est faible, plus la réaction est rapide.
- 🖱️ **Réparation automatique de la souris lente** après un réveil d'hibernation (bug USB bien connu sous Windows).
- 🚀 **Accélération du démarrage** — BIOS/UEFI, apps inutiles au démarrage, Fast Boot, nettoyage des caches, services allégés.
- 🧹 **13 optimisations batterie et performance** en un clic : Modern Standby désactivé, plan d'alimentation ajusté, RAM, télémétrie, GPU Optimus, réseau, SSD (TRIM), effets visuels, Wi-Fi, latence de sortie, nettoyage temporaire, mise en veille de l'écran/disque.
- 📊 **Rapports batterie natifs Windows** (`powercfg /batteryreport` et `/energy`) générés directement sur le Bureau.
- 🛡️ **Auto-élévation administrateur silencieuse** — pas besoin de faire "Exécuter en tant qu'administrateur" à la main.
- 🧩 **Tout piloté par menu numéroté**, en français, sans aucune ligne de commande à taper à la main.
- 🗑️ **Désinstallation propre en un clic**, qui arrête et supprime tout ce que le script a mis en place.

---

## ✅ Prérequis

- Windows 10 ou Windows 11 (testé et pensé pour les deux).
- Droits administrateur sur la session (le script les demande lui-même via une fenêtre UAC).
- PowerShell disponible (présent par défaut sur toute installation Windows moderne).
- Fonctionne aussi bien sur PC portable (batterie) que sur PC fixe (les fonctions liées à la batterie sont silencieusement ignorées si aucune batterie n'est détectée).

---

## 🚀 Installation

1. Télécharge `Hibernation_AND_BatterieOptimizer.bat` depuis ce dépôt.
2. Double-clique dessus.
3. Une fenêtre UAC apparaît (élévation administrateur) — accepte-la. C'est automatique, tu n'as rien à configurer.
4. Le menu principal s'affiche. Tout se passe depuis là.

> Le script recrée automatiquement son dossier de configuration (`%LOCALAPPDATA%\BatteryOptimizerULTRA`) à chaque lancement s'il n'existe pas encore, donc aucune étape d'installation manuelle n'est nécessaire.

---

## 📋 Guide du menu principal

Au lancement, un écran récapitulatif indique la configuration d'hibernation actuellement active (ou son absence), puis affiche le menu suivant :

```
[1] Configurer l'hibernation Intelligente (Alerte 30s)
[2] Appliquer les optimisations batterie (RECOMMANDE)
[3] Hiberner MAINTENANT (Sauvegarde & Extinction)
[4] Desactiver et Supprimer l'hibernation auto
[5] Voir le statut complet de la batterie
[6] Nettoyer et accelerer le demarrage
[7] Reparer la souris lente apres hibernation
[8] TOUT EN UN (Optimisations + Boot + Config Hibern.)
[9] Gerer les seuils de court-circuit (Coupure Elec.)
[0] Quitter
```

### 1 — Configurer l'hibernation intelligente

Le cœur du script. Ce menu :

1. Te demande l'**unité de temps d'inactivité** souhaitée : Secondes (`S`), Minutes (`M`), Heures (`H`), ou Heures:Minutes (`HM`, ex : `1:30` pour 1h30).
2. Convertit ta saisie en secondes et te demande confirmation.
3. Génère un script PowerShell de surveillance (`hib_watch.ps1`) taillé sur mesure pour ta configuration.
4. Installe une **tâche planifiée Windows** (`BatteryOptimizer_AutoHibernate`) qui lance ce script de surveillance :
   - au démarrage de session (`AtLogOn`),
   - et se relance automatiquement toutes les 5 minutes en filet de sécurité (au cas où le processus s'arrêterait pour une raison quelconque).
5. Désactive la veille classique et l'hibernation "native" de Windows (celle gérée par `powercfg`), pour laisser le gardien du script prendre le relais intelligemment.

Une fois configuré, **deux mécanismes tournent en permanence en arrière-plan**, sans fenêtre visible (processus caché) :

- **La minuterie d'inactivité** : dès que le temps d'inactivité que tu as choisi est atteint, une fenêtre apparaît avec un compte à rebours de 30 secondes ("Hibernation automatique dans X secondes..."). Le moindre mouvement de souris ou frappe clavier annule automatiquement le compte à rebours (avec un court message "Activité détectée, reprise dans 5s..."). Si personne n'intervient, l'hibernation se déclenche à la fin des 30 secondes.
- **L'alerte énergie** : voir plus bas, "Comment fonctionne le gardien".

### 2 — Appliquer les optimisations batterie (RECOMMANDÉ)

Applique en une seule fois **13 optimisations système** pensées pour maximiser l'autonomie et la réactivité :

| # | Optimisation |
|---|---|
| 1 | Active l'hibernation Windows et fixe sa taille de fichier |
| 2 | Désactive la Veille Connectée / Modern Standby (source majeure de décharge fantôme) |
| 3 | Ajuste le plan d'alimentation (throttling processeur : économique sur batterie, plein régime sur secteur) |
| 4 | Optimise la gestion mémoire (pagination, cache système) |
| 5 | Désactive les services inutiles en tâche de fond (SysMain/Superfetch, télémétrie DiagTrack, CDPSvc) |
| 6 | Force le GPU Optimus en mode économique (portables avec carte graphique dédiée) |
| 7 | Réduit la consommation réseau (Delivery Optimization, TCP autotuning) |
| 8 | Préserve la durée de vie du SSD (TRIM, défragmentation planifiée désactivée) |
| 9 | Désactive les animations et effets visuels superflus |
| 10 | Passe le Wi-Fi en économie d'énergie maximale sur batterie |
| 11 | Optimise la latence de sortie de veille |
| 12 | Nettoie les fichiers temporaires (`%TEMP%`, `C:\Windows\Temp`, Prefetch) |
| 13 | Configure l'extinction intelligente de l'écran et du disque selon la source d'alimentation |

Un redémarrage est conseillé après cette étape pour que la désactivation du Modern Standby soit pleinement effective.

### 3 — Hiberner maintenant

Déclenche une hibernation immédiate, avec confirmation avant exécution. Équivalent manuel de ce que fait le gardien automatiquement.

### 4 — Désactiver et supprimer l'hibernation auto

Arrête proprement tout ce que l'option [1] a mis en place :
- Signale au(x) processus de surveillance en cours de s'arrêter.
- Arrête et désinstalle la tâche planifiée Windows.
- Tue les éventuels processus PowerShell résiduels liés au gardien.
- Supprime le script de surveillance généré et réinitialise la configuration enregistrée.

Le PC repasse alors en gestion d'énergie "manuelle" (plus aucune hibernation automatique).

### 5 — Voir le statut complet de la batterie

Affiche le niveau de charge actuel (avec avertissement si sous 30%) et génère deux rapports natifs Windows directement sur le Bureau :
- `rapport_batterie.html` — historique de capacité et de cycles de charge.
- `energie_rapport.html` — diagnostic des problèmes d'efficacité énergétique (`powercfg /energy`).

Propose de les ouvrir immédiatement dans le navigateur par défaut.

### 6 — Nettoyer et accélérer le démarrage

Demande le délai de timeout BIOS/UEFI souhaité (en secondes), puis :
1. Applique ce timeout via `bcdedit`.
2. Supprime les entrées de démarrage automatique inutiles (OneDrive, Skype, Spotify, Discord, Teams).
3. Active le Fast Boot (démarrage rapide basé sur l'hibernation partielle du noyau).
4. Nettoie Prefetch et les dossiers temporaires.
5. Passe certains services lourds en démarrage différé (Windows Update, Windows Search, service d'entrée tablette).
6. Vide le cache DNS.

### 7 — Réparer la souris lente après hibernation

Corrige un bug classique de Windows où la souris devient saccadée ou lente après un réveil d'hibernation :
1. Désactive la suspension sélective USB (cause principale du bug).
2. Ajuste le registre des hubs USB et périphériques HID.
3. Réinitialise la précision et l'accélération de la souris.
4. Ajuste la sensibilité du pointeur.
5. Redémarre le service HID pour forcer une réinitialisation propre.

### 8 — TOUT EN UN

Le raccourci ultime : enchaîne automatiquement les optimisations (option 2), les réparations souris/USB (option 7), la configuration du démarrage (option 6), génère les rapports batterie (option 5), puis t'amène directement à la configuration de l'hibernation intelligente (option 1). Idéal pour une première installation complète en une seule passe.

### 9 — Gérer les seuils de court-circuit (Coupure Élec.)

C'est ici que se règle la réactivité de l'**alerte de coupure secteur** (voir section suivante pour comprendre son fonctionnement). Un délai de base s'applique tant que la batterie est au-dessus de tous les seuils définis ; chaque seuil ajouté permet de réagir plus vite à mesure que la batterie descend.

Exemple de configuration par défaut :

| Condition | Délai avant demande de confirmation |
|---|---|
| Batterie > 30% | 15 secondes |
| Batterie ≤ 30% | 7 secondes |
| Batterie ≤ 15% | 5 secondes |
| Batterie ≤ 5% | 3 secondes |

Sous-menu disponible :
- **[1] Modifier le délai de base**
- **[2] Modifier le délai d'un seuil existant**
- **[3] Ajouter un nouveau seuil** (ex : "à 40% de batterie, hiberner en 10 secondes si coupure")
- **[4] Supprimer un seuil existant**
- **[0] Retour au menu principal**

Chaque modification propose de l'appliquer immédiatement au gardien déjà actif, sans avoir à tout reconfigurer depuis l'option [1].

---

## 🛡️ Comment fonctionne le gardien en arrière-plan

Une fois l'hibernation configurée (option 1), un script PowerShell (`hib_watch.ps1`) tourne en continu, sans fenêtre visible, et vérifie toutes les quelques secondes deux choses :

**1. L'inactivité.** Il mesure le temps écoulé depuis la dernière frappe clavier ou mouvement de souris (API Windows `GetLastInputInfo`). Dès que ce temps dépasse le seuil configuré, une fenêtre d'alerte apparaît avec un compte à rebours de 30 secondes, annulable au moindre geste.

**2. L'état de l'alimentation.** Il surveille en continu si le PC est sur batterie ou sur secteur, et le niveau de charge restant. Si le secteur est débranché (ou la batterie atteint un seuil critique défini dans le menu [9]), une fenêtre **"ALERTE ENERGIE"** apparaît immédiatement :

> *"Le courant ne fonctionne plus. L'ordinateur va s'éteindre pour sauver vos données. Voulez-vous cela ?"*

avec un compte à rebours dont la durée dépend du niveau de batterie (voir menu [9]) et deux boutons **Oui** / **Non**.

- Cliquer **Oui**, ou laisser le décompte arriver à zéro → hibernation immédiate (sauvegarde de l'état + extinction).
- Cliquer **Non** → annulation ; une nouvelle alerte ne réapparaîtra que si la situation s'aggrave (nouveau débranchement, ou passage à un seuil de batterie plus critique).
- **Rebrancher le chargeur pendant le décompte** → la fenêtre se ferme **automatiquement**, comme si "Non" avait été cliqué, sans attendre la fin du compte à rebours. La détection du secteur est instantanée (vérifiée à chaque seconde via l'état natif d'alimentation de Windows), donc aucune hibernation ne se déclenche par erreur juste parce que tu as été assez rapide pour rebrancher.

Tout est journalisé dans `hib_watch.log` (dates, événements, décisions) pour pouvoir vérifier après coup ce qui s'est passé.

> **Robustesse au démarrage** : le gardien ne peut jamais déclencher une hibernation avant que le délai configuré se soit *réellement* écoulé depuis son propre lancement — même si l'ordinateur venait de démarrer et que le compteur d'inactivité système semblait déjà élevé. Ça évite les faux déclenchements juste après un allumage ou une reprise de session.

---

## 🗂️ Fichiers créés par le script

Tout est centralisé dans un seul dossier, rien n'est dispersé dans le système :

```
%LOCALAPPDATA%\BatteryOptimizerULTRA\
├── hib_watch.ps1          → Script de surveillance généré (inactivité + alerte énergie)
├── install_task.ps1       → Script d'installation de la tâche planifiée
├── uninstall_task.ps1     → Script de désinstallation propre
├── cancel_hibernate.flag  → Fichier "drapeau" utilisé pour signaler l'arrêt du gardien
├── hib_watch.log          → Journal des événements (inactivité, alertes, hibernations)
├── battery_config.ini     → Configuration du délai d'inactivité choisi
└── battery_tiers.ini      → Seuils de batterie / délais de l'alerte énergie
```

Une tâche planifiée Windows nommée **`BatteryOptimizer_AutoHibernate`** est visible dans le Planificateur de tâches Windows tant que l'hibernation intelligente est active.

Les rapports batterie (`rapport_batterie.html`, `energie_rapport.html`) sont générés sur le **Bureau** de l'utilisateur.

---

## 🧹 Désinstallation

Deux façons de tout retirer proprement :

- **Depuis le script** : option **[4] Désactiver et Supprimer l'hibernation auto** dans le menu principal.
- **Manuellement** : supprimer la tâche planifiée `BatteryOptimizer_AutoHibernate` depuis le Planificateur de tâches Windows, puis supprimer le dossier `%LOCALAPPDATA%\BatteryOptimizerULTRA`.

Les optimisations système appliquées via les options [2], [6] et [8] (registre, services, plan d'alimentation) ne sont pas automatiquement annulées par l'option [4], puisqu'il s'agit de réglages système indépendants de la surveillance d'hibernation elle-même.

---

## ❓ FAQ / Points d'attention

**Le script demande les droits administrateur, est-ce normal ?**
Oui — il modifie le registre, gère des tâches planifiées, et pilote l'alimentation système. Il s'auto-élève silencieusement au lancement, sans action nécessaire de ta part au-delà d'accepter l'invite UAC.

**Puis-je changer le délai d'inactivité sans tout réinstaller ?**
Oui, repasse simplement par l'option [1] et resaisis une nouvelle durée : le gardien est automatiquement régénéré et relancé avec la nouvelle configuration.

**Est-ce que ça fonctionne sur un PC fixe sans batterie ?**
Oui. Les fonctions liées à la batterie (alerte énergie, seuils, rapport batterie) sont ignorées silencieusement si aucune batterie n'est détectée ; la minuterie d'inactivité fonctionne indépendamment.

**Le compte à rebours ne s'annule pas assez vite au rebranchement ?**
La détection du secteur est vérifiée chaque seconde via l'état d'alimentation natif de Windows (le même mécanisme que la pastille "branché/sur batterie" de la barre des tâches) — c'est la méthode la plus réactive disponible sous Windows, sans dépendance à un cache qui pourrait retarder la détection.

**Une modification du `.bat` ne semble pas prise en compte ?**
Le fichier `.bat` ne fait que *générer* le script de surveillance et la tâche planifiée. Toute modification du `.bat` ne s'applique réellement qu'après être repassé par l'option [1] (ou [8]), qui régénère et relance le gardien avec le code à jour.

---

## ⚠️ Avertissement

Ce script modifie des paramètres système sensibles (registre, plan d'alimentation, tâches planifiées, services Windows). Il est fourni tel quel, sans garantie. Il est recommandé de comprendre les options avant de les appliquer sur une machine de production, et de conserver une sauvegarde de tes données importantes — comme pour tout script qui touche à l'alimentation et à l'extinction automatique d'un ordinateur.

---

*Fait avec ❤️ et beaucoup de `echo >>` pour tous ceux qui en ont marre de retrouver leur batterie à plat après une nuit en "veille".*
