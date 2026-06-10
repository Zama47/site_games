# Game Studio Catalog

## Описание проекта

Game Studio Catalog — это курсовой проект на Flutter/Dart, реализующий каталог игр с пользовательской и административной ролями. Приложение показывает список игр, хранит избранное, ведёт заказную систему и уведомления, а также сохраняет данные локально в `shared_preferences`.

> Проект готов к запуску на Flutter-платформе и использует как сетевой JSON API, так и локальную модель данных.

---

## 1. Структура системы

### 1.1 Архитектура

Приложение построено по архитектуре MVVM-подобного разделения:

- `models/` — описывает сущности `Game`, `User`, `Order`.
- `services/` — реализует доступ к данным и сохранение: `ApiService`, `AuthService`, `StorageService`.
- `providers/` — бизнес-логика и состояние: `AuthProvider`, `GamesProvider`, `NotificationsProvider`, `OrdersProvider`, `ThemeProvider`.
- `screens/` — пользовательский интерфейс: авторизация, каталог, детали, формы, уведомления.
- `widgets/` — переиспользуемые визуальные элементы: карточки игр, боковое меню, скелетон-загрузка.

### 1.2 Текстовое описание диаграммы классов

- `AuthProvider` зависит от `AuthService` и `StorageService`.
- `GamesProvider` использует `ApiService` для загрузки игр и `StorageService` для избранного, оценок, корзины и локальных изменений.
- `NotificationsProvider` хранит уведомления, загружает их из `StorageService`.
- `OrdersProvider` работает с заказами и уведомлениями через `StorageService`.
- `GameCardNew`, `AppDrawer`, `ShimmerLoading` используются на экранах для визуализации.

### 1.3 Текстовое описание диаграммы развёртывания

- Клиент: Flutter-приложение на мобильном устройстве / вебе / десктопе.
- Хранилище данных: локальное устройство, `shared_preferences`.
- Источник данных: удалённый JSON-файл на GitHub (`ApiService`) или встроенный локальный JSON-массив.

---

## 2. Таблица пользовательских классов

| Класс | Назначение | Основные методы / атрибуты | Примечание |
|---|---|---|---|
| `Game` | Сущность игры | `id`, `title`, `genre`, `description`, `rating`, `imageUrl`, `screenshots`, `isDeleted`, `userRating` | Модель данных игры |
| `User` | Сущность пользователя | `id`, `username`, `password`, `role`, `displayName`, `isAdmin`, `isGamer` | Два тестовых пользователя |
| `Order` | Сущность заказа | `id`, `gameId`, `userId`, `status`, `createdAt`, `adminComment` | Заказы пользователей |
| `AuthService` | Локальный сервис аутентификации | `login()`, `logout()`, `checkSession()`, `_saveSession()` | Сохраняет сессию в `SharedPreferences` |
| `StorageService` | Локальное хранилище | `getFavorites()`, `saveCustomGame()`, `addNotification()`, `getOrders()`, `getDeletedGames()` | Хранение данных JSON в `shared_preferences` |
| `ApiService` | Загрузка каталога игр | `fetchGames()`, `searchGames()`, `fetchAllGames()` | Поддерживает удалённый JSON + локальный fallback |
| `AuthProvider` | Состояние авторизации | `login()`, `logout()`, `checkSession()` | Обрабатывает вход и блокировку пользователей |
| `GamesProvider` | Состояние каталога | `loadGames()`, `loadMore()`, `toggleFavorite()`, `deleteGame()`, `restoreGame()` | Управляет фильтрами, сортировкой, избранным |
| `NotificationsProvider` | Состояние уведомлений | `loadNotifications()`, `markAsRead()`, `clearAll()` | Счётчик непрочитанных уведомлений |
| `OrdersProvider` | Состояние заказов | `createOrder()`, `approveOrder()`, `rejectOrder()`, `loadPendingOrders()` | Админский контроль заказов |
| `GamesListScreen` | Экран каталога игр | поиск, фильтры, загрузка, кнопка «Загрузить ещё» | Основной пользовательский экран |
| `LoginScreen` | Экран входа | `TextFormField` для логина/пароля, кнопка входа | Поддерживает две роли |
| `GameFormScreen` | Форма добавления/редактирования игры | `TextFormField`, `RadioListTile`, `CheckboxListTile` | Админ редактирует данные игры |
| `AppDrawer` | Боковое меню | Пункты навигации: избранное, заказы, админские экраны | Стандартный `Drawer` |

