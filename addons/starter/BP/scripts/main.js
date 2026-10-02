import { world, system, EntityDamageCause, EquipmentSlot } from "@minecraft/server";

// Fällor: alla levande varelser som står på blocket tar skada (utom igelkottar).
const TRAPS = {
  "starter:spike_trap": { damage: 3 },
  "starter:poison_trap": { damage: 3, poisonSeconds: 8 },
  "starter:camo_trap_block": { damage: 3 }, // osynlig taggfälla
};
const TRAP_INTERVAL_TICKS = 10;

system.runInterval(() => {
  const seen = new Set();
  for (const player of world.getAllPlayers()) {
    for (const entity of player.dimension.getEntities({ location: player.location, maxDistance: 24 })) {
      if (seen.has(entity.id)) continue;
      seen.add(entity.id);
      if (!entity.isValid || !entity.isOnGround || entity.typeId === "starter:hedgehog") continue;
      if (!entity.getComponent("minecraft:health")) continue;
      const { x, y, z } = entity.location;
      const block = entity.dimension.getBlock({ x: Math.floor(x), y: Math.floor(y), z: Math.floor(z) });
      const trap = block && TRAPS[block.typeId];
      if (!trap) continue;
      entity.applyDamage(trap.damage, { cause: EntityDamageCause.contact });
      if (trap.poisonSeconds) entity.addEffect("poison", trap.poisonSeconds * 20, { amplifier: 0 });
    }
  }
}, TRAP_INTERVAL_TICKS);

const SHIELD = "starter:thorn_shield";
const THORNS_DAMAGE = 3;
const THORNS_DAMAGE_SNEAKING = 6; // håll ned sneak = "blockera"
const SNEAK_ABSORB = 0.4; // andel av skadan du får tillbaka när du sneakar

// Taggsköld: när en spelare med skölden i vänsterhanden blir slagen tar angriparen skada.
world.afterEvents.entityHurt.subscribe(
  (ev) => {
    const player = ev.hurtEntity;
    const attacker = ev.damageSource.damagingEntity;
    if (!attacker || !attacker.isValid) return;
    if (ev.damageSource.cause !== EntityDamageCause.entityAttack) return;

    const equip = player.getComponent("minecraft:equippable");
    const shield = equip?.getEquipment(EquipmentSlot.Offhand);
    if (shield?.typeId !== SHIELD) return;

    attacker.applyDamage(player.isSneaking ? THORNS_DAMAGE_SNEAKING : THORNS_DAMAGE, {
      cause: EntityDamageCause.thorns,
      damagingEntity: player,
    });

    if (player.isSneaking) {
      const health = player.getComponent("minecraft:health");
      health.setCurrentValue(Math.min(health.effectiveMax, health.currentValue + ev.damage * SNEAK_ABSORB));
    }

    // Slitage
    const durability = shield.getComponent("minecraft:durability");
    if (durability.damage + 1 >= durability.maxDurability) {
      equip.setEquipment(EquipmentSlot.Offhand, undefined);
      player.playSound("random.break");
    } else {
      durability.damage += 1;
      equip.setEquipment(EquipmentSlot.Offhand, shield);
    }
  },
  { entityTypes: ["minecraft:player"] }
);
