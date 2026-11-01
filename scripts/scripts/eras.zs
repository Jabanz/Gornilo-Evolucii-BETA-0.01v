// ============================================================
//  ГОРНИЛО ЭВОЛЮЦИИ 1.7.10 — ГЕЙТЫ И МОСТЫ ЭПОХ
//  Эпохи:
//    0 Каменный век
//    1 Век пара/железа   (IC2: молот, провода, первые машины)
//    2 Индустрия         (Thermal + Mekanism + BuildCraft: RF)
//    3 Электричество    (AE2 + EnderIO)
//    4 Атомная эра      (HBM + BigReactors + IC2)
//    5 Космос           (Advanced Rocketry)
//
//  Гейты: ключевые машины эпохи N требуют фирменный предмет эпохи N-1.
//  Мосты: предметы разных модов взаимозаменяемы через oreDict.
//  Проверка синтаксиса: загружается MineTweaker при старте (ошибки в логе).
// ============================================================

// ---------- ЭПОХА 1 → 2: IC2 начинается со стали ----------
// Базовая машина IC2 требует стальной корпус вместо чистого железа
recipes.remove(<IC2:blockMachine>);
recipes.addShaped(<IC2:blockMachine>, [
  [<ore:plateIron>, <ore:plateIron>, <ore:plateIron>],
  [<ore:plateIron>, <ore:plateSteel>, <ore:plateIron>],
  [<ore:plateSteel>, <ore:plateIron>, <ore:plateSteel>]
]);

// Продвинутая машина IC2 требует сталь + бронзу (эпоха 1 -> 2)
recipes.remove(<IC2:blockMachine2>);
recipes.addShaped(<IC2:blockMachine2>, [
  [<ore:plateSteel>, <ore:plateBronze>, <ore:plateSteel>],
  [<ore:plateBronze>, <IC2:blockMachine>, <ore:plateBronze>],
  [<ore:plateSteel>, <ore:plateBronze>, <ore:plateSteel>]
]);

// ---------- МОСТЫ РЕСУРСОВ ----------
// Сталь <-> рафинированное железо IC2 (взаимозаменяемы)
recipes.addShapeless(<ore:ingotRefinedIron>, [<ore:ingotSteel>]);
recipes.addShapeless(<ore:ingotSteel>, [<ore:ingotRefinedIron>]);

// Медный кабель IC2 из любого слитка меди
recipes.addShapeless(<IC2:itemCable>, [<ore:ingotCopper>]);

// Стальные пластины из стальных слитков (микрооптимизация, если пак без TE-пресса)
// (Мосты пластин уже покрыты UniDict — перекрёстные рецепты не нужны)

print("ГОРНИЛО ЭВОЛЮЦИИ: гейты эпох загружены");
