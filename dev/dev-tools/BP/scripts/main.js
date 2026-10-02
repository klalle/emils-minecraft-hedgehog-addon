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

world.afterEvents.worldLoad.subscribe(setDaytime);
system.runInterval(setDaytime, 20 * 60);
