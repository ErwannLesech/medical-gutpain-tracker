#!/usr/bin/env python3
"""
Script pour redimensionner les images de chats en 256x256 et les convertir en WebP.
Utilisation: python3 resize_cats.py
Prérequis: pip install Pillow
"""

import os
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow n'est pas installé. Installation en cours...")
    os.system("pip install Pillow")
    from PIL import Image

# Configuration
INPUT_DIR = Path(__file__).parent.parent / "assets" / "cats"
OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "cats_optimized"
TARGET_SIZE = (256, 256)
QUALITY = 85  # Qualité WebP (0-100)

def resize_and_convert():
    """Redimensionne et convertit toutes les images de chats."""
    
    # Créer le dossier de sortie s'il n'existe pas
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    # Lister tous les fichiers JPG
    jpg_files = sorted(INPUT_DIR.glob("*.jpg"), key=lambda x: int(x.stem))
    
    print(f"Trouvé {len(jpg_files)} images à traiter")
    print(f"Dossier source: {INPUT_DIR}")
    print(f"Dossier destination: {OUTPUT_DIR}")
    print(f"Taille cible: {TARGET_SIZE[0]}x{TARGET_SIZE[1]}")
    print("-" * 50)
    
    processed = 0
    errors = 0
    
    for jpg_file in jpg_files:
        try:
            # Ouvrir l'image
            with Image.open(jpg_file) as img:
                # Convertir en RGB si nécessaire (pour les images avec transparence)
                if img.mode in ('RGBA', 'P'):
                    img = img.convert('RGB')
                
                # Redimensionner en gardant le ratio puis crop au centre
                # Comme les images sont déjà carrées, on redimensionne directement
                img_resized = img.resize(TARGET_SIZE, Image.Resampling.LANCZOS)
                
                # Sauvegarder en WebP
                output_path = OUTPUT_DIR / f"{jpg_file.stem}.webp"
                img_resized.save(output_path, "WEBP", quality=QUALITY, method=6)
                
                # Afficher les infos
                original_size = jpg_file.stat().st_size / 1024
                new_size = output_path.stat().st_size / 1024
                reduction = ((original_size - new_size) / original_size) * 100
                
                print(f"✓ {jpg_file.name} -> {output_path.name} "
                      f"({original_size:.1f}KB -> {new_size:.1f}KB, -{reduction:.1f}%)")
                processed += 1
                
        except Exception as e:
            print(f"✗ Erreur pour {jpg_file.name}: {e}")
            errors += 1
    
    print("-" * 50)
    print(f"Terminé! {processed} images traitées, {errors} erreurs")
    
    # Calculer la taille totale
    total_original = sum(f.stat().st_size for f in INPUT_DIR.glob("*.jpg")) / 1024 / 1024
    total_new = sum(f.stat().st_size for f in OUTPUT_DIR.glob("*.webp")) / 1024 / 1024
    
    print(f"Taille totale: {total_original:.2f}MB -> {total_new:.2f}MB")
    print(f"Réduction totale: {((total_original - total_new) / total_original) * 100:.1f}%")

def generate_cat_data():
    """Génère un fichier Dart avec les données des chats."""
    
    webp_files = sorted(OUTPUT_DIR.glob("*.webp"), key=lambda x: int(x.stem))
    
    dart_content = '''// GENERATED FILE - DO NOT EDIT
// Généré par scripts/resize_cats.py

/// Liste des chats disponibles dans le système de récompense
class CatData {
  final String id;
  final String assetPath;
  final String name;
  
  const CatData({
    required this.id,
    required this.assetPath,
    required this.name,
  });
}

/// Tous les chats disponibles (50 chats)
const List<CatData> allCats = [
'''
    
    cat_names = [
        "Minou", "Félix", "Caramel", "Tigrou", "Luna",
        "Noisette", "Pacha", "Moustache", "Simba", "Câlin",
        "Flocon", "Gribouille", "Minette", "Oscar", "Perle",
        "Pompon", "Réglisse", "Sushi", "Vanille", "Zorro",
        "Biscuit", "Cannelle", "Domino", "Éclipse", "Fripouille",
        "Ginger", "Haribo", "Iris", "Jazz", "Kiwi",
        "Léo", "Mochi", "Nougat", "Oreo", "Pixel",
        "Quartz", "Romeo", "Sunny", "Tiramisu", "Udon",
        "Velours", "Whisky", "Xena", "Yuki", "Zigzag",
        "Ambre", "Bulle", "Cachou", "Doudou", "Rawwwr"
    ]
    
    for i, webp_file in enumerate(webp_files):
        cat_id = webp_file.stem
        name = cat_names[i] if i < len(cat_names) else f"Chat #{cat_id}"
        dart_content += f'''  CatData(
    id: '{cat_id}',
    assetPath: 'assets/cats_optimized/{cat_id}.webp',
    name: '{name}',
  ),
'''
    
    dart_content += '''];

/// Nombre total de chats
const int totalCatsCount = 50;
'''
    
    # Sauvegarder le fichier Dart
    dart_path = Path(__file__).parent.parent / "lib" / "core" / "data" / "cat_data.dart"
    dart_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(dart_path, 'w', encoding='utf-8') as f:
        f.write(dart_content)
    
    print(f"\nFichier Dart généré: {dart_path}")

if __name__ == "__main__":
    print("=== Redimensionnement des images de chats ===\n")
    resize_and_convert()
    print("\n=== Génération du fichier Dart ===")
    generate_cat_data()
    print("\n✓ Tout est prêt!")
