# WakyGut - Solution Professionnelle de Suivi Digestif

<div align="center">

**L'application mobile intelligente pour le suivi médical des troubles digestifs**

*Conçue pour les patients et leurs gastro-entérologues*

</div>

---

## 🎯 Vue d'ensemble

**WakyGut** est une application mobile médicale de nouvelle génération qui révolutionne le suivi des troubles digestifs chroniques. Développée avec Flutter et fonctionnant 100% offline-first, elle permet aux patients souffrant de pathologies digestives (Crohn, SII, MICI, intolérances alimentaires) de documenter précisément leurs symptômes et d'identifier les corrélations alimentaires, tout en générant des rapports médicaux professionnels pour leurs spécialistes.

### 💼 Proposition de valeur

**Pour les établissements de santé :**
- Améliore la qualité des consultations avec des données structurées et fiables
- Réduit le temps de diagnostic grâce à l'analyse automatique des patterns
- Facilite le suivi longitudinal des patients entre les consultations
- Génère des rapports PDF prêts à intégrer dans les dossiers médicaux

**Pour les patients :**
- Interface intuitive en français, accessible à tous
- Fonctionne sans connexion internet (données sécurisées en local)
- Aide concrète à l'identification des aliments problématiques
- Motivation par un système de récompenses gamifié

---

## ✨ Fonctionnalités principales

### 📊 Suivi médical complet

#### 🍽️ Journal alimentaire détaillé
- **Enregistrement précis des repas** avec horodatage automatique
- **Catégorisation** : Petit-déjeuner, déjeuner, dîner, collation
- **Suivi des quantités** : Légère, normale, copieuse
- **Liste d'aliments personnalisée** avec suggestions intelligentes basées sur l'historique
- **Notes additionnelles** pour chaque repas
- **Rappels programmables** pour ne pas oublier de documenter

#### 😣 Tracking des douleurs et symptômes
- **Échelle d'intensité** de 1 à 5
- **Localisation précise** : Abdomen supérieur/inférieur, côtés gauche/droit, central, généralisé
- **État digestif** au moment de la douleur : à jeun, post-prandial, autre
- **Symptômes associés** :
  - Ballonnements, nausées, crampes, brûlures
  - Diarrhée, constipation, gaz, reflux
  - Fatigue et autres manifestations
- **Lien automatique** avec les repas précédents (dans les 6 heures)
- **Identification des douleurs habituelles** vs inhabituelles

#### 📝 Journal quotidien global
- **État général** : Excellente journée → Très mauvaise journée
- **Niveau de stress** (1-5)
- **Niveau de fatigue** (1-5)
- **Qualité du sommeil** + heures dormies
- **Transit intestinal** : Normal, diarrhée, constipation, alternance
- **Nombre de selles**
- **Médicaments pris**
- **Notes libres** pour contexte supplémentaire

### 🧠 Intelligence artificielle et analyse

#### 🔍 Détection automatique des patterns
- **Corrélation repas-douleurs** : Identification automatique des aliments à risque
- **Analyse chronologique** : Visualisation de la séquence complète des événements
- **Aliments problématiques** : Scoring automatique basé sur les associations avec les douleurs
- **Historique complet** : Navigation par date avec calendrier intuitif

#### 📈 Statistiques et insights
- **Tendances de douleur** : Intensité moyenne, fréquence, évolution dans le temps
- **Analyse du bien-être** : Stress, fatigue, qualité de sommeil
- **Suivi de l'assiduité** : Streaks de remplissage, motivation
- **Métriques de santé** : Nombre de crises, jours sans douleur

### 📄 Export médical professionnel

#### 📋 Rapports PDF multi-pages
L'export génère un document médical complet comprenant :

1. **Page 1 - Tableau des douleurs déclarées**
   - Date/heure, intensité, localisation
   - État digestif et symptômes associés
   - Notes et contexte

2. **Page 2 - Rapports journaliers**
   - Vue d'ensemble du bien-être quotidien
   - Stress, fatigue, sommeil, transit
   - Médicaments et observations

3. **Page 3 - Tableau des repas planifiés**
   - Tous les repas documentés avec détails
   - Composition, quantités, notes

4. **Page 4 - Aliments à risque**
   - Liste des aliments fréquemment associés aux douleurs
   - Statistiques de corrélation

5. **Page 5 - Vue chronologique avec analyse**
   - Timeline complète repas + douleurs
   - **Mise en évidence visuelle** :
     - 🔴 **Rouge** : Repas précédant immédiatement une douleur
     - 🟠 **Orange** : Repas d'avant celui en rouge
   - Identification rapide des patterns alimentaires

