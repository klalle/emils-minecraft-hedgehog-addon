# Minecraft Bedrock-addons

Egna addons till Minecraft Bedrock: block, djur, sköldar m.m. Varje addon ligger i `addons/<namn>/` med två delar:

- `BP/` – behavior pack (vad saker *gör*: block, djur, items, script)
- `RP/` – resource pack (hur saker *ser ut*: texturer, modeller, namn)

## Snabbstart (Windows)

```powershell
.\tools\build.ps1 starter      # skapar dist\starter.mcaddon
.\tools\dev-link.ps1 starter   # kopierar till Minecraft för test
```

1. Kör `dev-link.ps1`, starta Minecraft, skapa en ny värld (Creative, Cheats på).
2. Under *Behavior Packs* och *Resource Packs* aktivera "Starter BP" och "Starter RP".
3. I världen: `/give @s starter:ruby_block`.

Fel i packen syns i Minecraft: Inställningar > Skapare > *Aktivera innehållslogg (GUI)*.

## Dela

- Kompisar: skicka `dist\starter.mcaddon` – dubbelklick importerar den i Minecraft.
- Servern: se `docker/` (kommer).

## För nybörjare

Rubinblockets egenskaper står i `addons/starter/BP/blocks/ruby_block.json`. Prova att ändra
`light_emission` (0–15) eller `seconds_to_destroy`, kör `dev-link.ps1` igen och starta om världen.
Texturen `addons/starter/RP/textures/blocks/ruby_block.png` kan ritas om i valfritt pixelprogram.
Namn på svenska/engelska står i `RP/texts/*.lang`.

## Innehåll i starter-addonet

Namn och handbok visas på spelarens eget språk (engelska eller svenska). Handboken (`Hedgehog Handbook` / `Igelkottens handbok`, craftas av en bok + en Hedgehog Spine) förklarar hur varje sak craftas och vad den gör. Alla texter finns i `addons/starter/RP/texts/en_US.lang` och `sv_SE.lang`; sidorna listas i `addons/starter/BP/scripts/guide.js`. Nya språk: lägg till en `<språk>.lang` och namnet i `languages.json`.

| Name | ID |
|---|---|
| Ruby Block | `starter:ruby_block` |
| Hedgehog | `starter:hedgehog` |
| Hedgehog Spine | `starter:hedgehog_spine` |
| Hedgehog Ball | `starter:hedgehog_ball` |
| Slingshot | `starter:slingshot` |
| Thorn Shield | `starter:thorn_shield` |
| Spike Trap | `starter:spike_trap` |
| Poison Spike Trap | `starter:poison_trap` |
| Camouflaged Spike Trap | `starter:camo_trap` |
| Hedgehog Handbook | `starter:guide_book` |

Logiken (sköld, slangbälla, fällor) finns i `addons/starter/BP/scripts/main.js`.

## Lokal testserver

```powershell
.\tools\server.ps1 setup    # en gång
.\tools\server.ps1 deploy   # efter varje ändring
.\tools\server.ps1 start    # starta (anslut på 127.0.0.1:19132)
```
