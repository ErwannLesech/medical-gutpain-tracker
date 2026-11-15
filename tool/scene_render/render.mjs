// Rendu des scènes puzzle à partir des kits 3D Kenney (CC0).
//
//   node render.mjs sheet <dossier GLB du kit> [sortie.png]
//       Planche-contact de tous les modèles d'un kit (pour composer une scène).
//
//   node render.mjs scene <scenes/forest.json>
//       Calcule les images d'une scène dans assets/scenes/<id>/ :
//       reference.webp (scène finie), terrain.webp, un sprite par emplacement,
//       une icône par modèle, et scene.json lu par l'application.
//
// Nécessite Chrome ou Edge installé (piloté via puppeteer-core).

import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import puppeteer from 'puppeteer-core';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '..', '..');

const BROWSERS = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  '/usr/bin/google-chrome',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
];

const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.glb': 'model/gltf-binary', '.png': 'image/png', '.json': 'application/json' };

function serve() {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const file = path.join(root, decodeURIComponent(new URL(req.url, 'http://x').pathname));
      if (!file.startsWith(root) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) {
        res.writeHead(404); res.end(); return;
      }
      res.writeHead(200, { 'Content-Type': MIME[path.extname(file)] ?? 'application/octet-stream' });
      fs.createReadStream(file).pipe(res);
    });
    server.listen(0, '127.0.0.1', () => resolve(server));
  });
}

async function withPage(fn) {
  const server = await serve();
  const executablePath = BROWSERS.find((p) => fs.existsSync(p));
  if (!executablePath) throw new Error('Chrome ou Edge introuvable');
  const browser = await puppeteer.launch({
    executablePath,
    headless: true,
    args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist'],
  });
  try {
    const page = await browser.newPage();
    page.on('console', (m) => { if (m.type() === 'error') console.error('[page]', m.text()); });
    page.on('pageerror', (e) => console.error('[page]', e.message));
    const port = server.address().port;
    await page.goto(`http://127.0.0.1:${port}/tool/scene_render/page.html`);
    await page.waitForFunction('window.ready === true', { timeout: 30000 });
    return await fn(page);
  } finally {
    await browser.close();
    server.close();
  }
}

const toUrl = (p) => '/' + path.relative(root, path.resolve(root, p)).split(path.sep).join('/');
const writeData = (file, dataUrl) => {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, Buffer.from(dataUrl.split(',')[1], 'base64'));
};

async function sheet(kitDir, out) {
  const names = fs.readdirSync(path.resolve(root, kitDir)).filter((f) => f.endsWith('.glb')).map((f) => f.slice(0, -4)).sort();
  const res = await withPage((page) => page.evaluate((u, n) => window.contactSheet(u, n), toUrl(kitDir), names));
  out ??= path.join(here, 'out', path.basename(path.resolve(root, kitDir, '..', '..')) + '.png');
  writeData(out, res.png);
  console.log(`Planche : ${out}`);
  for (const [k, v] of Object.entries(res.info)) console.log(`${k.padEnd(24)} size ${v.size.join(' x ')}  min ${v.min.join(',')}`);
}

/** Ordre d'affichage : sol plat d'abord, puis du fond vers l'avant, supports avant ce qu'ils portent. */
function drawOrder(pieces, slots) {
  const byId = new Map(slots.map((s) => [s.id, s]));
  const pieceById = new Map(pieces.map((p) => [p.id, p]));
  const key = (s) => {
    const p = pieceById.get(s.id);
    const flat = s.top - p.pos[1] < 0.12 ? 0 : 1;
    return [p.layer ?? flat, s.depth];
  };
  const sorted = [...slots].sort((a, b) => {
    const ka = key(a), kb = key(b);
    return ka[0] - kb[0] || ka[1] - kb[1];
  });
  // Une pièce posée sur une autre passe toujours après son support
  for (let changed = true, guard = 0; changed && guard < 200; guard++) {
    changed = false;
    for (let i = 0; i < sorted.length; i++) {
      const p = pieceById.get(sorted[i].id);
      for (const dep of [].concat(p.on ?? [], p.after ?? [])) {
        const j = sorted.findIndex((s) => s.id === dep);
        if (j > i) { const [moved] = sorted.splice(j, 1); sorted.splice(i, 0, moved); changed = true; }
      }
    }
  }
  return sorted.map((s) => byId.get(s.id));
}

