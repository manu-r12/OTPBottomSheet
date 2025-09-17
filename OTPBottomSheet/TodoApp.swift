//
//  TodoApp.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import SwiftUI
import Combine

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

final class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var newTodoText: String = ""

    func addTodo() {
        guard !newTodoText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTodo = TodoItem(title: newTodoText)
        todos.append(newTodo)
        newTodoText = ""
    }

    func toggleTodo(at index: Int) {
        guard index < todos.count else { return }
        todos[index].isCompleted.toggle()
    }

    func deleteTodo(at index: Int) {
        guard index < todos.count else { return }
        todos.remove(at: index)
    }
}

struct TodoAppView: View {
    @ObservedObject private var viewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("My Tasks")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Add new todo
                    HStack {
                        TextField("Add a new task...", text: $viewModel.newTodoText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                viewModel.addTodo()
                            }

                        Button(action: {
                            viewModel.addTodo()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.newTodoText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .padding()
                .background(Color(.systemBackground))

                Divider()

                // Todo list
                if viewModel.todos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No tasks yet")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Add a task above to get started")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(Array(viewModel.todos.enumerated()), id: \.element.id) { index, todo in
                                TodoRowView(
                                    todo: todo,
                                    onToggle: { viewModel.toggleTodo(at: index) },
                                    onDelete: { viewModel.deleteTodo(at: index) }
                                )
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TodoAppView()
}