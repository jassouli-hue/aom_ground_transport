# ============================================================
# build_apk.ps1 — AOM Ground Transport Mobile
# Lance flutter create (scaffold), build_runner, puis APK
# ============================================================

param(
    [string]$FlutterPath = "$env:USERPROFILE\flutter\bin\flutter.bat"
)

$ErrorActionPreference = "Stop"
$ProjectDir = $PSScriptRoot

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  AOM Ground Transport — Build APK Release" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Vérifier Flutter
if (-not (Test-Path $FlutterPath)) {
    Write-Host "Flutter introuvable a : $FlutterPath" -ForegroundColor Red
    exit 1
}
Write-Host "[1/7] Flutter trouve : $FlutterPath" -ForegroundColor Green
& $FlutterPath --version

# 2. Se placer dans le projet
Set-Location $ProjectDir
Write-Host ""
Write-Host "[2/7] Dossier projet : $ProjectDir" -ForegroundColor Green

# 3. flutter create . pour completer le scaffold Android (ne touche pas nos fichiers)
Write-Host ""
Write-Host "[3/7] Completion du scaffold Flutter..." -ForegroundColor Yellow
& $FlutterPath create . --org com.aom --project-name aom_ground_transport --platforms android 2>&1 | Where-Object { $_ -match "create|Wrote|error" }

# 4. flutter pub get
Write-Host ""
Write-Host "[4/7] Installation des dependances..." -ForegroundColor Yellow
& $FlutterPath pub get

# 5. build_runner (genere .g.dart Drift)
Write-Host ""
Write-Host "[5/7] Generation code Drift (build_runner)..." -ForegroundColor Yellow
$dart = Join-Path (Split-Path $FlutterPath) "dart.bat"
& $dart run build_runner build --delete-conflicting-outputs

# 6. flutter test
Write-Host ""
Write-Host "[6/7] Tests unitaires..." -ForegroundColor Yellow
& $FlutterPath test --reporter compact 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests échoués. Le build APK continue quand même..." -ForegroundColor Yellow
}

# 7. Build APK release
Write-Host ""
Write-Host "[7/7] Build APK release..." -ForegroundColor Yellow
& $FlutterPath build apk --release

$apkPath = Join-Path $ProjectDir "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    $size = [math]::Round((Get-Item $apkPath).Length / 1MB, 1)
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  APK GENERE AVEC SUCCES !" -ForegroundColor Green
    Write-Host "  Taille : ${size} MB" -ForegroundColor Green
    Write-Host "  Chemin : $apkPath" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green

    # Copier aussi a la racine pour acces facile
    $dest = Join-Path $ProjectDir "AOM-GroundTransport-release.apk"
    Copy-Item $apkPath $dest -Force
    Write-Host "  Copie  : $dest" -ForegroundColor Green
    Write-Host ""
    Write-Host "Installation sur Android :" -ForegroundColor Cyan
    Write-Host "  adb install `"$dest`"" -ForegroundColor White
} else {
    Write-Host "Echec : APK non trouve." -ForegroundColor Red
    exit 1
}
