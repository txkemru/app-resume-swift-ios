import SwiftUI

struct SkillsView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddSkill = false
    @State private var editingSkill: Skill?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.skills.isEmpty {
                    emptyStateView
                } else {
                    skillsList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Навыки")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddSkill = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddSkill) {
            SkillEditView(skill: nil) { skill in
                resumeManager.currentResume.skills.append(skill)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingSkill) { skill in
            SkillEditView(skill: skill) { updatedSkill in
                if let index = resumeManager.currentResume.skills.firstIndex(where: { $0.id == skill.id }) {
                    resumeManager.currentResume.skills[index] = updatedSkill
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет навыков")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте свои навыки, чтобы показать работодателям ваши компетенции")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить навык") {
                showingAddSkill = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var skillsList: some View {
        VStack(spacing: 20) {
            ForEach(SkillCategory.allCases, id: \.self) { category in
                let categorySkills = resumeManager.currentResume.skills.filter { $0.category == category }
                
                if !categorySkills.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(categorySkills) { skill in
                                SkillCard(skill: skill) {
                                    editingSkill = skill
                                } onDelete: {
                                    resumeManager.currentResume.skills.removeAll { $0.id == skill.id }
                                    resumeManager.saveCurrentResume()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SkillCard: View {
    let skill: Skill
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skill.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
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
                        .font(.caption)
                }
            }
            
            HStack {
                Text(skill.level.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                SkillLevelIndicator(level: skill.level)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct SkillLevelIndicator: View {
    let level: SkillLevel
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < skillLevelValue ? Color.blue : Color(.systemGray4))
                    .frame(width: 6, height: 6)
            }
        }
    }
    
    private var skillLevelValue: Int {
        switch level {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        }
    }
}

struct SkillEditView: View {
    let skill: Skill?
    let onSave: (Skill) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var level: SkillLevel = .intermediate
    @State private var category: SkillCategory = .technical
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Level and Category
                    levelAndCategorySection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(skill == nil ? "Новый навык" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveSkill()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let skill = skill {
                name = skill.name
                level = skill.level
                category = skill.category
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "star.fill", color: .purple)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Название навыка",
                    text: $name,
                    placeholder: "Например: Swift, React, Photoshop"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var levelAndCategorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Уровень и категория", icon: "chart.bar.fill", color: .blue)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Уровень владения")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Уровень", selection: $level) {
                        ForEach(SkillLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Категория")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Категория", selection: $category) {
                        ForEach(SkillCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
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
                        
                        SkillLevelIndicator(level: level)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private func saveSkill() {
        let skill = Skill(
            name: name,
            level: level,
            category: category
        )
        
        onSave(skill)
        dismiss()
    }
}

#Preview {
    NavigationView {
        SkillsView()
            .environmentObject(ResumeManager())
    }
} 