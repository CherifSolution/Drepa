#!/bin/bash

# Télécharger le SDK Flutter stable
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Ajouter Flutter au PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Activer le Web et installer les dépendances
flutter config --enable-web
flutter pub get

# Compiler pour le Web sans l'option obsolète
flutter build web --release