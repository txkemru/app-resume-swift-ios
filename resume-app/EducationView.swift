import SwiftUI

struct EducationView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddEducation = false
    @State private var editingEducation: Education?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.education.isEmpty {
                    emptyStateView
                } else {
                    educationList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Образование")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddEducation = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddEducation) {
            EducationEditView(education: nil) { education in
                resumeManager.currentResume.education.append(education)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingEducation) { education in
            EducationEditView(education: education) { updatedEducation in
                if let index = resumeManager.currentResume.education.firstIndex(where: { $0.id == education.id }) {
                    resumeManager.currentResume.education[index] = updatedEducation
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "graduationcap")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет образования")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте информацию об образовании, чтобы показать ваш образовательный путь")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить образование") {
                showingAddEducation = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var educationList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.currentResume.education) { education in
                EducationCard(education: education) {
                    editingEducation = education
                } onDelete: {
                    resumeManager.currentResume.education.removeAll { $0.id == education.id }
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
}

struct EducationCard: View {
    let education: Education
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(education.degree)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(education.field)
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
            
            Text(education.institution)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text(education.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(dateRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !education.gpa.isEmpty {
                HStack {
                    Text("GPA:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(education.gpa)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            
            if !education.description.isEmpty {
                Text(education.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let startDate = formatter.string(from: education.startDate)
        let endDate = education.isCurrent ? "Настоящее время" : formatter.string(from: education.endDate ?? Date())
        
        return "\(startDate) - \(endDate)"
    }
}

struct EducationEditView: View {
    let education: Education?
    let onSave: (Education) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var institution = ""
    @State private var degree = ""
    @State private var field = ""
    @State private var location = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isCurrent = false
    @State private var gpa = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Dates
                    datesSection
                    
                    // Additional Information
                    additionalInfoSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(education == nil ? "Новое образование" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveEducation()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let education = education {
                institution = education.institution
                degree = education.degree
                field = education.field
                location = education.location
                startDate = education.startDate
                endDate = education.endDate ?? Date()
                isCurrent = education.isCurrent
                gpa = education.gpa
                description = education.description
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "graduationcap.fill", color: .orange)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Учебное заведение",
                    text: $institution,
                    placeholder: "Название университета/колледжа"
                )
                
                CustomTextField(
                    title: "Степень",
                    text: $degree,
                    placeholder: "Бакалавр, Магистр, PhD"
                )
                
                CustomTextField(
                    title: "Специальность",
                    text: $field,
                    placeholder: "Компьютерные науки, Экономика"
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
            SectionHeader(title: "Период обучения", icon: "calendar", color: .blue)
            
            VStack(spacing: 12) {
                DatePicker("Дата начала", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                Toggle("Учусь по настоящее время", isOn: $isCurrent)
                    .toggleStyle(.switch)
                
                if !isCurrent {
                    DatePicker("Дата окончания", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Дополнительная информация", icon: "info.circle.fill", color: .purple)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "GPA",
                    text: $gpa,
                    placeholder: "4.0"
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
    
    private func saveEducation() {
        let education = Education(
            institution: institution,
            degree: degree,
            field: field,
            location: location,
            startDate: startDate,
            endDate: isCurrent ? nil : endDate,
            isCurrent: isCurrent,
            gpa: gpa,
            description: description
        )
        
        onSave(education)
        dismiss()
    }
}

#Preview {
    NavigationView {
        EducationView()
            .environmentObject(ResumeManager())
    }
} 