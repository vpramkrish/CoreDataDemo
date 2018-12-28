//
//  DataViewController.swift
//  CoreDataDemo
//
//  Created by BLT0013-MACMI on 12/19/18.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    

    @IBOutlet weak var searchTxt: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var userArray:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fname = userArray[indexPath.row]
        cell.textLabel?.text = (fname.value(forKey: "firstName") as! String) + (fname.value(forKey: "lastName") as! String)
        return cell
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "firstName contains[c] %@ OR lastName contains[c] %@",searchText, searchText)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
            fetchRequest.predicate = predicate
            do {
                userArray = try managedObjectContext.fetch(fetchRequest) as! [User]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
            tblView.reloadData()
        }
        tblView.reloadData()
        }
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            userArray = try managedContext.fetch(fetchRequest) as! [User]
            
        } catch {
            
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            managedContext.delete(userArray[indexPath.row])
            do {
                try managedContext.save()
                userArray = try managedContext.fetch(fetchRequest) as! [User]
               // tblView.deleteRows(at: [indexPath], with: UITableView.RowAnimation)
                tblView.reloadData()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
