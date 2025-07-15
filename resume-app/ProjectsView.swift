import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddProject = false
    @State private var editingProject: Project?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.projects.isEmpty {
                    emptyStateView
                } else {
                    projectsList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Проекты")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddProject = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddProject) {
            ProjectEditView(project: nil) { project in
                resumeManager.currentResume.projects.append(project)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingProject) { project in
            ProjectEditView(project: project) { updatedProject in
                if let index = resumeManager.currentResume.projects.firstIndex(where: { $0.id == project.id }) {
                    resumeManager.currentResume.projects[index] = updatedProject
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет проектов")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте свои проекты, чтобы показать практический опыт и навыки")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить проект") {
                showingAddProject = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var projectsList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.currentResume.projects) { project in
                ProjectCard(project: project) {
                    editingProject = project
                } onDelete: {
                    resumeManager.currentResume.projects.removeAll { $0.id == project.id }
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if !project.link.isEmpty {
                        Link("Посмотреть проект", destination: URL(string: project.link) ?? URL(string: "https://example.com")!)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
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
            
            if !project.description.isEmpty {
                Text(project.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
            
            if !project.technologies.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Технологии:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80))
                    ], spacing: 4) {
                        ForEach(project.technologies, id: \.self) { tech in
                            Text(tech)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            HStack {
                Text(dateRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if project.isOngoing {
                    Text("В разработке")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
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
        
        let startDate = formatter.string(from: project.startDate)
        let endDate = project.isOngoing ? "Настоящее время" : formatter.string(from: project.endDate ?? Date())
        
        return "\(startDate) - \(endDate)"
    }
}

struct ProjectEditView: View {
    let project: Project?
    let onSave: (Project) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var technologies: [String] = []
    @State private var link = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isOngoing = false
    @State private var newTechnology = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Dates
                    datesSection
                    
                    // Technologies
                    technologiesSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(project == nil ? "Новый проект" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveProject()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let project = project {
                name = project.name
                description = project.description
                technologies = project.technologies
                link = project.link
                startDate = project.startDate
                endDate = project.endDate ?? Date()
                isOngoing = project.isOngoing
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "folder.fill", color: .indigo)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Название проекта",
                    text: $name,
                    placeholder: "Название вашего проекта"
                )
                
                CustomTextField(
                    title: "Ссылка на проект",
                    text: $link,
                    placeholder: "https://github.com/username/project"
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Описание")
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
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Период разработки", icon: "calendar", color: .orange)
            
            VStack(spacing: 12) {
                DatePicker("Дата начала", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                Toggle("Проект в разработке", isOn: $isOngoing)
                    .toggleStyle(.switch)
                
                if !isOngoing {
                    DatePicker("Дата окончания", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var technologiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Технологии", icon: "gear", color: .purple)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Добавить технологию", text: $newTechnology)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Добавить") {
                        if !newTechnology.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            technologies.append(newTechnology.trimmingCharacters(in: .whitespacesAndNewlines))
                            newTechnology = ""
                        }
                    }
                    .disabled(newTechnology.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                if !technologies.isEmpty {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100))
                    ], spacing: 8) {
                        ForEach(technologies.indices, id: \.self) { index in
                            HStack {
                                Text(technologies[index])
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                
                                Button {
                                    technologies.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private func saveProject() {
        let project = Project(
            name: name,
            description: description,
            technologies: technologies,
            link: link,
            startDate: startDate,
            endDate: isOngoing ? nil : endDate,
            isOngoing: isOngoing
        )
        
        onSave(project)
        dismiss()
    }
}

#Preview {
    NavigationView {
        ProjectsView()
            .environmentObject(ResumeManager())
    }
} 