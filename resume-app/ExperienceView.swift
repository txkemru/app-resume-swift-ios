import SwiftUI

struct ExperienceView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddExperience = false
    @State private var editingExperience: WorkExperience?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.experience.isEmpty {
                    emptyStateView
                } else {
                    experienceList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Опыт работы")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddExperience = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddExperience) {
            ExperienceEditView(experience: nil) { experience in
                resumeManager.currentResume.experience.append(experience)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingExperience) { experience in
            ExperienceEditView(experience: experience) { updatedExperience in
                if let index = resumeManager.currentResume.experience.firstIndex(where: { $0.id == experience.id }) {
                    resumeManager.currentResume.experience[index] = updatedExperience
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "briefcase")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет опыта работы")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте свой опыт работы, чтобы показать работодателям ваш профессиональный путь")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить опыт работы") {
                showingAddExperience = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var experienceList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.currentResume.experience) { experience in
                ExperienceCard(experience: experience) {
                    editingExperience = experience
                } onDelete: {
                    resumeManager.currentResume.experience.removeAll { $0.id == experience.id }
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
}

struct ExperienceCard: View {
    let experience: WorkExperience
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(experience.position)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(experience.company)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                }
                
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
                }
            }
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text(experience.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(dateRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !experience.description.isEmpty {
                Text(experience.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
            
            if !experience.achievements.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Достижения:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(experience.achievements.prefix(3), id: \.self) { achievement in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .foregroundColor(.blue)
                            Text(achievement)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if experience.achievements.count > 3 {
                        Text("+ еще \(experience.achievements.count - 3)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let startDate = formatter.string(from: experience.startDate)
        let endDate = experience.isCurrentPosition ? "Настоящее время" : formatter.string(from: experience.endDate ?? Date())
        
        return "\(startDate) - \(endDate)"
    }
}

struct ExperienceEditView: View {
    let experience: WorkExperience?
    let onSave: (WorkExperience) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var company = ""
    @State private var position = ""
    @State private var location = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isCurrentPosition = false
    @State private var description = ""
    @State private var achievements: [String] = []
    @State private var newAchievement = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Dates
                    datesSection
                    
                    // Description
                    descriptionSection
                    
                    // Achievements
                    achievementsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(experience == nil ? "Новый опыт" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveExperience()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let experience = experience {
                company = experience.company
                position = experience.position
                location = experience.location
                startDate = experience.startDate
                endDate = experience.endDate ?? Date()
                isCurrentPosition = experience.isCurrentPosition
                description = experience.description
                achievements = experience.achievements
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "briefcase.fill", color: .green)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Компания",
                    text: $company,
                    placeholder: "Название компании"
                )
                
                CustomTextField(
                    title: "Должность",
                    text: $position,
                    placeholder: "Ваша должность"
                )
                
                CustomTextField(
                    title: "Местоположение",
                    text: $location,
                    placeholder: "Город, страна"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Период работы", icon: "calendar", color: .orange)
            
            VStack(spacing: 12) {
                DatePicker("Дата начала", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                Toggle("Работаю по настоящее время", isOn: $isCurrentPosition)
                    .toggleStyle(.switch)
                
                if !isCurrentPosition {
                    DatePicker("Дата окончания", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Описание", icon: "text.quote", color: .blue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Описание обязанностей")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                TextEditor(text: $description)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Достижения", icon: "star.fill", color: .purple)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Добавить достижение", text: $newAchievement)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Добавить") {
                        if !newAchievement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            achievements.append(newAchievement.trimmingCharacters(in: .whitespacesAndNewlines))
                            newAchievement = ""
                        }
                    }
                    .disabled(newAchievement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                if !achievements.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(achievements.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Text(achievements[index])
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button {
                                    achievements.remove(at: index)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private func saveExperience() {
        let experience = WorkExperience(
            company: company,
            position: position,
            location: location,
            startDate: startDate,
            endDate: isCurrentPosition ? nil : endDate,
            isCurrentPosition: isCurrentPosition,
            description: description,
            achievements: achievements
        )
        
        onSave(experience)
        dismiss()
    }
}

#Preview {
    NavigationView {
        ExperienceView()
            .environmentObject(ResumeManager())
    }
} 