//
//  ViewController.swift
//  DogWalk
//
//  Created by 孙雷 on 15/8/6.
//  Copyright (c) 2015年 Guadoo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    var currentDog: Dog!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Insert Dog entity
        
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
        
        let dog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
        
        let dogName = "Fido"
        let dogFetch = NSFetchRequest(entityName: "Dog")
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(dogFetch, error: &error) as! [Dog]?
        
        if let dogs = result{
            if dogs.count == 0{
                currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
                currentDog.name = dogName
                
                if !managedContext.save(&error){
                    println("Could not save: \(error)")
                }
            }else{
                currentDog = dogs[0]
            }
        }else{
            println("Could not fetch: \(error)")
        }
    }


    @IBAction func add(sender: AnyObject) {
        
        //Insert new Walk entity into Core Data
        let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
        
        let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
        
        walk.date = NSDate()
        
        //Insert the new Walk into the Dog's walks set
        var walks = currentDog.walks.mutableCopy() as! NSMutableOrderedSet
        
        walks.addObject(walk)
        
        currentDog.walks = walks.copy() as! NSOrderedSet
        
        // Save the managed object context
        var error:NSError?
        
        if !managedContext!.save(&error){
            println("Could not save: \(error)")
        }
        
        // TableView reload data
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var numRows = 0
        
        if let dog = currentDog {
            numRows = dog.walks.count
        }
        return numRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        
        //the next two statements have changed
        let walk = currentDog.walks[indexPath.row] as! Walk
        
        cell.textLabel?.text = dateFormatter.stringFromDate(walk.date)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // 1
            let walkToRemove = currentDog.walks[indexPath.row] as! Walk
            
            // 2
            managedContext.deleteObject(walkToRemove)
            
            //3
            var error: NSError?
            if !managedContext.save(&error){
                println("Could not save :\(error)")
            }
            
            //4
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

