chown -R ${username}:users ${uhome}/.ssh
chmod 700 ${uhome}/.ssh           # Folder
chmod 600 ${uhome}/.ssh/id_*      # All keys
chmod 644 ${uhome}/.ssh/id_*.pub  # Pub keys
