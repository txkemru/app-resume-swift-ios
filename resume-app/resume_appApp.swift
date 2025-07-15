//
//  resume_appApp.swift
//  resume-app
//
//  Created by Владимир Пушков on 15.07.2025.
//

import SwiftUI

@main
struct resume_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // Настройка внешнего вида приложения
        setupAppearance()
    }
    
    private func setupAppearance() {
        // Настройка цвета акцента
        if let accentColor = UIColor(named: "AccentColor") {
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = accentColor
        }
    }
}
