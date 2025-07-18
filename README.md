# Resume Builder - iOS App

Современное iOS приложение для создания профессиональных резюме с красивым интерфейсом в стиле iOS.

## 📱 Скриншоты

### Главный экран
![Главный экран](screenshots/main-screen.png)

### Личная информация
![Личная информация](screenshots/personal-info.png)

### Опыт работы
![Опыт работы](screenshots/experience.png)

### Навыки
![Навыки](screenshots/skills.png)

## 🚀 Возможности

### 📝 Создание резюме
- **Личная информация** - имя, контакты, фото профиля, социальные сети
- **Опыт работы** - компании, должности, периоды работы, достижения
- **Образование** - учебные заведения, степени, специальности, GPA
- **Навыки** - технические и мягкие навыки с уровнями владения
- **Языки** - языки программирования и иностранные языки
- **Проекты** - портфолио проектов с технологиями и ссылками
- **Сертификаты** - профессиональные сертификаты и достижения

### 💾 Управление данными
- Автоматическое сохранение в процессе редактирования
- Возможность сохранения нескольких версий резюме
- Загрузка и переключение между сохраненными резюме
- Удаление ненужных резюме

### 📤 Экспорт
- Экспорт в текстовом формате
- Экспорт в JSON формате
- Подготовка к экспорту в PDF (в разработке)
- Поделка через стандартные iOS приложения

### 🎨 Дизайн
- Современный iOS дизайн с системными цветами
- Адаптивный интерфейс для iPhone и iPad
- Красивые анимации и переходы
- Интуитивно понятная навигация

## 🛠 Технологии

- **SwiftUI** - современный фреймворк для создания пользовательского интерфейса
- **Combine** - реактивное программирование
- **UserDefaults** - локальное хранение данных
- **PhotosUI** - работа с фотографиями
- **UniformTypeIdentifiers** - экспорт файлов

## 📱 Требования

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## 🚀 Установка и запуск

1. Клонируйте репозиторий:
```bash
git clone https://github.com/yourusername/resume-app.git
cd resume-app
```

2. Откройте проект в Xcode:
```bash
open resume-app.xcodeproj
```

3. Выберите симулятор или подключите устройство

4. Нажмите ⌘+R для запуска приложения

## 📖 Использование

### Создание нового резюме
1. Откройте приложение
2. Начните заполнять разделы резюме с "Личной информации"
3. Переходите к другим разделам по мере необходимости

### Редактирование разделов
1. На главном экране выберите нужный раздел
2. Нажмите "Добавить" для создания новой записи
3. Заполните необходимые поля
4. Нажмите "Сохранить"

### Сохранение резюме
1. На главном экране нажмите "Сохраненные"
2. Нажмите "Сохранить текущее"
3. Введите название для резюме
4. Нажмите "Сохранить"

### Экспорт резюме
1. На главном экране нажмите "Экспорт в PDF"
2. Выберите формат экспорта
3. Используйте стандартное меню iOS для отправки

## 🎯 Структура проекта

```
resume-app/
├── Models.swift              # Модели данных и ResumeManager
├── ContentView.swift         # Главный экран с навигацией
├── PersonalInfoView.swift    # Личная информация
├── ExperienceView.swift      # Опыт работы
├── EducationView.swift       # Образование
├── SkillsView.swift          # Навыки
├── LanguagesView.swift       # Языки
├── ProjectsView.swift        # Проекты
├── CertificationsView.swift  # Сертификаты
├── SavedResumesView.swift    # Сохраненные резюме
├── resume_appApp.swift       # Точка входа в приложение
└── Assets.xcassets/          # Ресурсы приложения
```

## 🔧 Настройка

### Добавление новых полей
1. Отредактируйте соответствующие модели в `Models.swift`
2. Обновите представления для отображения новых полей
3. Обновите функции экспорта при необходимости

### Изменение дизайна
- Цвета и стили можно изменить в каждом представлении
- Используйте системные цвета для лучшей совместимости с темной темой
- Адаптируйте размеры для разных устройств

## 📸 Добавление скриншотов

1. Сделайте скриншоты приложения на симуляторе или устройстве
2. Сохраните их в папку `screenshots/` с понятными именами:
   - `main-screen.png` - главный экран
   - `personal-info.png` - личная информация
   - `experience.png` - опыт работы
   - `skills.png` - навыки
   - `saved-resumes.png` - сохраненные резюме
3. Обновите секцию "Скриншоты" в README

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для получения дополнительной информации.

## 📞 Поддержка

Если у вас есть вопросы или предложения, создайте Issue в репозитории или свяжитесь с разработчиком.

---

**Создано с ❤️ для iOS разработчиков** 
