# BerlitMod — наша доработка (сборка «Горнило Эволюции»)

Оригинальный мод: **Berlit** для Minecraft 1.7.10 (Forge), автор **Beggar** (MIT).
Исходный репозиторий: https://github.com/Beggar-ru/BerlitMod

## Что добавлено нами

### Cobblestone Generator MK1 / MK2 / MK3
Новая EU-машина, портированная на архитектуру 0.19.0:

- `machine/BlockCobbleGenerator.java` — блок, три уровня со своими текстурами
- `tileentity/TileEntityCobbleGenerator.java` — IC2 `IEnergySink` (tier 4, буфер 8000),
  прогресс за блок, 4 слота апгрейдов, авто-выгрузка в соседние инвентари
- `gui/ContainerCobbleGenerator.java`, `gui/GuiCobbleGenerator.java` — по `MachineLayout`,
  тёмная тема, прогресс-бар и счётчик EU
- `util/InventoryUtils.java` — хелпер выгрузки
- `GuiHandler` — открытие GUI, `MachineSyncHandler` — синхронизация на клиент
- 9 текстур: `assets/berlit/textures/blocks/cobble_generator_*`
- Локализация: `en_US.lang` + `ru_RU.lang`
- Рецепты: железо + редстоун + печь (MK1), золото + алмаз (MK2), золото + изумруд (MK3)

**Баланс:**
| Уровень | EU/t | Время на блок | Слоты апгрейдов | Буфер |
|---|---|---|---|---|
| MK1 | 8 | 5 сек | 4 | 8000 |
| MK2 | 16 | 2.5 сек | 4 | 8000 |
| MK3 | 32 | 1.25 сек | 4 | 8000 |

## Статус

- Ветка `feature/cobble-generator` в репозитории друга, **Pull Request #1**:
  https://github.com/Beggar-ru/BerlitMod/pull/1
- Сборка проверена: `gradlew spotlessApply build` → **BUILD SUCCESSFUL**
  (jar `berlit-0.19.0-feature-cobble-generator.1+c94337c74f.jar`, 274 КБ)
- `spotlessApply` и `checkstyleMain` проходят, локализация на двух языках

## Сборка

Требуется **JDK 25** (Gradle-демон) + Java 8 (тулчейн RFG ставит сам).
Готовый jar: `build/libs/berlit-<версия>.jar`.

Собранный нами jar лежит в `dist/berlit-dev.jar`.