# 🎮 Steam Scripts

Набор Python скриптов для автоматического получения данных об играх из Steam.

## 📋 Требования

```bash
pip install -r requirements.txt
```

## 🔧 Скрипты

### 1. `fetch_steam_data.py` — Получение данных из Steam API

Автоматически получает реальные данные об играх:
- Название и описание
- Жанр и разработчика
- Обложку (header image)
- Скриншоты (Full HD)
- Дату релиза
- Поддерживаемые платформы

**Использование:**
```bash
python fetch_steam_data.py
```

**Результат:**
- Файл: `lib/data/games_data_steam_auto.dart`
- Содержит актуальные данные из Steam API

**Настройка списка игр:**
Отредактируйте список `game_ids` в начале скрипта:
```python
game_ids = [
    292030,    # The Witcher 3
    1091500,   # Cyberpunk 2077
    # Добавьте свои App ID
]
```

### 2. `verify_screenshots.py` — Проверка URL скриншотов

Проверяет работоспособность всех URL скриншотов в файле данных.

**Использование:**
```bash
python verify_screenshots.py
```

**Результат:**
- Список рабочих и нерабочих URL
- Статистика доступности

## 🔍 Как найти Steam App ID

### Способ 1: URL игры в Steam
```
https://store.steampowered.com/app/292030/The_Witcher_3/
                              └─ App ID ─┘
```

### Способ 2: SteamDB
1. Перейдите на https://steamdb.info
2. Найдите игру через поиск
3. App ID будет в заголовке страницы

### Способ 3: API список
```bash
curl "https://api.steampowered.com/ISteamApps/GetAppList/v2/" | python -m json.tool
```

## 📸 Форматы изображений Steam

### Обложка игры (Header)
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/header.jpg
```
Размер: 460x215px

### Библиотечная обложка
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/library_600x900_2x.jpg
```
Размер: 600x900px (вертикальная)

### Скриншоты
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/ss_{hash}.jpg
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/ss_{hash}.1920x1080.jpg
```
Размеры: 1920x1080 (Full HD)

### Геройский баннер
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/library_hero.jpg
```
Размер: ~1920x620px

## ⚠️ Ограничения Steam API

- **Лимит запросов:** ~200 запросов в 5 минут
- **Скрипт добавляет задержку 1.5 секунды между запросами**
- **Некоторые игры могут быть недоступны** в определённых регионах

## 🛠 Ручное получение скриншотов

Если API не работает, получите скриншоты вручную:

1. Откройте страницу игры в Steam
2. Нажмите "View all screenshots" / "Просмотреть все скриншоты"
3. Откройте любой скриншот в полном размере
4. Скопируйте URL (правый клик → Copy image address)

Пример URL:
```
https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_107600c1337e9c9a1d1a6631d50362495caf3b2d.1920x1080.jpg
```

## 📝 Примеры App ID популярных игр

| Игра | App ID |
|------|--------|
| The Witcher 3 | 292030 |
| Cyberpunk 2077 | 1091500 |
| GTA V | 271590 |
| Red Dead Redemption 2 | 1174180 |
| Elden Ring | 1245620 |
| God of War | 1593500 |
| Horizon Zero Dawn | 1151640 |
| Hogwarts Legacy | 990080 |
| Baldur's Gate 3 | 1086940 |
| Spider-Man Remastered | 1817070 |
| Resident Evil 4 | 2050650 |
| Street Fighter 6 | 1364780 |
| Dead Space | 1693980 |
| Starfield | 1716740 |
| It Takes Two | 1426210 |
| Hades | 1145360 |
| Stardew Valley | 413150 |
| Hollow Knight | 367520 |
| Apex Legends | 1172470 |
| The Last of Us Part I | 1885730 |

## 🔄 Интеграция с Flutter

После генерации файла `games_data_steam_auto.dart`:

1. **Подключите в API сервисе:**
```dart
import '../data/games_data_steam_auto.dart';

// В api_service.dart замените:
jsonData = gamesSteamDataAuto; // вместо gamesSteamData
```

2. **Или переименуйте файл:**
```bash
mv lib/data/games_data_steam_auto.dart lib/data/games_data_steam.dart
```

## 🆘 Устранение неполадок

### Ошибка "Failed to load games"
- Проверьте интернет-соединение
- Увеличьте таймаут в скрипте
- Попробуйте VPN (некоторые игры регион-лок)

### Скриншоты не загружаются в приложении
- Проверьте URL через `verify_screenshots.py`
- Используйте `flutter clean && flutter run`
- Проверьте AndroidManifest.xml на наличие Internet permission

### Ошибка 403 в Steam API
- Steam иногда блокирует автоматические запросы
- Увеличьте задержку между запросами
- Используйте разные User-Agent

---

✨ **После генерации не забудьте проверить данные и исправить трейлеры YouTube!**
