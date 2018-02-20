//
//  ResultsViewController.swift
//  Pokedex
//
//  Created by Ethan Wong on 2/15/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

import UIKit

class ResultsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var minAttack: Int?
    var minDefense: Int?
    var minHealth: Int?
    var searchBar: String?
    
    var pokeIndex: Int?
    var pokemonArray = [Pokemon]()
    var filteredArray = [Pokemon]()
    
    var myTableView : UITableView!
    var myCollectionView : UICollectionView!
    
    var random = false
    
    var reddishColor : UIColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
    
    var label: UILabel!
    var searchDelegate: SearchControllerDelegate?
    
    override func viewDidLoad() {
        resultVC = self
        self.tabBarController?.tabBar.isHidden = true
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = reddishColor
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .white
        setUpSegmentControl()
        setUpTableView()
        setUpCollectionView()
        self.myCollectionView.isHidden = true
        getPokemon()
        
        if filteredArray.count == 0 {
            noPokemonFoundAlert()
        }
        
    }
    
    func noPokemonFoundAlert(){
        let alert = UIAlertController(title: "Search Again", message:"Sorry, No Pokemon Found", preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.searchDelegate?.segueBackResult()
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchDelegate?.removeNavBarTitle()
        searchDelegate?.hideNavBar()
        searchDelegate?.setUpResultBack()
    }
    
    func getPokemon() {
        
        pokemonArray = PokemonGenerator.getPokemonArray()
        
        if !random {
            
            if searchBar != "" {
                
                if let num = Int(searchBar!) {
                    // number entered
                    
                    for i in 0...(pokemonArray.count - 1) {
                        let temp = pokemonArray[i]
                        let pokeNum = temp.number
                        if num == pokeNum {
                            filteredArray.append(temp)
                        }
                    }
                    
                } else {
                    
                    
                    
                    for i in 0...(pokemonArray.count - 1) {
                        //search for name
                        let temp = pokemonArray[i]
                        let name = temp.name
                        if name?.range(of: searchBar!) != nil {
                            filteredArray.append(temp)
                        }
                    }
                    
                }
                
            } else {
                //category filters
                
                //types
                for i in 0...(pokemonArray.count - 1) {
                    let temp = pokemonArray[i]
                    let type = temp.types
                    var single = true
                    for i in 0...(type.count - 1) {
                        if (typeFilters.contains(type[i]) && single) {
                            
                            if (minAttack! < temp.attack && minDefense! < temp.defense && minHealth! < temp.health) {
                                
                                filteredArray.append(temp)
                                single = false
                            }
                        }
                    }
                }
                
            }
            
        } else {
            
            var tracker = [Int]()
            //random
            for _ in 1...20 {
                let temp = Int(arc4random_uniform(800))
                tracker.append(temp)
                filteredArray.append(pokemonArray[temp])
            }
            
        }
        
    }
    
    //CollectionView
    func setUpCollectionView() {
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 166), collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        //let bgColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        //collectionView.backgroundColor = bgColor
        myCollectionView.backgroundColor = .white
        myCollectionView.register(PokeButtonCell.self, forCellWithReuseIdentifier: "button")
        self.view.addSubview(myCollectionView)
    }
    
    //TableView
    func setUpTableView(){
        myTableView = UITableView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 166))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokeIndex = indexPath.row
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestVC = segue.destination as! ProfileViewController
        profileVC = DestVC
        DestVC.pokemon = filteredArray[pokeIndex!]
        DestVC.searchDelegate = self.searchDelegate
    }
    
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
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //SegmentedControl
    func setUpSegmentControl() {
        let items = ["Table", "Grid"]
        let segControl = UISegmentedControl(items: items)
        segControl.selectedSegmentIndex = 0
        
        segControl.frame = CGRect(x: 20, y:10, width: view.frame.width - 40, height: 40)
        
        segControl.layer.cornerRadius = 5.0
        segControl.layer.borderColor = UIColor.black.cgColor
        segControl.layer.borderWidth = 1
        segControl.backgroundColor = UIColor.white
        segControl.tintColor = UIColor.red
        
        segControl.addTarget(self, action: #selector(changeViews(sender:)), for: .valueChanged)
        
        self.view.addSubview(segControl)
    }
    
    @objc func changeViews(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            myTableView.isHidden = true
            myCollectionView.isHidden = false
            
        default:
            myTableView.isHidden = false
            myCollectionView.isHidden = true
        }
    }
}

extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "button", for: indexPath) as! PokeButtonCell
        cell.awakeFromNib()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! PokeButtonCell
        
        cell.pokeDelegate = self
        
        cell.setButton(num: indexPath.item + 1)
        if let url = URL(string: filteredArray[indexPath.row].imageUrl) {
            if let data = try? Data(contentsOf: url)
            {
                let image: UIImage = UIImage(data: data)!
                cell.pokeButton.setImage(image, for: .normal)
            } else {
                cell.pokeButton.setImage(UIImage(named: "search"), for: .normal)
            }
        }
        cell.pokeButton.setTitle(filteredArray[indexPath.row].name, for: .normal)
        if let temp = cell.pokeButton.imageView?.image?.size.width {
            cell.pokeButton.titleEdgeInsets = UIEdgeInsets(top: cell.contentView.frame.height - 27, left: -temp, bottom: 10, right: 0)
        }    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 3) - 8
        let height = width
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("worked!!")
        pokeIndex = indexPath.row
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
}


extension ResultsViewController: pokeButtonCellDelegate {
    func segue(num: Int) {
        print("segueing")
        pokeIndex = num - 1
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
}
