# 📤 Руководство по загрузке проекта на GitHub

## Шаг 1: Инициализация Git репозитория

Откройте терминал в папке проекта и выполните:

```bash
cd c:\Users\Zama\game_studio_catalog

# Инициализация git репозитория
git init

# Добавление всех файлов в индекс
git add .

# Первый коммит
git commit -m "Initial commit: Game Studio Catalog Flutter app with 20 games, Steam API integration, YouTube trailers, and modern UI"
```

## Шаг 2: Создание репозитория на GitHub

### Вариант A: Через веб-интерфейс (рекомендуется)

1. Перейдите на https://github.com/new
2. Введите имя репозитория: `game-studio-catalog`
3. Описание: `Flutter приложение-каталог игр с Steam API, YouTube трейлерами и современным UI`
4. Выберите:
   - ☑️ Public (публичный) или Private (приватный)
   - ☐ НЕ добавляйте README (уже есть)
   - ☐ НЕ добавляйте .gitignore (уже есть)
   - ☐ НЕ добавляйте license
5. Нажмите **Create repository**

### Вариант B: Через GitHub CLI (если установлен)

```bash
gh repo create game-studio-catalog --public --source=. --remote=origin --push
```

## Шаг 3: Связь локального репозитория с GitHub

После создания репозитория на GitHub, выполните:

```bash
# Добавление удалённого репозитория
git remote add origin https://github.com/YOUR_USERNAME/game-studio-catalog.git

# Проверка связи
git remote -v

# Отправка кода на GitHub
git branch -M main
git push -u origin main
```

## Шаг 4: Проверка загрузки

1. Перейдите на `https://github.com/YOUR_USERNAME/game-studio-catalog`
2. Убедитесь, что все файлы загружены:
   - `lib/` — исходный код
   - `pubspec.yaml` — зависимости
   - `README.md` — описание проекта
   - `.gitignore` — правила игнорирования

## 📋 Что будет загружено

✅ **Включено в репозиторий:**
- Весь исходный код (`lib/`)
- Конфигурация проекта (`pubspec.yaml`, `analysis_options.yaml`)
- README.md с описанием
- .gitignore (настроен для Flutter)
- Данные игр (`lib/data/`)
- Все виджеты и экраны

❌ **Исключено (.gitignore):**
- Папка `build/` (генерируемые файлы)
- `.dart_tool/` (кэш Dart)
- `.idea/` (настройки IDE)
- `/android/app/debug`, `profile`, `release`
- Локальные настройки

## 🔄 Последующие коммиты

После внесения изменений:

```bash
# Проверка изменений
git status

# Добавление изменений
git add .

# Коммит с описанием
git commit -m "Описание изменений"

# Отправка на GitHub
git push origin main
```

## 📝 Пример хорошего сообщения коммита

```bash
# Формат: тип(область): описание

git commit -m "feat(screens): add YouTube trailer preview cards
git commit -m "fix(api): update Steam screenshots to HD quality
git commit -m "docs(readme): add installation instructions"
git commit -m "refactor(ui): improve game card design with gradients"
```

## ⚠️ Важные замечания

### Перед первым пушем:
1. **Убедитесь, что нет API ключей** в коде
2. **Проверьте .gitignore** — ничего лишнего не должно попасть
3. **Очистите кэш изображений** если использовали локальные файлы:
   ```bash
   flutter clean
   ```

### Если проект большой:
```bash
# Увеличение лимита буфера Git
git config --global http.postBuffer 524288000

# Или отправка по частям
git push origin main --force-with-lease
```

### Добавление README бейджей:
После загрузки, добавьте в README.md:

```markdown
![Flutter Version](https://img.shields.io/badge/Flutter-3.11.5-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
```

## 🚀 Альтернатива: GitHub Desktop

Если не хотите использовать командную строку:

1. Скачайте [GitHub Desktop](https://desktop.github.com/)
2. Sign in с вашим GitHub аккаунтом
3. File → Add local repository
4. Выберите папку `game_studio_catalog`
5. Publish repository

## 🎯 Проверка после загрузки

```bash
# Клонирование для проверки
git clone https://github.com/YOUR_USERNAME/game-studio-catalog.git test-clone
cd test-clone
flutter pub get
flutter run
```

Если приложение запускается — всё работает!

## 📚 Полезные команды

```bash
# Просмотр истории коммитов
git log --oneline --graph

# Отмена последнего коммита (если ошибка)
git reset --soft HEAD~1

# Создание новой ветки
git checkout -b feature/new-screen

# Слияние веток
git checkout main
git merge feature/new-screen
```

## 🆘 Если возникли проблемы

**Ошибка: "fatal: not a git repository"**
```bash
git init
```

**Ошибка: "fatal: Authentication failed"**
- Используйте GitHub Token вместо пароля: https://github.com/settings/tokens
- Или настройте SSH ключ: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

**Ошибка: "rejected: non-fast-forward"**
```bash
git pull origin main --rebase
git push origin main
```

---

✨ **После успешной загрузки** поделитесь ссылкой на репозиторий — можно будет добавить демо-видео и скриншоты!
