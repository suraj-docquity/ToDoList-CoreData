//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList CoreData
//
//  Created by Suraj Jaiswal on 10/02/23.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var addedOn: Date?

}

extension ToDoListItem : Identifiable {

}
