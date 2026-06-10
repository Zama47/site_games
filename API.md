# API для Game Studio Catalog

## Обзор

Приложение использует лёгкое сетевое API — удалённый JSON-файл на GitHub — и локальный набор данных как fallback. API служит только для получения списка игр и поиска по нём; все модификации (редактирование, удаление, избранное, заказы) сохраняются локально через `shared_preferences`.

- Базовый URL: `https://raw.githubusercontent.com`
- Эндпоинт каталога: `/flutter-devs/assets/main/games_catalog/games.json`

## Эндпоинты и назначение

1. GET /flutter-devs/assets/main/games_catalog/games.json
   - Возвращает JSON-массив объектов `Game`.
   - Используется для загрузки списка игр, поиска и получения полного набора данных.
   - Серверная часть в проекте отсутствует; это статический JSON-файл, который клиент загружает через `http.get`.

## Пагинация

- В `ApiService` реализована клиентская пагинация по 5 элементов (`pageSize = 5`).
- Метод `fetchGames({int page = 0})` берет полный массив и возвращает срез: `sublist(startIndex, endIndex)`.

## Поведение при ошибках и fallback

- Если сетевой запрос падает (ненулевой код ответа или исключение), `ApiService` ловит исключение и возвращает локальный массив `games_data_steam.dart`.
- При `useLocalData = true` сервис всегда использует локальный массив (полезно для оффлайн-режима и тестирования).

## Пример структуры JSON-объекта (Game)

```json
{
  "id": 101,
  "title": "Example Game",
  "genre": "RPG",
  "description": "Описание игры",
  "releaseDate": "2025-12-01T00:00:00.000",
  "rating": 4.8,
  "imageUrl": "https://...",
  "developer": "Game Studio",
  "platforms": ["PC", "Xbox"],
  "status": "Released",
  "isFree": false,
  "trailerUrl": "https://...",
  "screenshots": ["https://...", "https://..."],
  "isDeleted": false
}
```

## Листинг подключения к API (Dart / Flutter)

Пример из `lib/services/api_service.dart` (упрощённый):

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://raw.githubusercontent.com';
  static const String gamesEndpoint = '/flutter-devs/assets/main/games_catalog/games.json';

  Future<List<Map<String, dynamic>>> fetchRawJson() async {
    final response = await http.get(Uri.parse(baseUrl + gamesEndpoint));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load games: ${response.statusCode}');
    }
  }
}
```

Пример вызова и обработки (в провайдере):

```dart
try {
  final newGames = await _apiService.fetchGames(page: _currentPage);
  // добавить в состояние, применить фильтры и т.д.
} catch (e) {
  // показать ошибку пользователю и/или использовать локальные данные
}
```

## Примеры использования

- Получение первой страницы каталога:

```dart
final api = ApiService();
final page0 = await api.fetchGames(page: 0);
```

- Поиск по строке (на стороне клиента):

```dart
final results = await api.searchGames('witcher');
```

## Зависимости

- В `pubspec.yaml` используется:
  - `http` — для выполнения GET-запросов.

Добавление в `pubspec.yaml` (уже присутствует в проекте):

```yaml
dependencies:
  http: ^1.2.0
```

## Рекомендации и улучшения

- Для реального бэкенда рекомендуется заменить статический JSON на REST API (Express, Django, Flask и т.д.) и поддержать серверную пагинацию.
- Для оффлайн-first сценариев можно добавить локальную БД (`sqflite` или `hive`) вместо `shared_preferences` для больших объёмов данных.
- Кеширование и ETag/If-Modified-Since помогут снизить трафик при частых запросах.

## Быстрый пример: интеграция в `GamesProvider` (в проекте уже реализовано)

- В `lib/providers/games_provider.dart` используется `ApiService.fetchGames(page: ...)` для поэтапной загрузки и кнопки "Загрузить ещё".
- При добавлении в избранное вызывается `StorageService.addNotification(...)`, что демонстрирует связь клиентских действий с локальным хранилищем и уведомлениями.

---

## Скрипт загрузки изображений Steam

В проекте есть утилита `scripts/fetch_steam_data.py`, которая автоматически получает данные (header image и скриншоты) из Steam Store API по списку AppID и генерирует Dart-файл `lib/data/games_data_steam_auto.dart`.

Ключевые особенности скрипта:
- Использует `store.steampowered.com/api/appdetails?appids=...` для получения `screenshots` и `header_image`.
- Ограничивает количество скриншотов (по умолчанию первые 3) и форматирует дату.
- Генерирует корректный Dart-массив `gamesSteamData`, который можно подключить в `ApiService` как локальный датасет.

Пример запуска (требуется Python и `requests`):

```bash
python scripts/fetch_steam_data.py
```

После успешного выполнения будет создан файл `lib/data/games_data_steam_auto.dart`. Для использования сгенерированных данных можно поменять в `ApiService` флаг либо импортировать этот файл вместо текущего `games_data_steam.dart`.

Дополнительно в проекте есть файл `STEAM_IMAGES_GUIDE.md` с описанием форматов URL Steam (header, screenshots, library images) и рекомендациями по кэшированию изображений в `CachedNetworkImage`.

Если хотите, могу автоматически добавить использование `games_data_steam_auto.dart` в `ApiService` (или добавить инструкцию в `README.md`), а также добавить `requirements.txt` с `requests` для удобства запуска скрипта.

Файл создан автоматически. Если хотите, добавлю вверхний раздел с curl-примерами или Postman-колекцией для тестирования удалённого JSON-файла.