//
//  ToDoItem.swift
//  TODOList
//
//  Created by Venky on 3/13/25.
//
import SwiftUI

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date
    
    // Priority Enum for setting priority levels
    enum Priority: String, Codable, CaseIterable {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }
    }
}
