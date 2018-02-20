//
//  ViewController.swift
//  Pokedex
//
//  Created by SAMEER SURESH on 9/25/16.
//  Copyright © 2016 trainingprogram. All rights reserved.
//

import UIKit

var resultVC: ResultsViewController?
var profileVC: ProfileViewController?

class ViewController: UITabBarController {
    
    var test: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "search") as! SearchViewController
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.title = "Filter"
        searchNavController.tabBarItem.image = UIImage(named: "filter")
        searchViewController.delegate = self
        
        let favoritesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        favoritesViewController.favDelegate = self
        let favNavController = UINavigationController(rootViewController: favoritesViewController)
        favNavController.tabBarItem.title = "Favorites"
        favNavController.tabBarItem.image = UIImage(named: "star")
        favoritesViewController.searchDelegate = self
        
        //let bgColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        
        /*
        let test = self.parent as! UINavigationController
        test.navigationBar.barTintColor = .red
        */
 
        viewControllers = [searchNavController, favNavController]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: SearchControllerDelegate {
    func changeNavBarColor(color: UIColor) {
        let parent = self.parent as! UINavigationController
        parent.navigationBar.barTintColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
        parent.navigationBar.isTranslucent = false
    }
    
    func hideNavBar() {
        print("hiding nav bar")
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = nil
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setUpResultBack() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(segueBackResult))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setUpProfileBack() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(segueBackProfile))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func segueBackResult() {
       resultVC!.goBack()
    }
    
    func segueBackProfile() {
        profileVC?.goBack()
    }
    
    func setNavBarTitle(name: String) {
        self.title = name
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func removeNavBarTitle() {
        self.title = nil
    }

}

extension ViewController: favoritesVCDelegate {
 
    func hideNavBarFavorites() {
        print("hiding nav bar!!")
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.tintColor = .white
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
}
    


