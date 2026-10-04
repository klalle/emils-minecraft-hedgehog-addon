import { world } from "@minecraft/server";
import { ActionFormData } from "@minecraft/server-ui";

export const GUIDE_BOOK = "starter:guide_book";

// Texts live in RP/texts/*.lang (en_US, sv_SE) under starter.guide.<id>.title / .body,
// so every player sees the handbook in their own language.
// The spawn egg and the book itself are intentionally not listed.
const PAGES = ["hedgehog", "spine", "ball", "slingshot", "shield", "trap", "poison", "camo", "ruby"];

const t = (key) => ({ translate: key });

function showMenu(player) {
  const form = new ActionFormData().title(t("starter.guide.title")).body(t("starter.guide.choose"));
  for (const id of PAGES) form.button(t(`starter.guide.${id}.title`));
  form.show(player).then((res) => {
    if (res.canceled) return;
    showPage(player, PAGES[res.selection]);
  });
}

function showPage(player, id) {
  new ActionFormData()
    .title(t(`starter.guide.${id}.title`))
    .body(t(`starter.guide.${id}.body`))
    .button(t("starter.guide.back"))
    .show(player)
    .then((res) => {
      if (!res.canceled) showMenu(player);
    });
}

world.afterEvents.itemUse.subscribe((ev) => {
  if (ev.itemStack?.typeId === GUIDE_BOOK) showMenu(ev.source);
});
