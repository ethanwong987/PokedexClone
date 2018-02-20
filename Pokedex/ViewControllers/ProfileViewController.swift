//
//  ProfileViewController.swift
//  Pokedex
//
//  Created by Ethan Wong on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

//
//  ViewController.swift
//  Pokedex
//
//  Created by SAMEER SURESH on 9/25/16.
//  Copyright © 2016 trainingprogram. All rights reserved.
//

import UIKit
import SafariServices

var favoritePokemon = [String]()

class ProfileViewController: UIViewController, UIWebViewDelegate, SFSafariViewControllerDelegate{
    //Pokemon Display Information
    var pokemon : Pokemon!
    var pokeImage : UIImageView!
    var typeImage : UIImageView!
    var pokeName : UILabel!
    var pokeNum : UILabel!
    var pokeHP : UILabel!
    var pokeAtt : UILabel!
    var pokeSpAtt : UILabel!
    var pokeDef : UILabel!
    var pokeSpDef : UILabel!
    var pokeSpeed : UILabel!
    var pokeTotal : UILabel!
    var pokeType1 : UILabel!
    var pokeType2 : UILabel!
    var pokeSpecies : UILabel!
    
    var searchDelegate: SearchControllerDelegate?
    
    //UI Set Up
    var divider : UILabel!
    var botHalf : UILabel!
    var pokeURL : String!
    var addFavButton : UIButton!
    var toWebButton : UIButton!
    
    //Dynamic Color Selection
    var navColor : UIColor!
    var typeColor1: UIColor!
    var typeColor2: UIColor!
    var navBarDynamicColor: UIColor!
    
    
    
