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

// Felsökning: logga varje gång en igelkott uppstår (orsak + plats), så vi ser om naturlig spawn fungerar.
world.afterEvents.entitySpawn.subscribe((ev) => {
  if (ev.entity.typeId !== "starter:hedgehog") return;
  const { x, y, z } = ev.entity.location;
  console.warn(`dev-tools: hedgehog spawned cause=${ev.cause} at ${Math.floor(x)},${Math.floor(y)},${Math.floor(z)}`);
});
