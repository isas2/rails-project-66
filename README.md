# Анализатор качества репозиториев

### Hexlet tests and linter status:
[![Actions Status](https://github.com/isas2/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/isas2/rails-project-66/actions)
[![CI](https://github.com/isas2/rails-project-66/actions/workflows/lint-test.yml/badge.svg)](https://github.com/isas2/rails-project-66/actions)

### Развёрнутое приложение (но это не точно)
[https://ror.zabedu.ru/](https://ror.zabedu.ru/).

### Описание

Анализатор качества репозиториев. Проект, который помогает автоматически следить за качеством репозиториев на Github. Он отслеживает изменения и прогоняет их через встроенные анализаторы. Затем формирует отчеты и отправляет их пользователю.

Основные возможности:

* Аутентификация пользователей через Github;
* Добавление и редактирование списка репозиториев зарегистрированными пользователями сервиса;

* Выбор категории объявления при публикации;
* Прикрепление изображений к объявлениям;
* Модерация объявлений перед публикацией;
* Удобный поиск и постраничный доступ;
* Авторизация доступа пользователей;
* Выделенный раздел для администрирования категорий и объявлений.

### Установка зависимостей

```sh
make setup
```

### Запуск тестов

```sh
make test
```

### Запуск проверки синтаксиса

```sh
make lint
make lint-fix
```

### Лицензия

[MIT License](https://opensource.org/licenses/MIT).
