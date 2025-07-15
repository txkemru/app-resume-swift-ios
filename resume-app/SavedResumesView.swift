import SwiftUI

struct SavedResumesView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingSaveDialog = false
    @State private var newResumeName = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if resumeManager.savedResumes.isEmpty {
                        emptyStateView
                    } else {
                        savedResumesList
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Сохраненные резюме")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить текущее") {
                        showingSaveDialog = true
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .alert("Сохранить резюме", isPresented: $showingSaveDialog) {
            TextField("Название резюме", text: $newResumeName)
            Button("Отмена", role: .cancel) { }
            Button("Сохранить") {
                if !newResumeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    resumeManager.saveResumeAs(newResumeName.trimmingCharacters(in: .whitespacesAndNewlines))
                    newResumeName = ""
                }
            }
        } message: {
            Text("Введите название для сохранения текущего резюме")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет сохраненных резюме")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Сохраните текущее резюме, чтобы иметь возможность вернуться к нему позже")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Сохранить текущее резюме") {
                showingSaveDialog = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var savedResumesList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.savedResumes) { resume in
                SavedResumeCard(resume: resume) {
                    resumeManager.loadResume(resume)
                    dismiss()
                } onDelete: {
                    resumeManager.deleteResume(resume)
                }
            }
        }
    }
}

struct SavedResumeCard: View {
    let resume: Resume
    let onLoad: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(resume.personalInfo.fullName.isEmpty ? "Без названия" : resume.personalInfo.fullName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Создано: \(dateString)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button("Загрузить") {
                        onLoad()
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
                VStack(alignment: .leading, spacing: 2) {
                    Text("Опыт: \(resume.experience.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Образование: \(resume.education.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Навыки: \(resume.skills.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Проекты: \(resume.projects.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button("Загрузить резюме") {
                onLoad()
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: resume.createdAt)
    }
}

#Preview {
    SavedResumesView()
        .environmentObject(ResumeManager())
} 