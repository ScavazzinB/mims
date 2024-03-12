#!/bin/bash

SERVICE_NAME="open-browser"
TIMER_INTERVAL="5min" # Modifier selon les besoins
URL_TO_OPEN="https://www.youtube.com/watch?v=B2N4F7K2TZc" # Modifier selon les besoins

# Création du script pour ouvrir le navigateur
mkdir -p "$HOME/.local/bin"
cat << EOF > "$HOME/.local/bin/${SERVICE_NAME}.sh"
#!/bin/bash
set -x
xdg-open "${URL_TO_OPEN}"
EOF

# Rendre le script exécutable
chmod +x "$HOME/.local/bin/${SERVICE_NAME}.sh"

# Création du fichier de service systemd au niveau utilisateur
mkdir -p "$HOME/.config/systemd/user"
cat << EOF > "$HOME/.config/systemd/user/${SERVICE_NAME}.service"
[Unit]
Description=Open a web browser at regular intervals

[Service]
Type=oneshot
ExecStart=$HOME/.local/bin/${SERVICE_NAME}.sh
EOF

# Création du fichier de timer systemd au niveau utilisateur
cat << EOF > "$HOME/.config/systemd/user/${SERVICE_NAME}.timer"
[Unit]
Description=Timer to open a web browser every ${TIMER_INTERVAL}

[Timer]
OnStartupSec=5min
OnUnitActiveSec=${TIMER_INTERVAL}
Unit=${SERVICE_NAME}.service

[Install]
WantedBy=timers.target
EOF

# Recharger les fichiers de configuration systemd au niveau utilisateur
systemctl --user daemon-reload

# Activer et démarrer le timer au niveau utilisateur
systemctl --user enable ${SERVICE_NAME}.timer
systemctl --user start ${SERVICE_NAME}.timer

echo "Le timer ${SERVICE_NAME} a été configuré pour ouvrir ${URL_TO_OPEN} toutes les ${TIMER_INTERVAL} nyyaaaaa~~~."
