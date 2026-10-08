# SEEN Datenbank

Eigene Datenbank für die SEEN-Salon-App. Damit sehen iPad und Handy dieselben Daten.

- Die Daten liegen **nur hier auf diesem Rechner** (CouchDB), nicht in einer fremden Cloud.
- Erreichbar ist die Datenbank **nur über Tailscale** (eigener Tailscale-Knoten „seen-db“ mit HTTPS-Zertifikat). Sie wird **nicht** ins Internet freigegeben und hängt nicht am Funnel von Home Assistant.
- Fotos von besonders geschützten Kundinnen werden von der App nie hierher übertragen.

## Einrichtung

1. **Konfiguration**: bei `couch_password` ein langes Passwort eintragen (mindestens 10 Zeichen), speichern, Add-on starten.
2. **Protokoll** öffnen: Dort erscheint ein Tailscale-Anmeldelink. Im Browser öffnen und mit dem eigenen Tailscale-Konto bestätigen. (Alternativ einen Auth-Key bei `tailscale_authkey` eintragen.)
3. Danach steht im Protokoll: `SEEN Datenbank erreichbar unter: https://seen-db.….ts.net`
4. In der SEEN-App am **iPad**: Mehr → Salon-Server → „iPad mit Server verbinden“ (Adresse, Benutzer `seen`, Passwort).
5. Am **Handy**: Tailscale-App installieren und anmelden, SEEN-App öffnen → „Mit Salon-Server verbinden“ → „Handy (nur online)“.

Die App-Adresse `https://endem61.github.io` ist als einzige Herkunft (CORS) erlaubt.
