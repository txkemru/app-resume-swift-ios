import SwiftUI
import PhotosUI

struct PersonalInfoView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showingImagePicker = false
    @State private var selectedImage: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Image Section
                profileImageSection
                
                // Basic Information
                basicInfoSection
                
                // Contact Information
                contactInfoSection
                
                // Social Links
                socialLinksSection
                
                // Summary
                summarySection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Личная информация")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Сохранить") {
                    resumeManager.saveCurrentResume()
                }
                .fontWeight(.medium)
            }
        }
        .onChange(of: selectedImage) { _ in
            Task {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                    resumeManager.currentResume.personalInfo.profileImage = data
                    resumeManager.saveCurrentResume()
                }
            }
        }
    }
    
    private var profileImageSection: some View {
        VStack(spacing: 16) {
            if let imageData = resumeManager.currentResume.personalInfo.profileImage,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
            }
            
            PhotosPicker(selection: $selectedImage, matching: .images) {
                Text("Изменить фото")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Основная информация", icon: "person.fill", color: .blue)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Имя",
                    text: $resumeManager.currentResume.personalInfo.firstName,
                    placeholder: "Введите ваше имя"
                )
                
                CustomTextField(
                    title: "Фамилия",
                    text: $resumeManager.currentResume.personalInfo.lastName,
                    placeholder: "Введите вашу фамилию"
                )
                
                CustomTextField(
                    title: "Должность",
                    text: $resumeManager.currentResume.personalInfo.position,
                    placeholder: "Например: iOS Developer"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Контактная информация", icon: "envelope.fill", color: .green)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Email",
                    text: $resumeManager.currentResume.personalInfo.email,
                    placeholder: "your.email@example.com",
                    keyboardType: .emailAddress
                )
                
                CustomTextField(
                    title: "Телефон",
                    text: $resumeManager.currentResume.personalInfo.phone,
                    placeholder: "+7 (999) 123-45-67",
                    keyboardType: .phonePad
                )
                
                CustomTextField(
                    title: "Адрес",
                    text: $resumeManager.currentResume.personalInfo.address,
                    placeholder: "Улица, дом, квартира"
                )
                
                HStack(spacing: 12) {
                    CustomTextField(
                        title: "Город",
                        text: $resumeManager.currentResume.personalInfo.city,
                        placeholder: "Москва"
                    )
                    
                    CustomTextField(
                        title: "Страна",
                        text: $resumeManager.currentResume.personalInfo.country,
                        placeholder: "Россия"
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var socialLinksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Социальные сети", icon: "link", color: .purple)
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "LinkedIn",
                    text: $resumeManager.currentResume.personalInfo.linkedin,
                    placeholder: "linkedin.com/in/yourprofile"
                )
                
                CustomTextField(
                    title: "GitHub",
                    text: $resumeManager.currentResume.personalInfo.github,
                    placeholder: "github.com/yourusername"
                )
                
                CustomTextField(
                    title: "Веб-сайт",
                    text: $resumeManager.currentResume.personalInfo.website,
                    placeholder: "yourwebsite.com"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "О себе", icon: "text.quote", color: .orange)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Краткое описание")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                TextEditor(text: $resumeManager.currentResume.personalInfo.summary)
                    .frame(minHeight: 120)
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
}

struct SectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
        }
    }
}

#Preview {
    NavigationView {
        PersonalInfoView()
            .environmentObject(ResumeManager())
    }
} 