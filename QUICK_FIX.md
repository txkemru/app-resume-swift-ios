# Быстрое исправление ошибки Info.plist

## 🚨 Проблема
```
Multiple commands produce Info.plist
```

## ⚡ Быстрое решение

### Шаг 1: Очистка проекта
1. В Xcode: **Product → Clean Build Folder** (⌘+Shift+K)
2. Закройте Xcode
3. Откройте Xcode заново

### Шаг 2: Настройка проекта
1. Выберите проект `resume-app` в навигаторе
2. Выберите target `resume-app`
3. Перейдите на вкладку **"Info"**
4. Добавьте в **"Custom iOS Target Properties"**:

```
Bundle display name: Resume Builder
Privacy - Photo Library Usage Description: Приложению необходим доступ к фотографиям для добавления фото профиля в резюме.
```

### Шаг 3: Проверка
1. **Product → Build** (⌘+B)
2. Если ошибок нет - **Product → Run** (⌘+R)

## 🔧 Если проблема остается

### Вариант 1: Удаление DerivedData
1. **Window → Projects → Show Build Folder in Finder**
2. Удалите папку `DerivedData`
3. Перезапустите Xcode

### Вариант 2: Создание нового Info.plist
1. **File → New → File**
2. Выберите **"Property List"**
3. Назовите `Info`
4. Добавьте необходимые ключи

## ✅ Проверка готовности
- [ ] Проект компилируется без ошибок
- [ ] Приложение запускается в симуляторе
- [ ] Можно добавить личную информацию
- [ ] Работает сохранение резюме

---

**Если ничего не помогает - смотрите подробную инструкцию в `XCODE_SETUP.md`** 