//
//  EventTaskRow.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventTaskRow: View {
    var task: EventTasks
    var focusedTask: FocusState<EventTasks?>.Binding
    @EnvironmentObject var eventManager: EventManager
    @State var toggleState: Bool = false
    var body: some View {
        HStack {
            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    withAnimation{
                        task.isDone.toggle()
                        eventManager.sortAllEvents()
                    }
                    do {
                        try PersistenceController.shared.container.viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            
            TextField(task.text ?? "Notiz", text: Binding(get: {task.text ?? ""}, set: {task.text = $0}), onEditingChanged: { _ in
                do {
                    try PersistenceController.shared.container.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            })
            
            Button(action: {
                eventManager.deleteTask(task)
            }, label: {
                Image(systemName: "trash")
            })
        }
        .foregroundColor(task.isDone ? .white.opacity(0.4) : .white )
        .padding(5)
    }
}