    //set typecolor1 to corresp color if pokemon.types[0] == colors[pokemon.types[0]], if pokemon.types.count > 1 then do same for pokemon.types[1], then in setupTypeLabel use typeColor1 and 2
    //
    let colors = ["Fire": UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0),
                  "Water": UIColor(red:0.00, green:0.65, blue:0.93, alpha:1.0),
                  "Flying": UIColor(red:0.35, green:0.62, blue:0.85, alpha:1.0),
                  "Bug": UIColor(red:0.76, green:0.79, blue:0.39, alpha:1.0),
                  "Dark": UIColor(red:0.44, green:0.36, blue:0.00, alpha:1.0),
                  "Grass": UIColor(red:0.16, green:0.72, blue:0.21, alpha:1.0),
                  "Ground": UIColor(red:0.85, green:0.78, blue:0.32, alpha:1.0),
                  "Rock": UIColor(red:0.70, green:0.66, blue:0.38, alpha:1.0),
                  "Ghost": UIColor(red:0.48, green:0.55, blue:0.87, alpha:1.0),
                  "Ice": UIColor(red:0.54, green:0.95, blue:1.00, alpha:1.0),
                  "Electric": UIColor(red:1.00, green:0.87, blue:0.00, alpha:1.0),
                  "Fairy": UIColor(red:0.98, green:0.40, blue:1.00, alpha:1.0),
                  "Poison": UIColor(red:0.72, green:0.16, blue:0.66, alpha:1.0),
                  "Fighting": UIColor(red:0.59, green:0.46, blue:0.00, alpha:1.0),
                  "Normal": UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0),
                  "Dragon": UIColor(red:0.53, green:0.42, blue:0.82, alpha:1.0),
                  "Steel": UIColor(red:0.79, green:0.79, blue:0.79, alpha:1.0),
                  "Psychic": UIColor(red:0.90, green:0.20, blue:0.83, alpha:1.0),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createPokeImage()
        createPokeBioView()
        createFavButton()
        createWebButton()
        createPokeStatsView()
        searchDelegate?.setNavBarTitle(name: pokemon.name!)
        searchDelegate?.setUpProfileBack()
    }
    
    @objc func setUpWebView(){
        
        let replacedPokeName = pokemon.name.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com/search?q=" + replacedPokeName
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 21)]
        view.backgroundColor = .white
        
        //Design
        divider = UILabel(frame: CGRect(x: 0, y: vfh * 0.435, width:vfw, height: 50))
        divider.backgroundColor = colors[pokemon.types[0]]!
        divider.text = "Pokedex Data"
        divider.font = UIFont(name: "Copperplate-light", size: 20)
        divider.textColor = .white
        divider.textAlignment = .center
        view.addSubview(divider)
        
        botHalf = UILabel(frame: CGRect(x: 0, y: vfh/2, width: view.frame.width, height: view.frame.height/2))
        botHalf.backgroundColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        view.addSubview(botHalf)
        
        let tabBar = UILabel(frame: CGRect(x: 0, y: view.frame.height - 40, width: view.frame.width, height: 60))
        tabBar.backgroundColor = .red
        view.addSubview(tabBar)
        
    }
    
    func createFavButton(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        addFavButton = UIButton(frame: CGRect(x: (20 / 3), y: vfh * 0.33, width: vfw / 2 - 10, height: 40))
        addFavButton.setTitle("Add to Favorites", for: .normal)
        addFavButton.layer.cornerRadius = 10
        //append pokemon to favorites array if pressed.
        addFavButton.backgroundColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        addFavButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        view.addSubview(addFavButton)
    }
    
    func addToFavorites() {
        let alert = UIAlertController(title: "Pokemon Added", message: pokemon.name + " has been saved to favorites",         preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        favoritePokemon.append(self.pokemon.name)
        print(self.pokemon.species)
        let defaults = UserDefaults.standard
        defaults.set(favoritePokemon, forKey: "savedPokemon")
    }
    
    func createWebButton(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        toWebButton = UIButton(frame: CGRect(x: (2 * (20 / 3)) + (vfw / 2 - 10), y: vfh * 0.33, width: vfw / 2 - 10, height: 40))
        toWebButton.setTitle("Search on Web", for: .normal)
        toWebButton.layer.cornerRadius = 10
        toWebButton.backgroundColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        toWebButton.addTarget(self, action: #selector(setUpWebView), for: .touchUpInside)
        view.addSubview(toWebButton)
    }
    
    func createPokeImage() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        pokeImage = UIImageView(frame: CGRect(x: vfw * 0.05, y: vfh * 0.06, width: 130, height: 130))
        
        //add image url
        let url = URL(string:pokemon.imageUrl)
        if url != nil {
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                self.pokeImage.image = image
            }
        } else {
            let image: UIImage = UIImage(named: "search")!
            self.pokeImage.image = image
        }
        
        pokeImage.contentMode = .scaleAspectFit
        view.addSubview(pokeImage)
    }
    
    
    func createPokeBioView() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        //Number
        let pokeText : NSString = "No. \(pokemon.number!)" as NSString
        let range = (pokeText).range(of: "No.")
        let attribute = NSMutableAttributedString.init(string: pokeText as String)
        attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
        pokeNum = UILabel(frame: CGRect(x: vfw * 0.45, y: 0, width: 100, height: 100))
        pokeNum.attributedText = attribute
        view.addSubview(pokeNum)
        
        //Species
        let pokeSpeciesText : NSString = "Species: \n \(pokemon.species!)" as NSString
        let range1 = (pokeSpeciesText).range(of: "Species:")
        let attribute1 = NSMutableAttributedString.init(string: pokeSpeciesText as String)
        attribute1.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range1)
        pokeSpecies = UILabel(frame: CGRect(x: vfw * 0.45, y: vfh * 0.07, width: 200, height: 100))
        pokeSpecies.numberOfLines = 0
        pokeSpecies.adjustsFontSizeToFitWidth = true
        pokeSpecies.attributedText = attribute1
        view.addSubview(pokeSpecies)
        
        //TypeLabel
        let type = UILabel(frame: CGRect(x: vfw * 0.45, y: vfh * 0.19, width: 80, height: 30))
        type.text = "Type:"
        type.textColor = .red
        pokeType1 = UILabel(frame: CGRect(x: vfw * 0.45, y: vfh * 0.24, width: 95, height: 30))
        pokeType1.text = String(pokemon.types[0])
        pokeType1.textColor = .white
        pokeType1.textAlignment = .center
        pokeType1.layer.cornerRadius = 10
        pokeType1.layer.borderColor = UIColor.red.cgColor
        pokeType1.layer.backgroundColor = colors[pokemon.types[0]]?.cgColor
        
        if (pokemon.types.count > 1){
            let flyingTypeColor = UIColor(red:0.26, green:0.83, blue:0.96, alpha:1.0)
            pokeType2 = UILabel(frame: CGRect(x: vfw * 0.73, y: vfh * 0.24, width: 95, height: 30))
            pokeType2.text = String(pokemon.types[1])
            pokeType2.textColor = .white
            pokeType2.textAlignment = .center
            pokeType2.layer.cornerRadius = 10
            pokeType2.layer.borderColor = flyingTypeColor.cgColor
            pokeType2.layer.backgroundColor = colors[pokemon.types[1]]?.cgColor
            view.addSubview(pokeType2)
        }
        view.addSubview(type)
        view.addSubview(pokeType1)
    }
    
    func labelDefaults(_ label : UILabel){
        label.font = UIFont(name:"Copperplate-light", size: 23)
        label.textColor = .white
        view.addSubview(label)
    }
    
    func createPokeStatsView(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        //HP
        pokeHP = UILabel(frame: CGRect(x: vfw * 0.08, y: vfh * 0.58, width: 100, height: 30))
        pokeHP.text = "HP: \(pokemon.health!)"
        labelDefaults(pokeHP)
        
        //Att
        pokeAtt = UILabel(frame: CGRect(x: vfw * 0.08, y: vfh * 0.65, width: 100, height: 30))
        pokeAtt.text = "Atk: \(pokemon.attack!)"
        labelDefaults(pokeAtt)
        
        //Def
        pokeDef = UILabel(frame: CGRect(x: vfw * 0.08, y: vfh * 0.73, width: 100, height: 30))
        pokeDef.text = "Def: \(pokemon.defense!)"
        labelDefaults(pokeDef)
        
        //Sp.Att
        pokeSpAtt = UILabel(frame: CGRect(x: vfw * 0.5, y: vfh * 0.58, width: 150, height: 30))
        pokeSpAtt.text = "Sp.Atk: \(pokemon.specialAttack!)"
        labelDefaults(pokeSpAtt)
        
        //Sp.Def
        pokeSpDef = UILabel(frame: CGRect(x: vfw * 0.5, y: vfh * 0.65, width: 140, height: 30))
        pokeSpDef.text = "Sp.Def: \(pokemon.specialDefense!)"
        labelDefaults(pokeSpDef)
        
        //Speed
        pokeSpeed = UILabel(frame: CGRect(x: vfw * 0.5, y: vfh * 0.73, width: 140, height: 30))
        pokeSpeed.text = "Speed: \(pokemon.speed!)"
        labelDefaults(pokeSpeed)
        
        //Total
        pokeTotal = UILabel(frame: CGRect(x: vfw * 0.5, y: vfh * 0.83, width: 150, height: 30))
        pokeTotal.text = "Total: \(pokemon.total!)"
        labelDefaults(pokeTotal)
    }
    
}


//
//  ProfileViewController.swift
//  Pokedex
//
//  Created by Ethan Wong on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//



//
//  Created by Ethan Wong on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//



