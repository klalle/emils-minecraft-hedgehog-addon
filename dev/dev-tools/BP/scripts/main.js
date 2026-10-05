import { world, system } from "@minecraft/server";

// Alltid dag + klart väder. Körs vid start och återställs varje minut ifall något ändrat det.
function setDaytime() {
  const overworld = world.getDimension("overworld");
  for (const cmd of [
    "gamerule doDaylightCycle false",
    "gamerule doWeatherCycle false",
    "time set day",
    "weather clear",
  ]) {
    try {
      overworld.runCommand(cmd);
    } catch (e) {
      console.warn(`dev-tools: '${cmd}' misslyckades: ${e}`);
    }
  }
}

world.afterEvents.worldLoad.subscribe(() => {
  setDaytime();
  try {
    world.gameRules.doMobSpawning = true;
    console.warn(`dev-tools: doMobSpawning=${world.gameRules.doMobSpawning}`);
  } catch (e) {
    console.warn(`dev-tools: kunde inte läsa/sätta doMobSpawning: ${e}`);
  }
});
system.runInterval(setDaytime, 20 * 60);

// Felsökning: var står spelaren, vilka djur finns i närheten och vilken terräng omger hen (visar ungefär vilket biom det är).
function describeSurroundings() {
  for (const player of world.getAllPlayers()) {
    const { x, y, z } = player.location;
    const dim = player.dimension;
    const surface = {};
    for (let dx = -24; dx <= 24; dx += 4) {
      for (let dz = -24; dz <= 24; dz += 4) {
        try {
          const block = dim.getTopmostBlock({ x: Math.floor(x) + dx, z: Math.floor(z) + dz });
          if (block) surface[block.typeId.replace("minecraft:", "")] = (surface[block.typeId.replace("minecraft:", "")] ?? 0) + 1;
        } catch {
          // ej laddad chunk
        }
      }
    }
    const mobs = {};
    for (const e of dim.getEntities({ location: player.location, maxDistance: 64 })) {
      if (e.typeId === "minecraft:player") continue;
      const id = e.typeId.replace("minecraft:", "");
      mobs[id] = (mobs[id] ?? 0) + 1;
    }
    console.warn(
      `dev-tools: ${player.name} at ${Math.floor(x)},${Math.floor(y)},${Math.floor(z)} ` +
        `surface=${JSON.stringify(surface)} mobs64=${JSON.stringify(mobs)}`
    );
  }
}
system.runInterval(describeSurroundings, 20 * 30);

// Felsökning: logga varje gång en igelkott uppstår (orsak + plats), så vi ser om naturlig spawn fungerar.
world.afterEvents.entitySpawn.subscribe((ev) => {
  if (ev.entity.typeId !== "starter:hedgehog") return;
  const { x, y, z } = ev.entity.location;
  console.warn(`dev-tools: hedgehog spawned cause=${ev.cause} at ${Math.floor(x)},${Math.floor(y)},${Math.floor(z)}`);
});
