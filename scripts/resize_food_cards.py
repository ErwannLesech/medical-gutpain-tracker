#!/usr/bin/env python3
"""
Script pour redimensionner les images de plats en 256x256 et les convertir en WebP.
Utilisation: python3 resize_food_cards.py
Prerequis: pip install Pillow
"""

import os
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow n'est pas installe. Installation en cours...")
    os.system("pip install Pillow")
    from PIL import Image

# Configuration
INPUT_DIR = Path(__file__).parent.parent / "assets" / "food"
OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "food_cards_optimized"
TARGET_SIZE = (256, 256)
QUALITY = 85  # Qualite WebP (0-100)


def resize_and_convert():
    """Redimensionne et convertit toutes les images de plats."""
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    jpg_files = sorted(INPUT_DIR.glob("*.jpg"), key=lambda x: int(x.stem))

    print(f"Trouve {len(jpg_files)} images a traiter")
    print(f"Dossier source: {INPUT_DIR}")
    print(f"Dossier destination: {OUTPUT_DIR}")
    print(f"Taille cible: {TARGET_SIZE[0]}x{TARGET_SIZE[1]}")
    print("-" * 50)

    processed = 0
    errors = 0

    for jpg_file in jpg_files:
        try:
            with Image.open(jpg_file) as img:
                if img.mode in ("RGBA", "P"):
                    img = img.convert("RGB")

                img_resized = img.resize(TARGET_SIZE, Image.Resampling.LANCZOS)

                output_path = OUTPUT_DIR / f"{jpg_file.stem}.webp"
                img_resized.save(output_path, "WEBP", quality=QUALITY, method=6)

                original_size = jpg_file.stat().st_size / 1024
                new_size = output_path.stat().st_size / 1024
                reduction = ((original_size - new_size) / original_size) * 100

                print(
                    f"✓ {jpg_file.name} -> {output_path.name} "
                    f"({original_size:.1f}KB -> {new_size:.1f}KB, -{reduction:.1f}%)"
                )
                processed += 1

        except Exception as exc:
            print(f"✗ Erreur pour {jpg_file.name}: {exc}")
            errors += 1

    print("-" * 50)
    print(f"Termine! {processed} images traitees, {errors} erreurs")

    total_original = sum(f.stat().st_size for f in INPUT_DIR.glob("*.jpg")) / 1024 / 1024
    total_new = sum(f.stat().st_size for f in OUTPUT_DIR.glob("*.webp")) / 1024 / 1024

    print(f"Taille totale: {total_original:.2f}MB -> {total_new:.2f}MB")
    print(f"Reduction totale: {((total_original - total_new) / total_original) * 100:.1f}%")


def generate_food_card_data():
    """Genere un fichier Dart avec les donnees des cartes de plats."""
    webp_files = sorted(OUTPUT_DIR.glob("*.webp"), key=lambda x: int(x.stem))

    dart_content = """// GENERATED FILE - DO NOT EDIT
// Genere par scripts/resize_food_cards.py

/// Liste des plats disponibles dans le systeme de recompenses
class FoodCardData {
  final String id;
  final String assetPath;
  final String name;
  final bool isPrestige;

  const FoodCardData({
    required this.id,
    required this.assetPath,
    required this.name,
    this.isPrestige = false,
  });
}

/// Tous les plats disponibles (50 plats)
const List<FoodCardData> allFoodCards = [
"""

    for webp_file in webp_files:
        card_id = webp_file.stem
        is_prestige = "true" if card_id == "50" else "false"
        name = f"Plat {card_id}"
        dart_content += (
            "  FoodCardData(\n"
            f"    id: '{card_id}',\n"
            f"    assetPath: 'assets/food_cards_optimized/{card_id}.webp',\n"
            f"    name: '{name}',\n"
            f"    isPrestige: {is_prestige},\n"
            "  ),\n"
        )

    dart_content += "];\n\n/// Nombre total de plats\nconst int totalFoodCardsCount = 50;\n"

    dart_path = Path(__file__).parent.parent / "lib" / "core" / "data" / "food_card_data.dart"
    dart_path.parent.mkdir(parents=True, exist_ok=True)

    with open(dart_path, "w", encoding="utf-8") as file_handle:
        file_handle.write(dart_content)

    print(f"\nFichier Dart genere: {dart_path}")


if __name__ == "__main__":
    print("=== Redimensionnement des images de plats ===\n")
    resize_and_convert()
    print("\n=== Generation du fichier Dart ===")
    generate_food_card_data()
    print("\n✓ Tout est pret!")
