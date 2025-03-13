//
//  AddToDoForm.swift
//  TODOList
//
//  Created by Venky on 3/13/25.
//

import SwiftUI

struct AddToDoForm: View {
    @Binding var newToDoTitle: String
    @Binding var newToDoDescription: String
    @Binding var newToDoPriority: ToDoItem.Priority
    @Binding var newToDoDueDate: Date
    var saveAction: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $newToDoTitle)
                }
                Section(header: Text("Description")) {
                    TextField("Enter description", text: $newToDoDescription)
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $newToDoPriority) {
                        ForEach(ToDoItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $newToDoDueDate, displayedComponents: .date)
                }
                Button(action: {
                    saveAction()
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationBarTitle("Add New To-Do")
        }
    }
}
