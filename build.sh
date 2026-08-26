#!/bin/bash

# Télécharger le SDK Flutter stable
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Ajouter Flutter au PATH temporaire
export PATH="$PATH:`pwd`/flutter/bin"

# Activer le support Web et récupérer les dépendances
flutter config --enable-web
flutter pub get

# Compiler pour le web
flutter build web --release