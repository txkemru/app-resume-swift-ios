# Настройка проекта в Xcode

## 🔧 Решение проблемы с Info.plist

После открытия проекта в Xcode выполните следующие шаги:

### Шаг 1: Настройка Info.plist
1. Выберите проект `resume-app` в навигаторе проекта
2. Выберите target `resume-app`
3. Перейдите на вкладку "Info"
4. Добавьте следующие ключи в "Custom iOS Target Properties":

#### Основные настройки:
```
Bundle display name: Resume Builder
Bundle identifier: com.yourname.resume-app
Bundle version: 1
Bundle version string: 1.0
```

#### Разрешения для фотографий:
```
Privacy - Photo Library Usage Description: Приложению необходим доступ к фотографиям для добавления фото профиля в резюме.
```

### Шаг 2: Настройка ориентации
В том же разделе "Info" найдите "Supported interface orientations" и убедитесь, что выбраны:
- Portrait
- Landscape Left
- Landscape Right

### Шаг 3: Настройка минимальной версии iOS
1. Перейдите на вкладку "General"
2. В разделе "Deployment Info" установите:
   - iOS Deployment Target: 15.0
   - Devices: iPhone, iPad

### Шаг 4: Очистка проекта
1. Product → Clean Build Folder (⌘+Shift+K)
2. Product → Build (⌘+B)

## 🎯 Альтернативное решение

Если проблемы продолжаются, можно создать Info.plist программно:

### Создание Info.plist программно
1. В Xcode: File → New → File
2. Выберите "Property List"
3. Назовите файл "Info"
4. Добавьте необходимые ключи

### Или используйте настройки в коде
В `resume_appApp.swift` можно добавить:

```swift
import SwiftUI

@main
struct resume_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // Настройка разрешений
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                // Настройки приложения
            }
        }
    }
}
```

## 🚀 Проверка готовности

После настройки убедитесь, что:

1. ✅ Проект компилируется без ошибок
2. ✅ Приложение запускается в симуляторе
3. ✅ Все экраны работают корректно
4. ✅ Функции сохранения и экспорта работают

## 📱 Тестирование функций

### Проверьте основные функции:
1. **Создание резюме**: Добавьте личную информацию
2. **Сохранение**: Сохраните резюме с названием
3. **Экспорт**: Попробуйте экспортировать в текстовом формате
4. **Фотографии**: Добавьте фото профиля (в симуляторе)

### Если возникают проблемы:
1. Очистите проект: Product → Clean Build Folder
2. Удалите папку DerivedData: Window → Projects → Show Build Folder in Finder
3. Перезапустите Xcode
4. Пересоберите проект

## 🎨 Настройка иконки приложения

Для добавления иконки:
1. Подготовьте изображения разных размеров (20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024)
2. Добавьте их в `Assets.xcassets/AppIcon.appiconset/`
3. Убедитесь, что `Contents.json` правильно настроен

## 📋 Финальная проверка

Перед использованием убедитесь, что все файлы на месте:

```
resume-app/
├── Models.swift ✅
├── ResumeManager.swift ✅
├── ContentView.swift ✅
├── PersonalInfoView.swift ✅
├── ExperienceView.swift ✅
├── EducationView.swift ✅
├── SkillsView.swift ✅
├── LanguagesView.swift ✅
├── ProjectsView.swift ✅
├── CertificationsView.swift ✅
├── SavedResumesView.swift ✅
├── ExportOptionsView.swift ✅
├── Assets.xcassets/ ✅
└── resume_appApp.swift ✅
```

---

**Теперь приложение готово к использованию! 🎉** 