////
////  ToDoEntity.swift
////  ToDO List
////
////  Created by Lilit Avdalyan on 20.08.25.
////
//
//import Foundation
//internal import CoreData
//
//@objc(ToDoEntity)
//final class ToDoEntity: NSManagedObject {
//    
//}
//
//extension ToDoEntity {
//    
//    @nonobjc
//    class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
//        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
//    }
//    
//    @NSManaged var id: Int64
//    @NSManaged var title: String       
//    @NSManaged var todo: String        
//    @NSManaged var completed: Bool
//    @NSManaged var date: Date?
//    @NSManaged var userId: Int64
//}
//
//extension ToDoEntity: Identifiable { }
