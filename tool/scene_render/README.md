# Rendu des scènes puzzle

Ce dossier transforme les kits 3D Kenney (CC0) de `assets/kenney_*` en images 2D pour l'app. L'app n'embarque que ces images, environ 700 Ko pour la forêt et les animaux.

```bash
cd tool/scene_render
npm install                      # une seule fois (three.js + puppeteer-core)
node render.mjs sheet "assets/kenney_holiday-kit/Models/GLB format"   # planche des modèles -> out/
node render.mjs scene scenes/forest.json                              # -> assets/scenes/forest/
node render.mjs pets                                                  # -> assets/scenes/pets/
```

Le script a besoin de Chrome ou d'Edge installé.

## Ajouter une scène

1. Lancez `sheet` sur le kit pour voir les modèles et leurs dimensions.
2. Créez `scenes/<id>.json` sur le modèle de `forest.json`. Le fichier contient :
   - `pieces` : une entrée par pièce, avec position `[x, y, z]` et rotation en degrés. `on` indique le support (la pièce ne devient disponible qu'une fois le support posé). `after` force l'ordre d'affichage.
   - `models` : le nom français et le prix en Catcoins de chaque modèle.
   - `starter` : les pièces offertes au départ.
   - `pets` : les animaux proposés à la fin.
   - `petSpot` : l'emplacement de l'animal.
   - `ppu` : doit rester à 150, l'échelle commune avec les animaux.
   - `scale` (facultatif) : réduit les kits modélisés en grand. Le kit pirate utilise 0,35 ; chaque pièce peut aussi avoir son propre `scale`.
   - `terrain.island` (facultatif) : un plateau de sable posé sur le terrain, dont le dessus devient la mer. Les pièces posées sur l'île ont alors `y` = `island.top`.
3. Lancez `scene`. Vérifiez `out/<id>-composite.png` (la scène recomposée en 2D) par rapport à `assets/scenes/<id>/reference.webp` (la vraie 3D). Un écart de moins de 6 % est normal (ombres).
4. Ajoutez l'id à `sceneOrder` dans `lib/core/services/scene_service.dart`, et ses 3 dossiers d'images dans `pubspec.yaml`.

Repères de coordonnées : la caméra regarde depuis +x/+z. Vers la droite de l'écran = +x −z. Vers le fond = −x −z.
