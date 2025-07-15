import SwiftUI

struct CertificationsView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingAddCertification = false
    @State private var editingCertification: Certification?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if resumeManager.currentResume.certifications.isEmpty {
                    emptyStateView
                } else {
                    certificationsList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Сертификаты")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    showingAddCertification = true
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingAddCertification) {
            CertificationEditView(certification: nil) { certification in
                resumeManager.currentResume.certifications.append(certification)
                resumeManager.saveCurrentResume()
            }
        }
        .sheet(item: $editingCertification) { certification in
            CertificationEditView(certification: certification) { updatedCertification in
                if let index = resumeManager.currentResume.certifications.firstIndex(where: { $0.id == certification.id }) {
                    resumeManager.currentResume.certifications[index] = updatedCertification
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "certificate")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет сертификатов")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Добавьте свои сертификаты, чтобы показать дополнительную квалификацию")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Добавить сертификат") {
                showingAddCertification = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var certificationsList: some View {
        VStack(spacing: 16) {
            ForEach(resumeManager.currentResume.certifications) { certification in
                CertificationCard(certification: certification) {
                    editingCertification = certification
                } onDelete: {
                    resumeManager.currentResume.certifications.removeAll { $0.id == certification.id }
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
}

struct CertificationCard: View {
    let certification: Certification
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(certification.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(certification.issuer)
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
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text(dateString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !certification.link.isEmpty {
                    Link("Просмотреть", destination: URL(string: certification.link) ?? URL(string: "https://example.com")!)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if !certification.description.isEmpty {
                Text(certification.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: certification.date)
    }
}

struct CertificationEditView: View {
    let certification: Certification?
    let onSave: (Certification) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var issuer = ""
    @State private var date = Date()
    @State private var link = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Information
                    basicInfoSection
                    
                    // Additional Information
                    additionalInfoSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(certification == nil ? "Новый сертификат" : "Редактировать")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveCertification()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            if let certification = certification {
                name = certification.name
                issuer = certification.issuer
                date = certification.date
                link = certification.link
                description = certification.description
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "certificate.fill", color: .teal)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Название сертификата",
                    text: $name,
                    placeholder: "Название сертификата"
                )
                
                CustomTextField(
                    title: "Организация",
                    text: $issuer,
                    placeholder: "Название организации, выдавшей сертификат"
                )
                
                DatePicker("Дата получения", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
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
                    title: "Ссылка на сертификат",
                    text: $link,
                    placeholder: "https://example.com/certificate"
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
    
    private func saveCertification() {
        let certification = Certification(
            name: name,
            issuer: issuer,
            date: date,
            link: link,
            description: description
        )
        
        onSave(certification)
        dismiss()
    }
}

#Preview {
    NavigationView {
        CertificationsView()
            .environmentObject(ResumeManager())
    }
} 