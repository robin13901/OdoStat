# CarGo → OdoStat: Einmal-Migration

CarGo (die native Android-Vorgänger-App) hat keine Export-Funktion. Die Daten
liegen nur in der SQLite-Datenbank der App auf dem Handy. Diese einmalige
Migration überführt sie in eine OdoStat-Datenbank, die du in OdoStat
importieren kannst.

## 1. CarGo-Datenbank vom Handy holen

Die DB heißt `Database` und liegt im privaten App-Verzeichnis
(`/data/data/com.example.cargo/databases/Database`). Wege, um heranzukommen:

- **ADB (Gerät mit Debugging / Emulator):**
  ```
  adb exec-out run-as com.example.cargo cat databases/Database > CarGo-db-export.db
  ```
- **Android-Backup / Root-Dateimanager:** Datei aus dem App-Datenordner
  kopieren.

Lege die Datei z. B. als `CarGo-db-export.db` ab.

> Diese Datei enthält deine echten Daten — sie ist per `.gitignore` vom Repo
> ausgeschlossen. Nicht committen.

## 2. Migration ausführen

Aus dem Projektstamm:

```
dart run tool/migrate_cargo.dart CarGo-db-export.db odostat-import.db
```

Das Skript:
- liest die CarGo-Tabellen `Vehicles`, `Refuels`, `Mileages`
  (Trips/Locations werden verworfen),
- legt eine OdoStat-Datenbank (`odostat-import.db`) mit dem aktuellen Schema an,
- übernimmt Fahrzeuge als **Verbrenner** (`combustion`) — die einzige Antriebs-
  art, die CarGo kennt; in der App später ggf. auf Elektro umstellen,
- mappt `E5`/`E10`/`Diesel` → `e5`/`e10`/`diesel`,
- rundet Kosten und Mengen auf 2 Nachkommastellen (CarGo speicherte `float`,
  daher Rundungsrauschen wie `39.3499984741211`),
- gibt am Ende die Zeilenzahlen aus (zum Abgleich mit CarGo).

## 3. In OdoStat importieren

Übertrage `odostat-import.db` auf das Handy und in OdoStat:

**Einstellungen → Datensicherung → Importieren** → Datei wählen → bestätigen.

Die App validiert die Datei (Integrität, Pflicht-Tabellen) und ersetzt den
aktuellen Datenbestand.

## Verifikation

Die Zeilenzahlen der Skript-Ausgabe müssen zu CarGo passen. Nach dem Import
sollte im Dashboard die vollständige Historie (z. B. Opel Astra) sichtbar sein.