---

## 3. Структура БД / данных

Приложение использует локальную базу данных в виде JSON-структур, сохранённых в `shared_preferences`. Это имитирует базу данных без внешнего сервера.

### Основные сущности

- `Game` — объект игры с атрибутами `id`, `title`, `genre`, `description`, `imageUrl`, `releaseDate`, `developer`, `platforms`, `rating`, `screenshots`, `status`.
- `User` — локальные учётные записи `gamer` и `admin`.
- `Order` — заказ игры от пользователя с полями `status`, `comment`, `adminComment`.
- `Notification` — системные уведомления, хранящиеся как JSON-массива.

### Ключи хранения в `shared_preferences`

- `favorites` — список ID избранных игр.
- `ratings` — карта ID игры → оценка пользователя.
- `notifications` — список уведомлений.
- `deleted_games` — корзина удалённых игр.
- `custom_games` — добавленные / отредактированные админом игры.
- `orders` — сохранённые заказы.
- `blocked_users` — список заблокированных пользователей.
- `current_user` — сохранённая сессия текущего пользователя.

### Пример структуры JSON игры

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

---

## 4. Используемое API

### Присутствует

- `lib/services/api_service.dart` загружает данные из удалённого JSON-ресурса.
- Основной адрес:
  - `https://raw.githubusercontent.com/flutter-devs/assets/main/games_catalog/games.json`

### Для чего используется

- Загрузка списка игр
- Поиск игр
- Пагинация по 5 элементов
- Поддержка анимации загрузки перед отображением данных

### Листинг подключения

```dart
final response = await http.get(Uri.parse(baseUrl + gamesEndpoint));
if (response.statusCode == 200) {
  jsonData = json.decode(response.body);
} else {
  throw Exception('Failed to load games: ${response.statusCode}');
}
```

Если сетевой запрос не проходит, `ApiService` возвращает локальные данные из `lib/data/games_data_steam.dart`.

---

## 5. Примеры экранных форм и диалогов

### Основные экраны

- `LoginScreen` — вход пользователя
- `GamesListScreen` — главный каталог с поиском, фильтрами и кнопкой «Загрузить ещё»
- `GameDetailScreenNew` — детальная страница игры с рейтингом и трейлером
- `FavoritesScreen` — экран избранного
- `OrdersScreen` — создание и просмотр заказов игроком
- `AdminOrdersScreen` — просмотр и подтверждение заказов администратором
- `AdminUsersScreen` — блокировка / разблокировка пользователей
- `TrashScreen` — восстановление или окончательное удаление игр
- `NotificationsScreen` — список уведомлений

### Типы форм / диалогов

- Добавление / редактирование игры (`GameFormScreen`)
- Фильтрация каталога с `RadioListTile` и `CheckboxListTile`
- Подтверждение удаления / восстановления через `AlertDialog`
- Уведомления с бейджем в `AppBar`
- Поле поиска в `GamesListScreen`

---

## 6. Сценарии работы программы

### Сценарий 1: Игрок

1. Вход с логином `gamer` / паролем `pass`.
2. Загрузка списка игр с анимацией.
3. Поиск игры по названию или жанру.
4. Добавление игр в избранное.
5. Открытие страницы игры и оценка.
6. Создание заказа на игру.
7. Просмотр уведомлений о статусе заказа.

### Сценарий 2: Администратор

1. Вход с логином `admin` / паролем `pass`.
2. Просмотр всех игр и уведомлений.
3. Обзор заказов и изменение статуса заказа на `approved` или `rejected`.
4. Блокировка / разблокировка пользователей.
5. Редактирование или добавление новой игры.
6. Просмотр удалённых объектов в корзине.

---

## 7. Примеры защиты и обработки ошибок

- `ApiService` обёрнут в `try/catch`, при ошибке переход на локальный набор данных.
- `AuthProvider.login()` проверяет корректность пароля и блокировку пользователя.
- `AuthService.checkSession()` возвращает `null` при повреждённой сессии.
- `GamesProvider.loadGames()` сохраняет состояние загрузки, показывает ошибку и кнопку «Повторить».
- `NotificationsProvider` и `OrdersProvider` защищены от исключений при загрузке.
- `StorageService` проверяет наличие данных перед декодированием JSON.

---

## 8. Программная документация

### Файлы проекта и их назначение

