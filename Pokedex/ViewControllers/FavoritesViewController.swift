//
//  FavoritesViewController.swift
//  Pokedex
//
//  Created by Aditya Yadav on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

import UIKit


protocol favoritesVCDelegate {
    func hideNavBarFavorites()
}

class FavoritesViewController: UIViewController {

    var pokemonArray = [Pokemon]()
    var filteredArray = [Pokemon]()
    
    var myTableView: UITableView!
    
    var favDelegate: favoritesVCDelegate?
    var searchDelegate: SearchControllerDelegate?
    
    var pokeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpmyTableView()
    }
    
    func getPokemon() {
        
        let defaults = UserDefaults.standard
        if let savedNames = defaults.object(forKey: "savedPokemon") as? [String] {
        
        pokemonArray = PokemonGenerator.getPokemonArray()
        for i in 0...(pokemonArray.count - 1) {
            let temp = pokemonArray[i]
            if savedNames.contains(temp.name) {
                filteredArray.append(temp)
            }
        }
        
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = [Pokemon]()
        getPokemon()
        favDelegate?.hideNavBarFavorites()
        self.navigationController?.navigationBar.isHidden = true
        myTableView.reloadData()
    }
    
    func setUpmyTableView() {
        view.backgroundColor = .white
        myTableView = UITableView(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: view.frame.height))
        myTableView.backgroundColor = .white
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        view.addSubview(myTableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let url = URL(string:filteredArray[indexPath.item].imageUrl)
        if url != nil {
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                cell.imageView?.image = image
            } else {
                cell.imageView?.image = UIImage(named: "search")
            }
        }
        cell.textLabel?.text = "No. \(filteredArray[indexPath.item].number!) " + filteredArray[indexPath.item].name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestVC = segue.destination as! ProfileViewController
        profileVC = DestVC
        DestVC.pokemon = filteredArray[pokeIndex!]
        DestVC.searchDelegate = self.searchDelegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokeIndex = indexPath.row
        performSegue(withIdentifier: "favToProfile", sender: self)
    }
    
}
