//
//  Dog.swift
//  
//
//  Created by 孙雷 on 15/8/6.
//
//

import Foundation
import CoreData

class Dog: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var walks: NSOrderedSet

}
