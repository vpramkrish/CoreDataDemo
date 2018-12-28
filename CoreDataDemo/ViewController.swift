//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by BLT0013-MACMI on 12/19/18.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var check: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func saveData(_ sender: UIButton) {
     saveData()
     self.first_name.text = ""
     self.last_name.text = ""

}
    @IBAction func show_Btn(_ sender: UIButton) {
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "tableVW") as! DataViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
     
            
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(self.first_name.text, forKey: "firstName")
            user.setValue(self.last_name.text, forKey: "lastName")
  
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}

