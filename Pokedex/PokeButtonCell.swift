//
//  PokeButtonCell.swift
//  Pokedex
//
//  Created by Ethan Wong on 2/16/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

import UIKit

protocol pokeButtonCellDelegate {
    func segue(num: Int)
}

class PokeButtonCell: UICollectionViewCell {
    var pokeButton: UIButton!
    var IndexPathNum: Int?
    
    var pokeDelegate: pokeButtonCellDelegate?
    
    let numToType = [1 : "Bug", 2 : "Dark", 3 : "Dragon", 4 : "Electric", 5 : "Fairy", 6 : "Fighting", 7 : "Fire", 8 : "Flying", 9 : "Ghost", 10 : "Grass", 11 : "Ground", 12 : "Ice", 13 : "Normal", 14 : "Poison", 15 : "Pyschic", 16 : "Rock", 17 : "Steel", 18 : "Water"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pokeButton = UIButton(frame: contentView.frame)
        pokeButton.layer.cornerRadius = 20
        
        contentView.addSubview(pokeButton)
        
    }
    
    
    func setButton(num: Int) {
        //let image = UIImage(named: strName)
        //self.pokeButton.setImage(image, for: .normal)
        pokeButton.imageEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 34, right: 24)
        //pokeButton.setTitle(numToType[num]?.uppercased(), for: .normal
        //let bgColor = UIColor(red: 24/255, green: 45/255, blue: 64/255, alpha: 1.0)
        //button.backgroundColor = bgColor
        pokeButton.backgroundColor = .white
        pokeButton.layer.borderColor = UIColor.black.cgColor
        pokeButton.layer.borderWidth = 1
        IndexPathNum = num
        pokeButton.addTarget(self, action: #selector(initiateSegue), for: .touchUpInside)
        pokeButton.setTitleColor(.black, for: .normal)
        pokeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pokeButton.titleLabel?.font = UIFont(name: "Copperplate-Light ", size: 13)
    }
    
    func initiateSegue() {
        pokeDelegate?.segue(num: IndexPathNum!)
    }
    
    
    
}
