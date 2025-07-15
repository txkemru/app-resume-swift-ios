import Foundation

// MARK: - Resume Model
struct Resume: Identifiable, Codable {
    var id = UUID()
    var personalInfo: PersonalInfo
    var experience: [WorkExperience]
    var education: [Education]
    var skills: [Skill]
    var languages: [Language]
    var projects: [Project]
    var certifications: [Certification]
    var createdAt: Date
    var updatedAt: Date
    
    init() {
        self.personalInfo = PersonalInfo()
        self.experience = []
        self.education = []
        self.skills = []
        self.languages = []
        self.projects = []
        self.certifications = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Personal Information
struct PersonalInfo: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var position: String = ""
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var linkedin: String = ""
    var github: String = ""
    var website: String = ""
    var summary: String = ""
    var profileImage: Data?
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Work Experience
struct WorkExperience: Identifiable, Codable {
    var id = UUID()
    var company: String = ""
    var position: String = ""
    var location: String = ""
    var startDate: Date = Date()
    var endDate: Date?
    var isCurrentPosition: Bool = false
    var description: String = ""
    var achievements: [String] = []
}

// MARK: - Education
struct Education: Identifiable, Codable {
    var id = UUID()
    var institution: String = ""
    var degree: String = ""
    var field: String = ""
    var location: String = ""
    var startDate: Date = Date()
    var endDate: Date?
    var isCurrent: Bool = false
    var gpa: String = ""
    var description: String = ""
}

// MARK: - Skills
struct Skill: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var level: SkillLevel = .intermediate
    var category: SkillCategory = .technical
}

enum SkillLevel: String, CaseIterable, Codable {
    case beginner = "Начинающий"
    case intermediate = "Средний"
    case advanced = "Продвинутый"
    case expert = "Эксперт"
}

enum SkillCategory: String, CaseIterable, Codable {
    case technical = "Технические"
    case soft = "Мягкие навыки"
    case language = "Языки программирования"
    case tools = "Инструменты"
    case other = "Другое"
}

// MARK: - Languages
struct Language: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var level: LanguageLevel = .intermediate
}

enum LanguageLevel: String, CaseIterable, Codable {
    case basic = "Базовый"
    case intermediate = "Средний"
    case advanced = "Продвинутый"
    case native = "Родной"
}

// MARK: - Projects
struct Project: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var description: String = ""
    var technologies: [String] = []
    var link: String = ""
    var startDate: Date = Date()
    var endDate: Date?
    var isOngoing: Bool = false
}

// MARK: - Certifications
struct Certification: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var issuer: String = ""
    var date: Date = Date()
    var link: String = ""
    var description: String = ""
} 

// MARK: - ResumeManager
class ResumeManager: ObservableObject {
    @Published var currentResume: Resume = Resume()
    @Published var savedResumes: [Resume] = []
    
    private let userDefaults = UserDefaults.standard
    private let currentResumeKey = "currentResume"
    private let savedResumesKey = "savedResumes"
    
    init() {
        loadCurrentResume()
        loadSavedResumes()
    }
    
    // MARK: - Current Resume Management
    func saveCurrentResume() {
        currentResume.updatedAt = Date()
        if let encoded = try? JSONEncoder().encode(currentResume) {
            userDefaults.set(encoded, forKey: currentResumeKey)
        }
    }
    
    private func loadCurrentResume() {
        if let data = userDefaults.data(forKey: currentResumeKey),
           let resume = try? JSONDecoder().decode(Resume.self, from: data) {
            currentResume = resume
        }
    }
    
    // MARK: - Saved Resumes Management
    func saveResumeAs(_ name: String) {
        var resumeToSave = currentResume
        resumeToSave.id = UUID()
        resumeToSave.createdAt = Date()
        resumeToSave.updatedAt = Date()
        
        savedResumes.append(resumeToSave)
        saveSavedResumes()
    }
    
    func loadResume(_ resume: Resume) {
        currentResume = resume
        saveCurrentResume()
    }
    
    func deleteResume(_ resume: Resume) {
        savedResumes.removeAll { $0.id == resume.id }
        saveSavedResumes()
    }
    
    private func loadSavedResumes() {
        if let data = userDefaults.data(forKey: savedResumesKey),
           let resumes = try? JSONDecoder().decode([Resume].self, from: data) {
            savedResumes = resumes
        }
    }
    
    private func saveSavedResumes() {
        if let encoded = try? JSONEncoder().encode(savedResumes) {
            userDefaults.set(encoded, forKey: savedResumesKey)
        }
    }
} 