import SwiftUI

struct LanguagesView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddLanguage = false
    @State private var editingLanguage: Language?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.languages.isEmpty {
                    emptyStateView
                } else {
                    languagesList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Языки")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddLanguage = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddLanguage) {
            LanguageEditView(language: nil) { language in
                resumeManager.currentResume.languages.append(language)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingLanguage) { language in
            LanguageEditView(language: language) { updatedLanguage in
                if let index = resumeManager.currentResume.languages.firstIndex(where: { $0.id == language.id }) {
                    resumeManager.currentResume.languages[index] = updatedLanguage
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет языков")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте языки, которыми вы владеете, чтобы показать свою языковую компетенцию")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить язык") {
                showingAddLanguage = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var languagesList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.currentResume.languages) { language in
                LanguageCard(language: language) {
                    editingLanguage = language
                } onDelete: {
                    resumeManager.currentResume.languages.removeAll { $0.id == language.id }
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
}

struct LanguageCard: View {
    let language: Language
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(language.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(language.level.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            LanguageLevelIndicator(level: language.level)
            
            Menu {
                Button("Редактировать") {
                    onEdit()
                }
                
                Button("Удалить", role: .destructive) {
                    onDelete()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct LanguageLevelIndicator: View {
    let level: LanguageLevel
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < languageLevelValue ? Color.red : Color(.systemGray4))
                    .frame(width: 6, height: 6)
            }
        }
    }
    
    private var languageLevelValue: Int {
        switch level {
        case .basic: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .native: return 4
        }
    }
}

struct LanguageEditView: View {
    let language: Language?
    let onSave: (Language) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var level: LanguageLevel = .intermediate
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Level
                    levelSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(language == nil ? "Новый язык" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveLanguage()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let language = language {
                name = language.name
                level = language.level
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "globe", color: .red)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Название языка",
                    text: $name,
                    placeholder: "Например: Английский, Испанский, Китайский"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var levelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Уровень владения", icon: "chart.bar.fill", color: .blue)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Уровень владения")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Уровень", selection: $level) {
                        ForEach(LanguageLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Level indicator preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Предварительный просмотр")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(level.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        LanguageLevelIndicator(level: level)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private func saveLanguage() {
        let language = Language(
            name: name,
            level: level
        )
        
        onSave(language)
        dismiss()
    }
}

#Preview {
    NavigationView {
        LanguagesView()
            .environmentObject(ResumeManager())
    }
} 