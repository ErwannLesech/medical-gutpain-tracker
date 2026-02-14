#!/usr/bin/env python3
"""
Redimensionne l'icône de notification monochrome existante pour toutes les densités
"""
from PIL import Image
import os

# Chemin de base
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_ICON = os.path.join(BASE_DIR, "android", "app", "src", "main", "res", "drawable", "ic_notification.png")
ANDROID_RES = os.path.join(BASE_DIR, "android", "app", "src", "main", "res")

# Tailles pour chaque densité
SIZES = {
    "drawable-mdpi": 24,
    "drawable-hdpi": 36,
    "drawable-xhdpi": 48,
    "drawable-xxhdpi": 72,
    "drawable-xxxhdpi": 96,
}

def create_notification_icons():
    """Redimensionne l'icône de notification pour chaque densité"""
    
    # Charger l'image source
    try:
        img = Image.open(SOURCE_ICON).convert("RGBA")
        print(f"✓ Image source chargée: drawable/ic_notification.png")
        print(f"  Taille: {img.size}")
    except FileNotFoundError:
        print(f"✗ Erreur: Fichier introuvable {SOURCE_ICON}")
        return
    
    # Créer les icônes pour chaque densité
    for folder, size in SIZES.items():
        output_dir = os.path.join(ANDROID_RES, folder)
        os.makedirs(output_dir, exist_ok=True)
        
        output_path = os.path.join(output_dir, "ic_notification.png")
        
        # Redimensionner l'image
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(output_path, "PNG", optimize=True)
        
        print(f"✓ {folder}/ic_notification.png ({size}x{size})")
    
    print("\n✓ Icônes de notification créées avec succès!")

if __name__ == "__main__":
    create_notification_icons()
