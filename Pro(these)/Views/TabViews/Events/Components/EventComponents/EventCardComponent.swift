//
//  EventCardComponent.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventCardComponent: View {
    @EnvironmentObject var eventManager: EventManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appConfig: AppConfig
    @FocusState private var focusedTask: EventTasks?
    var color: Color
    var item: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            EventTaskHeader(color: color, item: item)
            
            Text("Task`s")
                .fontWeight(.medium)
                .padding(.top, 25)
                .padding(.bottom, 20)
           

            ForEach(item.tasks?.allObjects as? [EventTasks] ?? [], id: \.self) { item in
                EventTaskRow(task: item, focusedTask: $focusedTask)
            }
            
            Button {
                let newTask = EventTasks(context: managedObjectContext)
                newTask.isDone = false
                newTask.text = "Notiz"
                item.addToTasks(newTask)
                withAnimation{
                    eventManager.sortAllEvents()
                    focusedTask = newTask
                }
                do {
                    try PersistenceController.shared.container.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Add Task error: \(nsError), \(nsError.userInfo)")
                }
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Notiz hinzufügen")
                }
            }
            .foregroundColor(appConfig.fontColor)
            .padding(.top, 10)
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        
        HStack{

            Confirm(message: "Den Termin '\( item.titel ?? "" )' löschen?", buttonText: "\(item.titel ?? "Termin") löschen", buttonIcon: "trash", content: {
                Button("Löschen") { eventManager.deleteEvent(item) }
            })
            
            Spacer()
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}

