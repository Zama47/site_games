# 📸 Руководство по получению реальных Steam изображений

## Формат URL Steam

### Обложки игр (Header)
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/header.jpg
```

Пример: https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg

### Скриншоты игр
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/ss_{index}.jpg
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/ss_{index}.1920x1080.jpg
```

Пример: https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_107600c1337e9c9a1d1a6631d50362495caf3b2d.1920x1080.jpg

### Библиотечные обложки
```
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/library_600x900_2x.jpg
https://cdn.cloudflare.steamstatic.com/steam/apps/{appid}/library_hero.jpg
```

## 🎮 Steam App IDs для популярных игр

| Игра | App ID |
|------|--------|
| The Witcher 3 | 292030 |
| Cyberpunk 2077 | 1091500 |
| GTA V | 271590 |
| Red Dead Redemption 2 | 1174180 |
| Elden Ring | 1245620 |
| God of War | 1593500 |
| Horizon Zero Dawn | 1151640 |
| Call of Duty MW2 (2022) | 1938090 |
| Apex Legends | 1172470 |
| Spider-Man Remastered | 1817070 |
| Resident Evil 4 | 2050650 |
| Street Fighter 6 | 1364780 |
| Hogwarts Legacy | 990080 |
| Dead Space | 1693980 |
| Baldur's Gate 3 | 1086940 |
| Starfield | 1716740 |
| It Takes Two | 1426210 |
| Hades | 1145360 |
| Stardew Valley | 413150 |
| Hollow Knight | 367520 |
| The Last of Us | 1885730 |
| Uncharted | 1659640 |
| Assassin's Creed Valhalla | Нет в Steam (Ubisoft) |
| Fortnite | Нет в Steam (Epic) |

## 🔍 Как найти App ID любой игры

### Способ 1: Через URL
1. Откройте страницу игры в Steam
2. URL будет вида: `store.steampowered.com/app/292030`
3. Цифры после `/app/` — это App ID

### Способ 2: Через SteamDB
1. Перейдите на https://steamdb.info
2. Найдите игру через поиск
3. App ID будет в заголовке и URL

### Способ 3: Через API
```bash
curl "https://api.steampowered.com/ISteamApps/GetAppList/v2/"
```

## 📸 Как получить реальные скриншоты

### Метод 1: Steam Store Page
1. Откройте страницу игры в Steam
2. Нажмите "Просмотреть все скриншоты"
3. Откройте любой скриншот в полном размере
4. Скопируйте URL изображения

### Метод 2: Steam API (программно)
```bash
# Получить скриншоты через Steam API
curl "https://store.steampowered.com/api/appdetails?appids=292030"
```

В ответе будет поле `screenshots` с массивом URL.

### Метод 3: SteamDB
1. Перейдите на `https://steamdb.info/app/{appid}/`
2. В разделе "Screenshots" будут все доступные изображения
3. Кликните правой кнопкой → "Копировать адрес изображения"

## 🎨 Рекомендации по изображениям

### Для карточек игр
- Используйте `header.jpg` — 460x215px
- Или `library_600x900_2x.jpg` — вертикальный формат

### Для скриншотов
- Используйте версию с `.1920x1080.jpg` — Full HD
- Это гарантирует хорошее качество на всех экранах

### Для детального экрана (Hero)
- Используйте `library_hero.jpg` — широкий баннер
- Или любой скриншот в высоком разрешении

## ⚠️ Важно

Некоторые игры могут:
- **Менять URL скриншотов** после обновлений
- **Не иметь публичных скриншотов** (редко)
- **Использовать разные CDN** для разных регионов

Рекомендуется периодически проверять работоспособность ссылок!

## 🛠 Быстрый скрипт проверки

```bash
#!/bin/bash
# Проверка доступности изображений Steam

APP_ID="292030"  # The Witcher 3
echo "Проверка изображений для App ID: $APP_ID"

curl -sI "https://cdn.cloudflare.steamstatic.com/steam/apps/$APP_ID/header.jpg" | head -1
curl -sI "https://cdn.cloudflare.steamstatic.com/steam/apps/$APP_ID/library_600x900_2x.jpg" | head -1
```

## 🔄 Альтернативные источники изображений

### IGDB (требует API ключ)
```
https://images.igdb.com/igdb/image/upload/t_cover_big/{image_id}.jpg
```

### RAWG
```
https://api.rawg.io/media/games/{slug}/background.jpg
```

### Epic Games Store
```
https://cdn1.epicgames.com/salesEvent/salesEvent/{slug}
```

## 📱 Для мобильных приложений

При загрузке изображений используйте `CachedNetworkImage` с параметрами:

```dart
CachedNetworkImage(
  imageUrl: steamUrl,
  fit: BoxFit.cover,
  memCacheWidth: 800,  // Ограничение для памяти
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

Это предотвратит переполнение памяти при больших изображениях 1920x1080.
