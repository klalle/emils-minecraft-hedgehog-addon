import { world } from "@minecraft/server";
import { ActionFormData } from "@minecraft/server-ui";

export const GUIDE_BOOK = "starter:guide_book";

// One entry per thing. The spawn egg and the book itself are intentionally not listed.
const PAGES = [
  {
    title: "Hedgehog",
    body:
      "§lWhat it is§r\nA small neutral forest animal.\n\n" +
      "§lWhere to find it§r\nSpawns on grass in forest and taiga biomes, alone or in pairs.\n\n" +
      "§lWhat it does§r\nIt wanders peacefully, but fights back if you hit it (2 damage). " +
      "It only has 4 health (2 hearts). Spike traps do not hurt hedgehogs.\n\n" +
      "§lDrops§r\n1-3 Hedgehog Spines (more with Looting).\n\n" +
      "§lSummon§r\n/summon starter:hedgehog",
  },
  {
    title: "Hedgehog Spine",
    body:
      "§lHow to get it§r\nDropped by Hedgehogs.\n\n" +
      "§lWhat it does§r\nThe base ingredient for almost everything in this addon: " +
      "Hedgehog Balls, the Thorn Shield, Spike Traps and this Handbook. " +
      "It also repairs a Thorn Shield (60 durability each).",
  },
  {
    title: "Hedgehog Ball",
    body:
      "§lHow to craft§r\nPlace 4 Hedgehog Spines in a 2x2 square in the crafting grid. Makes 2 balls.\n\n" +
      "§lWhat it does§r\nAmmo for the Slingshot. A flying ball deals 4 damage (2 hearts) and knockback.",
  },
  {
    title: "Slingshot",
    body:
      "§lHow to craft§r\nTop row: Stick, String, Stick. Middle and bottom rows: one Stick in the center.\n\n" +
      "§lWhat it does§r\nRight-click to shoot a Hedgehog Ball from your inventory. " +
      "Short cooldown (0.6 s), 250 durability, one ball per shot. " +
      "In Creative mode it never runs out of ammo or durability.",
  },
  {
    title: "Thorn Shield",
    body:
      "§lHow to craft§r\nTop row: Spine, Planks, Spine. Middle row: Planks, Iron Ingot, Planks. " +
      "Bottom row: Planks in the center.\n\n" +
      "§lWhat it does§r\nHold it in your off hand. Anything that hits you in melee takes 3 damage. " +
      "Sneak while hit and it takes 6 damage, and you get 40% of the damage you took back as health. " +
      "400 durability, one point lost per hit. Repair with Hedgehog Spines.",
  },
  {
    title: "Spike Trap",
    body:
      "§lHow to craft§r\nPut a Pointed Dripstone in the center and surround it with 8 Hedgehog Spines.\n\n" +
      "§lWhat it does§r\nA thin steel plate with 5 spikes. Every half second it deals 3 damage " +
      "(1.5 hearts) to any living thing standing on it, except Hedgehogs.",
  },
  {
    title: "Poison Spike Trap",
    body:
      "§lHow to craft§r\nPut a Spike Trap in the center and surround it with 8 Spider Eyes.\n\n" +
      "§lWhat it does§r\nLooks like a Spike Trap with green poison on top. Deals the same 3 damage " +
      "and also poisons whatever stands on it for 8 seconds.",
  },
  {
    title: "Camouflaged Spike Trap",
    body:
      "§lHow to craft§r\nPut a Spike Trap in the center and surround it with 8 Oak Leaves.\n\n" +
      "§lWhat it does§r\nAn invisible Spike Trap. It deals 3 damage to anything standing on it. " +
      "Remember where you placed it. You can still break it by targeting the spot.",
  },
  {
    title: "Ruby Block",
    body:
      "§lHow to get it§r\nNo crafting recipe. Find it in the Creative inventory (Construction) or use " +
      "/give @s starter:ruby_block.\n\n" +
      "§lWhat it does§r\nA decorative block that glows a little (light level 6).",
  },
];

function showMenu(player) {
  const form = new ActionFormData().title("Hedgehog Handbook").body("Choose a page.");
  for (const page of PAGES) form.button(page.title);
  form.show(player).then((res) => {
    if (res.canceled) return;
    showPage(player, res.selection);
  });
}

function showPage(player, index) {
  const page = PAGES[index];
  new ActionFormData()
    .title(page.title)
    .body(page.body)
    .button("Back")
    .show(player)
    .then((res) => {
      if (!res.canceled) showMenu(player);
    });
}

world.afterEvents.itemUse.subscribe((ev) => {
  if (ev.itemStack?.typeId === GUIDE_BOOK) showMenu(ev.source);
});
