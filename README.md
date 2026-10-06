[![Flutter](https://img.shields.io/badge/Flutter-3.22-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4-blue)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.1-green)](https://pub.dev/packages/provider)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](#)

# 🎮 Game Studio Catalog

<img src="https://github.com/user-attachments/assets/d214b982-cc21-4ef4-aa4d-6737bb4b6296" width="250" />

**Курсовой проект на Flutter/Dart** — каталог игр с ролями игрока и администратора. Реализованы авторизация, каталог с поиском и фильтрами, избранное, заказы, уведомления и админ-панель. Данные хранятся локально в `shared_preferences`.

---

## 📸 Скриншоты

| Вход | Каталог | Детали игры |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/3e1ad860-33af-4823-a0df-06acac7a0cd1" width="220" /> | <img src="https://github.com/user-attachments/assets/2c8c1dc0-41bd-4218-9295-0cd5f072c19c" width="220" /> | <img src="https://github.com/user-attachments/assets/f3d4b91d-e502-48c2-a761-a2175fecfbd5" width="220" /> |

| Меню | Заказы игрока | Заказы админа |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/2d85e928-6c76-44c7-abc2-083336e65758" width="220" /> | <img src="https://github.com/user-attachments/assets/fb11604b-7475-427c-a7e5-211b16cfab67" width="220" /> | <img src="https://github.com/user-attachments/assets/ef548f4f-3a73-4a7c-9967-2e8febce3d83" width="220" /> |

---

## ✨ Возможности

- 🔐 Авторизация с двумя ролями: `gamer` и `admin`
- 🎮 Каталог игр с поиском, фильтрами и пагинацией
- ⭐ Избранное и оценки игр
- 📦 Система заказов с подтверждением от админа
- 🔔 Уведомления и счётчик непрочитанных
- 🛠 Админ-панель: добавление/редактирование игр, управление пользователями, корзина
- 💾 Локальное хранение данных (`shared_preferences`) + загрузка из JSON API с fallback

---

## 🏗 Архитектура

MVVM-подобное разделение:

- `models/` — сущности `Game`, `User`, `Order`, `Notification`
- `services/` — `ApiService`, `AuthService`, `StorageService`
- `providers/` — `AuthProvider`, `GamesProvider`, `OrdersProvider`, `NotificationsProvider`, `ThemeProvider`
- `screens/` — экраны приложения
- `widgets/` — переиспользуемые компоненты

**Стек:** Flutter, Dart, Provider, SharedPreferences, HTTP, CachedNetworkImage, YouTube Player, Carousel Slider, Shimmer.

---

## 🚀 Запуск

```bash
flutter pub get
flutter run
```
