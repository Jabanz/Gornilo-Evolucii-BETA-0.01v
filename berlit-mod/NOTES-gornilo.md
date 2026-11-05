# BerlitMod — наша доработка (сборка «Горнило Эволюции»)

Оригинальный мод: **Berlit** для Minecraft 1.7.10 (Forge), автор **Beggar** (MIT).
Источник: приватный репозиторий автора.

## Что добавлено нами (2026-11)

### Cobble Generator (MK1 / MK2 / MK3)
Генератор булыжника с привязкой к IC2 EU:

- `block/BlockCobbleGenerator.java` — блок (3 уровня, метаданные)
- `tileentity/TileEntityCobbleGenerator.java` — логика: производство булыжника за EU,
  слоты апгрейдов (Overclocker / Energy Storage / Transformer), синхронизация с клиентом
- `gui/ContainerCobbleGenerator.java`, `gui/GuiCobbleGenerator.java` — интерфейс
- `util/InventoryUtils.java` — хелперы
- 9 текстур: `assets/berlit/textures/blocks/cobble_generator_*`, `gui/cobble_generator.png`
- Правки: `Berlit.java` (регистрация), `gui/GuiHandler.java` (ID GUI),
  `network/MachineSyncHandler.java` (синк), `lang/en_US.lang`, `lang/ru_RU.lang`

**Баланс (MK1 → MK3):**
| Уровень | EU/t | Время на блок | Слоты апгрейдов |
|---|---|---|---|
| MK1 | 8 EU/t | 5 сек | 2 |
| MK2 | 32 EU/t | 2 сек | 3 |
| MK3 | 128 EU/t | 0.5 сек | 4 |

## Сборка

Требуется **JDK 25** (Gradle-демон, GTNH-конвенция) и **Java 8** для запуска.
JDK 8 ставится тулчейном автоматически.

```bash
./gradlew build
```
Готовый jar: `build/libs/berlit-<версия>.jar`

В этом репозитории рядом лежит собранный `dist/berlit-dev.jar` (с нашим Cobble Generator).

## Зависимости

- Обязательно: IC2 2.2.828 experimental
- Опционально: CraftTweaker, NotEnoughItems, Draconic Evolution, Botania, Alfheim
- Jars в `libs/` — для офлайн-сборки (те же версии, что в модпаке)