- `lib/main.dart` — стартовая точка приложения, инициализация провайдеров.
- `lib/models/game.dart` — модель игры.
- `lib/models/user.dart` — модель пользователя.
- `lib/models/order.dart` — модель заказа.
- `lib/services/api_service.dart` — загрузка JSON-данных из сети/локально.
- `lib/services/auth_service.dart` — аутентификация и сессии.
- `lib/services/storage_service.dart` — локальное сохранение данных.
- `lib/providers/auth_provider.dart` — управление состоянием входа.
- `lib/providers/games_provider.dart` — логика каталога, избранного, фильтров.
- `lib/providers/notifications_provider.dart` — уведомления.
- `lib/providers/orders_provider.dart` — заказы.
- `lib/providers/theme_provider.dart` — тема приложения.
- `lib/screens/login_screen.dart` — экран входа.
- `lib/screens/games_list_screen.dart` — главный каталог.
- `lib/screens/game_detail_screen_new.dart` — детальная страница игры.
- `lib/screens/game_form_screen.dart` — форма добавления/редактирования.
- `lib/screens/favorites_screen.dart` — избранное.
- `lib/screens/orders_screen.dart` — заказы пользователя.
- `lib/screens/admin_orders_screen.dart` — заказы администратора.
- `lib/screens/admin_users_screen.dart` — управление пользователями.
- `lib/screens/trash_screen.dart` — восстановление/удаление игр.
- `lib/screens/notifications_screen.dart` — уведомления.
- `lib/widgets/app_drawer.dart` — боковое меню.
- `lib/widgets/game_card_new.dart` — карточка игры.
- `lib/widgets/shimmer_loading.dart` — эффект загрузки.
- `lib/styles/app_styles.dart` — тема и стили.
- `lib/data/games_data_steam_updated.dart` — локальная база данных игр.

### Зависимости

- Flutter SDK
- `provider` — состояние приложения
- `shared_preferences` — локальное хранение
- `http` — запросы к сети
- `path_provider` — доступ к файловой системе
- `cached_network_image` — кэширование изображений
- `intl` — форматирование дат
- `youtube_player_flutter` — воспроизведение трейлеров
- `carousel_slider` — карусель скриншотов
- `shimmer` — эффект загрузки
- `url_launcher` — открытие внешних ссылок

### Как запустить

1. Откройте проект в Visual Studio Code или Android Studio.
2. Убедитесь, что установлены Flutter и Dart.
3. В терминале выполните:
   ```bash
   flutter pub get
   flutter run
   ```
4. Войдите как:
   - `gamer` / `pass`
   - `admin` / `pass`

### Как начать работу в приложении

- После входа откроется каталог игр.
- Используйте строку поиска и фильтры для выбора.
- Нажмите на игру, чтобы открыть детали и оценить.
- В меню `Drawer` доступны избранное, уведомления и заказы.
- Админ может переходить на экраны управления заказами и пользователями.

---

## 9. Список используемой литературы

1. Flutter documentation — https://docs.flutter.dev/
2. Dart language tour — https://dart.dev/guides/language/language-tour
3. Provider package docs — https://pub.dev/packages/provider
4. Shared Preferences docs — https://pub.dev/packages/shared_preferences
5. HTTP package docs — https://pub.dev/packages/http
6. Cached Network Image docs — https://pub.dev/packages/cached_network_image
7. Youtube Player Flutter docs — https://pub.dev/packages/youtube_player_flutter
8. Carousel Slider docs — https://pub.dev/packages/carousel_slider
9. Shimmer package docs — https://pub.dev/packages/shimmer
10. URL Launcher docs — https://pub.dev/packages/url_launcher

---

## 10. Листинг программы

### Основные файлы с ключевой логикой

- `lib/main.dart` — инициализация приложения и провайдеров.
- `lib/services/api_service.dart` — загрузка и пагинация игр.
- `lib/services/storage_service.dart` — сохранение избранного, заказов, уведомлений и корзины.
- `lib/services/auth_service.dart` — вход, выход и проверка сессии.
- `lib/providers/games_provider.dart` — фильтры, поиск, избранное, админские действия.
- `lib/screens/games_list_screen.dart` — отображение списка, `ListView.builder`, кнопка «Загрузить ещё».
- `lib/screens/game_form_screen.dart` — работа с `RadioListTile` и `CheckboxListTile`.
- `lib/screens/admin_users_screen.dart` — управление пользователями и блокировка.

> Полный листинг доступен в папке `lib/`. Этот README содержит описание основных компонентов и ключевых точек входа.
