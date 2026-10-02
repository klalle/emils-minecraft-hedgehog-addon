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

| Sak | ID | Hur du får den |
|---|---|---|
| Rubinblock | `starter:ruby_block` | `/give @s starter:ruby_block` |
| Igelkott (neutralt djur, slår tillbaka) | `starter:hedgehog` | `/summon starter:hedgehog` eller spawn egg i kreativmenyn |
| Igelkottstagg (droppas av igelkott) | `starter:hedgehog_spine` | `/give @s starter:hedgehog_spine` |
| Taggsköld | `starter:thorn_shield` | craft: tagg/planks/järn, eller `/give` |

Taggskölden ska hållas i vänsterhanden. Den skadar den som slår dig (3 hjärtan-halvor, 6 om du sneakar och då får du även tillbaka lite liv). Logiken finns i `addons/starter/BP/scripts/main.js`.

## Lokal testserver

```powershell
.\tools\server.ps1 setup    # en gång
.\tools\server.ps1 deploy   # efter varje ändring
.\tools\server.ps1 start    # starta (anslut på 127.0.0.1:19132)
```