async function scene(defFile) {
  const def = JSON.parse(fs.readFileSync(path.resolve(here, defFile), 'utf8'));
  if (def.ppu !== SCENE_PPU) throw new Error(`ppu doit valoir ${SCENE_PPU} (échelle commune avec les animaux)`);
  const outDir = path.join(root, 'assets', 'scenes', def.id);
  fs.rmSync(outDir, { recursive: true, force: true });
  fs.mkdirSync(outDir, { recursive: true });

  const pageDef = { ...def, kitUrl: toUrl(def.kit) };
  const { res, check, ordered } = await withPage(async (page) => {
    const res = await page.evaluate((d) => window.renderScene(d), pageDef);
    const ordered = drawOrder(def.pieces, res.slots);
    const check = await page.evaluate(
      (w, h, t, s, r) => window.compositeCheck(w, h, t, s, r),
      res.width, res.height, res.terrain ?? null, ordered, res.reference,
    );
    return { res, check, ordered };
  });

  writeData(path.join(outDir, 'reference.webp'), res.reference.data);
  if (res.terrain) writeData(path.join(outDir, 'terrain.webp'), res.terrain.data);
  for (const s of ordered) writeData(path.join(outDir, 'slots', `${s.id}.webp`), s.data);
  for (const [model, data] of Object.entries(res.icons)) writeData(path.join(outDir, 'icons', `${model}.webp`), data);
  writeData(path.join(here, 'out', `${def.id}-composite.png`), check.png);

  const pieceById = new Map(def.pieces.map((p) => [p.id, p]));
  const out = {
    id: def.id,
    name: def.name,
    emoji: def.emoji,
    width: res.width,
    height: res.height,
    background: def.background,
    reference: { x: res.reference.x, y: res.reference.y, w: res.reference.w, h: res.reference.h },
    terrain: res.terrain ? { x: res.terrain.x, y: res.terrain.y, w: res.terrain.w, h: res.terrain.h } : null,
    petSpot: res.petSpot ?? null,
    pets: def.pets ?? [],
    models: def.models,
    starter: def.starter ?? [],
    slots: ordered.map((s) => {
      const p = pieceById.get(s.id);
      return {
        id: s.id,
        model: p.model,
        x: s.x, y: s.y, w: s.w, h: s.h,
        ax: s.ax, ay: s.ay,
        requires: [].concat(p.on ?? []),
      };
    }),
  };
  fs.writeFileSync(path.join(outDir, 'scene.json'), JSON.stringify(out, null, 1));
  const missing = def.pieces.filter((p) => !def.models[p.model]).map((p) => p.model);
  if (missing.length) console.warn('Modèles sans nom/prix :', [...new Set(missing)].join(', '));
  console.log(`${def.id} : ${res.width}x${res.height}px, ${ordered.length} emplacements, ${Object.keys(res.icons).length} modèles`);
  console.log(`Écart composition 2D / 3D : ${(check.ratio * 100).toFixed(2)} % des pixels`);
}

// Noms français des Cube Pets ; le tigre est l'animal préféré : récompense spéciale.
const PET_NAMES = {
  'animal-tiger': 'Tigre', 'animal-cat': 'Chat', 'animal-dog': 'Chien', 'animal-bunny': 'Lapin',
  'animal-fox': 'Renard', 'animal-panda': 'Panda', 'animal-koala': 'Koala', 'animal-lion': 'Lion',
  'animal-penguin': 'Pingouin', 'animal-polar': 'Ours polaire', 'animal-monkey': 'Singe',
  'animal-elephant': 'Éléphant', 'animal-giraffe': 'Girafe', 'animal-deer': 'Cerf',
  'animal-beaver': 'Castor', 'animal-pig': 'Cochon', 'animal-hog': 'Sanglier', 'animal-cow': 'Vache',
  'animal-chick': 'Poussin', 'animal-parrot': 'Perroquet', 'animal-bee': 'Abeille',
  'animal-caterpillar': 'Chenille', 'animal-crab': 'Crabe', 'animal-fish': 'Poisson',
};
const SCENE_PPU = 150; // doit être identique dans toutes les scènes

async function pets() {
  const kit = 'assets/kenney_cube-pets_1.0/Models/GLB format';
  const names = Object.keys(PET_NAMES);
  const res = await withPage((page) => page.evaluate((u, n, p) => window.renderPets(u, n, p, 0.55), toUrl(kit), names, SCENE_PPU));
  const outDir = path.join(root, 'assets', 'scenes', 'pets');
  fs.rmSync(outDir, { recursive: true, force: true });
  const meta = { ppu: SCENE_PPU, pets: [] };
  for (const name of names) {
    const r = res[name];
    const id = name.replace('animal-', '');
    writeData(path.join(outDir, `${id}.webp`), r.data);
    writeData(path.join(outDir, 'icons', `${id}.webp`), r.icon);
    meta.pets.push({ id, name: PET_NAMES[name], w: r.w, h: r.h, ax: r.ax, ay: r.ay });
  }
  fs.writeFileSync(path.join(outDir, 'pets.json'), JSON.stringify(meta, null, 1));
  console.log(`${names.length} animaux rendus dans ${outDir}`);
}

const [cmd, ...args] = process.argv.slice(2);
if (cmd === 'sheet') await sheet(args[0], args[1]);
else if (cmd === 'scene') await scene(args[0]);
else if (cmd === 'pets') await pets();
else console.log('Usage : node render.mjs sheet <kit GLB dir> | scene <scene.json> | pets');
