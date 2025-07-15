//
//  ContentView.swift
//  resume-app
//
//  Created by Владимир Пушков on 15.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var resumeManager = ResumeManager()
    @State private var showingSavedResumes = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    headerSection
                    
                    // Resume Sections
                    resumeSections
                    
                    // Actions Section
                    actionsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Резюме")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохраненные") {
                        showingSavedResumes = true
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .environmentObject(resumeManager)
        .sheet(isPresented: $showingSavedResumes) {
            SavedResumesView()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            if let imageData = resumeManager.currentResume.personalInfo.profileImage,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 4) {
                Text(resumeManager.currentResume.personalInfo.fullName.isEmpty ? "Новое резюме" : resumeManager.currentResume.personalInfo.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if !resumeManager.currentResume.personalInfo.position.isEmpty {
                    Text(resumeManager.currentResume.personalInfo.position)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var resumeSections: some View {
        VStack(spacing: 16) {
            NavigationLink(destination: PersonalInfoView()) {
                ResumeSectionCard(
                    title: "Личная информация",
                    icon: "person.fill",
                    color: .blue,
                    isCompleted: !resumeManager.currentResume.personalInfo.firstName.isEmpty
                )
            }
            
            NavigationLink(destination: ExperienceView()) {
                ResumeSectionCard(
                    title: "Опыт работы",
                    icon: "briefcase.fill",
                    color: .green,
                    count: resumeManager.currentResume.experience.count
                )
            }
            
            NavigationLink(destination: EducationView()) {
                ResumeSectionCard(
                    title: "Образование",
                    icon: "graduationcap.fill",
                    color: .purple,
                    count: resumeManager.currentResume.education.count
                )
            }
            
            NavigationLink(destination: SkillsView()) {
                ResumeSectionCard(
                    title: "Навыки",
                    icon: "star.fill",
                    color: .orange,
                    count: resumeManager.currentResume.skills.count
                )
            }
            
            NavigationLink(destination: LanguagesView()) {
                ResumeSectionCard(
                    title: "Языки",
                    icon: "globe",
                    color: .red,
                    count: resumeManager.currentResume.languages.count
                )
            }
            
            NavigationLink(destination: ProjectsView()) {
                ResumeSectionCard(
                    title: "Проекты",
                    icon: "folder.fill",
                    color: .indigo,
                    count: resumeManager.currentResume.projects.count
                )
            }
            
            NavigationLink(destination: CertificationsView()) {
                ResumeSectionCard(
                    title: "Сертификаты",
                    icon: "certificate.fill",
                    color: .teal,
                    count: resumeManager.currentResume.certifications.count
                )
            }
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button("Сохранить резюме") {
                showingSavedResumes = true
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            
            Button("Экспорт в PDF") {
                // TODO: Implement PDF export
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct ResumeSectionCard: View {
    let title: String
    let icon: String
    let color: Color
    var count: Int?
    var isCompleted: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if let count = count {
                    Text("\(count) \(count == 1 ? "запись" : count < 5 ? "записи" : "записей")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if isCompleted {
                    Text("Заполнено")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