**Formats d'export :**
- Aperçu instantané dans l'application
- Partage par email, WhatsApp, etc.
- Impression directe
- Sauvegarde dans les fichiers

### 🎮 Gamification et motivation

#### 🐱 Système de récompenses "Cat Gallery"
- **Collection de 100+ chats** adorables et optimisés
- **Déblocage progressif** : Un nouveau chat par jour de journal rempli
- **Système de rareté** : Découvertes uniques vs doublons
- **Galerie personnelle** avec statistiques de complétion

#### 🏆 Système d'achievements
- **Badges de streak** : 3, 7, 14, 30, 60, 100 jours consécutifs
- **Badges de journal** : 10, 30, 60, 100 entrées quotidiennes
- **Badges de repas** : 50, 100, 250, 500 repas documentés
- **Badges de suivi** : Engagement dans la documentation des douleurs
- **Badges spéciaux** : Premier rapport, explorateur, perfectionniste

### ⚙️ Paramètres et personnalisation

- **Thèmes** : Mode clair / sombre / automatique
- **Taille du texte** : Ajustable pour accessibilité
- **Rappels intelligents** : 
  - Configuration des horaires des repas
  - Notifications personnalisées
  - Désactivation possible
- **Retour haptique** : Feedback tactile configurable
- **Fenêtre de liaison repas-douleur** : Paramétrable (par défaut 6h)
- **Langue** : Interface en français

---

## 🏥 Cas d'usage médicaux

### Pour les gastro-entérologues
- **Gain de temps en consultation** : Données déjà structurées et analysées
- **Précision diagnostique** : Journal détaillé sur plusieurs semaines/mois
- **Identification des triggers** : Patterns alimentaires visualisés automatiquement
- **Suivi thérapeutique** : Évaluation de l'efficacité des traitements
- **Documentation médico-légale** : Rapports horodatés et complets

### Pour les patients
- **Maladies inflammatoires chroniques** : Crohn, rectocolite hémorragique
- **Syndrome de l'intestin irritable (SII)**
- **Intolérances alimentaires** : FODMAP, gluten, lactose
- **Gastroparésie**
- **Diverticulite**
- **Investigation de symptômes inexpliqués**

---

## 🔒 Sécurité et confidentialité

### Protection des données
- ✅ **Stockage 100% local** : Aucune donnée n'est envoyée sur internet
- ✅ **Base de données Isar chiffrée** : Données protégées sur l'appareil
- ✅ **Pas de compte requis** : Aucune authentification externe
- ✅ **Conforme RGPD** : Données sous contrôle total de l'utilisateur
- ✅ **Export sécurisé** : PDF généré localement, partage manuel seulement

### Offline-first
- ✅ Fonctionne sans connexion internet
- ✅ Idéal pour les zones à faible couverture
- ✅ Pas de risque de perte de données par problème réseau
- ✅ Performances optimales en toutes circonstances

---

## 🛠️ Architecture technique

### Technologies de pointe
- **Framework** : Flutter 3.10+ (Dart)
- **Base de données** : Isar 3.1 (NoSQL haute performance)
- **State Management** : Riverpod 2.5 (architecture propre)
- **Génération PDF** : PDF 3.11 avec mise en page professionnelle
- **Localisation** : Intl avec support français complet
- **Notifications** : Flutter Local Notifications avec timezone

### Compatibilité
- ✅ **Android** : 5.0+ (API 21+)
- ✅ **iOS** : 12.0+
- ✅ **Multi-plateforme** : Code unique pour tous les devices
- ⚡ **Performances optimisées** : Images compressées, base de données indexée

### Maintenance et évolutivité
- Code modulaire et documenté
- Architecture en couches (Core / Features / Shared)
- Tests unitaires et d'intégration
- Génération de code automatisée (build_runner)

---

## 📱 Captures d'écran

*[Emplacement pour captures d'écran de l'interface]*

---

## 🚀 Déploiement

### Installation
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Build de production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📞 Contact commercial

Pour intégrer WakyGut dans votre établissement de santé ou pour toute question concernant les licences professionnelles :

- **Email** : contact@wakygut.health
- **Website** : www.wakygut.health
- **Support** : support@wakygut.health

---

## 📄 Licence

Copyright © 2026 WakyGut. Tous droits réservés.

Ce logiciel est protégé par le droit d'auteur. Voir le fichier LICENSE pour plus de détails.

---

## 🙏 Contribution

Développé avec ❤️ pour améliorer la qualité de vie des patients souffrant de troubles digestifs chroniques.

*WakyGut - Votre allié digestif au quotidien*
