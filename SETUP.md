# Guide de mise en place rapide

## Méthode recommandée (scaffold + overlay)

### Étape 1 — Créer le projet Flutter de base

```bash
# Dans le dossier parent de votre choix (PAS dans aom_ground_transport/)
flutter create --org com.aom --project-name aom_ground_transport aom_ground_transport_fresh

# Copier ensuite les fichiers de ce dépôt par-dessus :
# lib/, test/, assets/, pubspec.yaml, .github/, android/app/build.gradle
# android/app/src/main/AndroidManifest.xml
```

### Étape 2 — Installer les dépendances

```bash
cd aom_ground_transport
flutter pub get
```

### Étape 3 — Générer le code Drift (OBLIGATOIRE)

```bash
dart run build_runner build --delete-conflicting-outputs
```

Cette commande génère les fichiers `*.g.dart` pour Drift et Riverpod.

### Étape 4 — Lancer en mode debug

```bash
flutter run
```

### Étape 5 — Lancer les tests

```bash
flutter test
```

### Étape 6 — Générer l'APK release

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

APK disponible dans :
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Alternative — Ouvrir directement ce dossier

Si Flutter est installé et configuré, ouvrez ce dossier dans Android Studio ou VS Code.
Android Studio génère automatiquement les fichiers Gradle manquants au premier build.

**Important :** Exécuter `flutter create . --org com.aom` dans ce dossier
pour compléter le scaffold manquant avant de builder.

---

## Checklist finale APK installable

```
[ ] flutter doctor → aucune erreur critique
[ ] flutter pub get → OK
[ ] dart run build_runner build → fichiers .g.dart générés
[ ] flutter test → tous les tests verts
[ ] flutter build apk --release → succès
[ ] app-release.apk présent dans build/app/outputs/flutter-apk/
[ ] APK transféré sur Android (USB, email, cloud)
[ ] Paramètre "sources inconnues" activé sur le téléphone
[ ] App installée → écran init → Dashboard
[ ] Mission démo AOM-2024-001 visible
[ ] Bouton WhatsApp → ouvre WhatsApp avec message prérempli
[ ] Google Maps → ouvre itinéraire Casablanca → GMMB
```
