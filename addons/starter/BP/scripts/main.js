import { world, EntityDamageCause, EquipmentSlot } from "@minecraft/server";

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
