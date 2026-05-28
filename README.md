# AOM Ground Transport Mobile

Application Flutter offline-first pour la gestion des missions de transport terrestre — AIR OCEAN MAROC.

---

## Prérequis

| Outil | Version minimale |
|-------|-----------------|
| Flutter | 3.16+ (stable) |
| Dart | 3.2+ |
| Android Studio / VS Code | Dernière version |
| Java (JDK) | 17 |
| Android SDK | API 21+ |

---

## 1. Installation de Flutter

```bash
# Télécharger Flutter SDK depuis https://flutter.dev/docs/get-started/install
# Puis ajouter au PATH

flutter --version         # Vérifier installation
flutter doctor            # Diagnostiquer l'environnement
```

---

## 2. Cloner / ouvrir le projet

```bash
# Ouvrir le dossier dans Android Studio ou VS Code
# Puis :

flutter pub get
```

---

## 3. Générer le code Drift (obligatoire au premier lancement)

```bash
dart run build_runner build --delete-conflicting-outputs
```

> Cette commande génère les fichiers `.g.dart` nécessaires à Drift (ORM SQLite).
> À relancer si vous modifiez `app_database.dart` ou un DAO.

---

## 4. Lancer en mode debug

```bash
# Sur émulateur Android ou appareil connecté
flutter run

# Sur un appareil spécifique
flutter devices
flutter run -d <device-id>
```

---

## 5. Générer un APK Android (release)

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter build apk --release
```

### Trouver l'APK généré

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 6. Installer l'APK sur un téléphone Android

### Via câble USB

```bash
# Activer le mode développeur sur le téléphone :
# Paramètres → À propos du téléphone → Numéro de build (appuyer 7 fois)
# Puis : Paramètres → Options développeur → Débogage USB

adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via transfert de fichier

1. Copier `app-release.apk` sur le téléphone (USB, email, WhatsApp…)
2. Ouvrir le fichier depuis le gestionnaire de fichiers
3. Si nécessaire : **Paramètres → Sécurité → Installer depuis sources inconnues** → Activer pour l'app utilisée

---

## 7. GitHub Actions (CI/CD)

Le workflow `.github/workflows/android-apk.yml` se déclenche automatiquement :
- à chaque push sur `main` ou `develop`
- manuellement via l'onglet **Actions** → **Build Android APK** → **Run workflow**

L'APK est disponible en artifact téléchargeable pendant 30 jours.

---

## 8. Troubleshooting courant

### `build_runner` — conflits
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Erreur `minSdkVersion`
Vérifier `android/app/build.gradle` : `minSdkVersion 21`

### WhatsApp ne s'ouvre pas
- Vérifier que WhatsApp est installé sur l'appareil
- Vérifier la déclaration `<queries>` dans `AndroidManifest.xml`

### `flutter doctor` — Android toolchain manquant
```bash
flutter doctor --android-licenses
```

### Erreur de signature APK (release)
Pour les tests, la config debug signing est utilisée (`signingConfig signingConfigs.debug`).
Pour un APK de production, générer un keystore :
```bash
keytool -genkey -v -keystore ~/aom-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aom
```

---

## Architecture

```
lib/
├── core/           — Thème, router, utilitaires (Haversine, dates)
├── data/           — Base Drift, modèles, repositories
├── domain/         — Services métier (distance, WhatsApp, missions)
└── presentation/   — Providers Riverpod, écrans Flutter
```

---

## Checklist APK installable

- [ ] `flutter doctor` sans erreurs critiques
- [ ] `dart run build_runner build` exécuté avec succès
- [ ] `flutter test` — tous les tests passent
- [ ] `flutter build apk --release` — sans erreur
- [ ] `app-release.apk` présent dans `build/app/outputs/flutter-apk/`
- [ ] APK transféré sur le téléphone
- [ ] **Sources inconnues** activé sur le téléphone (si installation hors Play Store)
- [ ] Application lancée — écran d'initialisation puis Dashboard
- [ ] Mission de démo visible dans l'historique
- [ ] Bouton WhatsApp ouvre WhatsApp avec message prérempli

---

## Données de démonstration préchargées

Au premier lancement, l'application insère automatiquement :

**Chauffeurs :** Youssef, Chauffeur 2, 3, 4  
**Véhicules :** Mercedes AOM-001, AOM-002, 003, 004  
**Passagers :** Mr Fouad (CDB/Salé), Mr Mehdi (Copilote/Mohammedia), Saida (Hôtesse/Casa)  
**Destinations :** GMMN, GMME, GMMB, GMMX, GMFF, GMTT, GMTN + points de pickup  
**Mission démo :** AOM-2024-001 — Départ GMMB avec itinéraire complet généré
