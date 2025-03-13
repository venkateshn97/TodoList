//
//  ContentView.swift
//  TODOList
//
//  Created by Venky on 3/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var toDoItems: [ToDoItem] = []
    @State private var newToDoTitle: String = ""
    @State private var newToDoDescription: String = ""
    @State private var showAddForm = false
    @State private var isItemAdded = false
    @State private var newToDoPriority: ToDoItem.Priority = .low
    @State private var newToDoDueDate: Date = Date()

    // Load the data from UserDefaults when the app starts
    init() {
        loadToDoItems()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(toDoItems) { item in
                        HStack {
                            Button(action: {
                                toggleCompletion(item: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .gray)
                                .font(.body)
                            Spacer()
                            
                            // Show the priority with color coding
                            Circle()
                                .fill(item.priority.color)
                                .frame(width: 10, height: 10)
                        }
                        .background(item.priority.color.opacity(0.2)) // Light background based on priority
                        .cornerRadius(8)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            // Add action if needed on item tap
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteToDoItem(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteToDo)
                }
                .listStyle(PlainListStyle())
                .padding()
            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: Button(action: {
                showAddForm.toggle() // Toggle the Add Form
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(isItemAdded ? .green : .white)
            })
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom))
            .sheet(isPresented: $showAddForm) { // Show the form in a modal
                AddToDoForm(
                    newToDoTitle: $newToDoTitle,
                    newToDoDescription: $newToDoDescription,
                    newToDoPriority: $newToDoPriority,
                    newToDoDueDate: $newToDoDueDate,
                    saveAction: addToDo
                )
            }
        }
    }

    private func toggleCompletion(item: ToDoItem) {
        // Find the index of the item in the array
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            // Toggle the isCompleted status
            toDoItems[index].isCompleted.toggle()
            // Save the updated list to UserDefaults
            saveToDoItems()
        }
    }

    private func addToDo() {
        let newItem = ToDoItem(title: newToDoTitle, description: newToDoDescription, isCompleted: false, priority: newToDoPriority, dueDate: newToDoDueDate)
        toDoItems.append(newItem)
        isItemAdded = true  // Set the flag to true after adding an item
        saveToDoItems()
        newToDoTitle = ""
        newToDoDescription = ""
        showAddForm.toggle() // Close the form after saving
    }

    private func deleteToDoItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems.remove(at: index)
            saveToDoItems() // Update UserDefaults
        }
    }

    private func deleteToDo(at offsets: IndexSet) {
        toDoItems.remove(atOffsets: offsets)
        saveToDoItems() // Update UserDefaults
    }

    private func loadToDoItems() {
        // Load saved to-do items from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "toDoItems") {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([ToDoItem].self, from: data) {
                toDoItems = decodedItems
            }
        }
    }

    private func saveToDoItems() {
        // Save to-do items to UserDefaults
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(toDoItems) {
            UserDefaults.standard.set(encoded, forKey: "toDoItems")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
