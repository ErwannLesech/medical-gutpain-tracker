# Idée : mode « décor libre » des scènes

> Statut : **idée, pas implémentée.** À reprendre quand on voudra faire évoluer les scènes.

## Contexte

Les scènes (forêt, village de Noël, île au trésor...) sont des puzzles :
chaque pièce du tiroir se glisse sur son emplacement imposé, et la scène est
terminée quand tous les emplacements sont remplis, puis qu'on a choisi un
animal.

Pour que ça reste un vrai puzzle, le modèle à reconstruire est **flouté** et
on peut dévoiler une zone du quadrillage (4 × 2 = 8 zones) pour
`CoinRewards.sceneReveal` Catcoins (4). Une fois la scène terminée, le modèle
s'affiche en clair. Voir `lib/features/scenes/scene_widgets.dart`
(`SceneReferenceDialog`) et `SceneReveal` dans
`lib/core/services/scene_puzzle.dart`.

## L'idée

Quand une scène est **terminée**, débloquer un second mode : le **décor libre**.

- On peut **déplacer** les objets déjà posés et les replacer où on veut.
- La scène reste « terminée » : le mode libre ne remet rien en jeu (pas de
  perte de progression, pas de Catcoins en jeu).
- Phase 1 = le puzzle (emplacements imposés), phase 2 = la liberté créative.

Pourquoi pas du placement libre dès le début : sans repère à suivre, il n'y a
plus de défi, juste de la décoration. Le puzzle d'abord, la liberté en
récompense.

## Contraintes techniques à garder en tête

Les sprites sont **pré-rendus par emplacement**, pas par modèle
(`assets/scenes/<scène>/slots/<slot>.webp`, rendus par `tool/scene_render`),
avec leur échelle, leur orientation et leur éclairage propres. Les icônes par
modèle (`icons/`) ne servent qu'à l'inventaire. Déplacer un objet ailleurs
pose donc plusieurs questions :

1. **Sprite à réutiliser** : le plus simple est de déplacer le sprite tel
   quel (même rendu, juste une nouvelle position). L'éclairage et l'ombre
   restent ceux de l'emplacement d'origine, ce qui est acceptable si le
   déplacement est limité.
2. **Tri en profondeur** : l'ordre d'affichage actuel est celui de
   `def.slots` (du fond vers l'avant). En mode libre il faut trier par
   position verticale de l'ancre (`anchor.dy`) pour que ce qui est devant
   passe devant.
3. **Zone autorisée** : limiter les positions au terrain (`def.terrain`) pour
   ne pas poser un objet dans le ciel.
4. **Dépendances** : les objets qui reposent sur un autre (`requires`, ex. le
   toit sur le plancher) doivent bouger ensemble, ou être verrouillés.
5. **Persistance** : stocker une position par pièce (`ScenePiece` a déjà un
   `slotId` ; il faudrait des coordonnées libres, ex. `freeX` / `freeY`,
   nullables, et donc une migration Isar qui ajoute des champs : sans danger
   pour les données existantes).
6. **Réinitialiser** : un bouton pour tout remettre à la place d'origine.

## Variantes possibles

- **Déplacement seulement** (recommandé pour commencer) : on bouge les objets
  posés, on ne peut ni en ajouter ni en retirer.
- **Rotation / échelle** : demanderait de re-rendre les sprites sous plusieurs
  angles, donc un travail dans `tool/scene_render`.
- **Placement 100 % libre avec sprites génériques par modèle** : le plus
  flexible, mais le rendu perd la cohérence d'éclairage de la scène. À
  éviter, sauf si on refait le pipeline de rendu.
- **Dupliquer des objets** (plusieurs arbres) : à voir seulement si le besoin
  se fait sentir, ça change la notion de « scène complète ».

## Pistes d'interface

- Un bouton « ✏️ Décorer » dans la barre de la scène terminée.
- Appui long sur un objet pour le saisir, glisser, relâcher ; une grille
  d'aimantation légère évite les superpositions bancales.
- Un repère visuel de la zone autorisée pendant le déplacement.

## À décider le moment venu

- Les animaux (Cube Pets) sont-ils déplaçables aussi ?
- Garde-t-on la position d'origine pour pouvoir « remettre comme au début » ?
- Fait-on partager la scène décorée (capture d'écran) ?
