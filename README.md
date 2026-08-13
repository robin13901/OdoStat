# OdoStat

Tankvorgänge, Ladevorgänge und Kilometerstände für mehrere Fahrzeuge — mit
Analyse-Dashboard. Nachfolger der Android-App CarGo, im Liquid-Glass-Look
(Dark-Mode, Orange-Akzent) mit Verbrenner- **und** Elektro-Unterstützung.

## Features

- **Fahrzeuge** verwalten (Verbrenner/Elektro, Erwerbsdatum, Start-km, Archiv).
- **Einträge**: Tank-/Ladevorgänge (Liter bzw. kWh, Kraftstoffart, Live-Preis)
  und Kilometerstände — pro Fahrzeug, mit antriebs-adaptivem Formular.
- **Analyse-Dashboard**: Kennzahlen je Jahr (Strecke, Ø Verbrauch, Kosten,
  Ø Preis) und monatliche Linien-Charts (Strecke / Verbrauch / Kosten /
  Kosten pro 100 km).
- **Vergleich**: zwei (Fahrzeug, Jahr)-Reihen überlagern, z. B. Opel 2026 vs.
  E-Auto 2027 — auf Monat 1–12 normalisiert.
- **Datensicherung**: gesamte Datenbank exportieren (teilen) und wieder
  importieren (Einstellungen → Datensicherung).

## Stack

Flutter · Drift (SQLite) · Riverpod · go_router · liquid_glass_renderer ·
fl_chart · intl. Daten werden als `int yyyyMMdd` gespeichert.

## Entwicklung

```
flutter pub get
dart run build_runner build      # Drift-Code generieren
dart analyze                     # Schnell-Check
flutter test                     # Tests
flutter run                      # App starten
```

Läuft ein Migrationstest gegen echte Daten:
`flutter test --dart-define=MIGRATED_DB=<pfad-zur.db>`.

## CarGo-Daten übernehmen

Einmalige Migration der Bestandsdaten aus CarGo — siehe
[`tool/README.md`](tool/README.md).
