# Minecraft Bedrock-addons

Egna addons till Minecraft Bedrock: block, djur, skÃ¶ldar m.m. Varje addon ligger i `addons/<namn>/` med tvÃ¥ delar:

- `BP/` â€“ behavior pack (vad saker *gÃ¶r*: block, djur, items, script)
- `RP/` â€“ resource pack (hur saker *ser ut*: texturer, modeller, namn)

## Snabbstart (Windows)

```powershell
.\tools\build.ps1 starter      # skapar dist\starter.mcaddon
.\tools\dev-link.ps1 starter   # kopierar till Minecraft fÃ¶r test
```

1. KÃ¶r `dev-link.ps1`, starta Minecraft, skapa en ny vÃ¤rld (Creative, Cheats pÃ¥).
2. Under *Behavior Packs* och *Resource Packs* aktivera "Starter BP" och "Starter RP".
3. I vÃ¤rlden: `/give @s starter:ruby_block`.

Fel i packen syns i Minecraft: InstÃ¤llningar > Skapare > *Aktivera innehÃ¥llslogg (GUI)*.

## Dela

- Kompisar: skicka `dist\starter.mcaddon` â€“ dubbelklick importerar den i Minecraft.
- Servern: se `docker/` (kommer).

## FÃ¶r nybÃ¶rjare

Rubinblockets egenskaper stÃ¥r i `addons/starter/BP/blocks/ruby_block.json`. Prova att Ã¤ndra
`light_emission` (0â€“15) eller `seconds_to_destroy`, kÃ¶r `dev-link.ps1` igen och starta om vÃ¤rlden.
Texturen `addons/starter/RP/textures/blocks/ruby_block.png` kan ritas om i valfritt pixelprogram.
Namn pÃ¥ svenska/engelska stÃ¥r i `RP/texts/*.lang`.

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
