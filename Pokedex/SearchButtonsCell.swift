//
//  SearchButtonsCell.swift
//  Pokedex
//
//  Created by Aditya Yadav on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

import UIKit

protocol searchButtonCellDelegate {
    func randomSegue()
    func checkSearchButton()
}

class SearchButtonsCell: UICollectionViewCell {
    
    var button: UIButton!
    var IndexPathNum: Int?
    
    var searchCellDelegate: searchButtonCellDelegate?
    
    let numToType = [1 : "Bug", 2 : "Dark", 3 : "Dragon", 4 : "Electric", 5 : "Fairy", 6 : "Fighting", 7 : "Fire", 8 : "Flying", 9 : "Ghost", 10 : "Grass", 11 : "Ground", 12 : "Ice", 13 : "Normal", 14 : "Poison", 15 : "Psychic", 16 : "Rock", 17 : "Steel", 18 : "Water", 19 : "RANDOM"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button = UIButton(frame: contentView.frame)
        button.layer.cornerRadius = 20
        contentView.addSubview(button)
        
    }
    
    func setButton(num: Int) {
        let strName = "\(num)" 
        let image = UIImage(named: strName)
        self.button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 34, right: 24)
        button.setTitle(numToType[num]?.uppercased(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: 13)
        button.titleEdgeInsets = UIEdgeInsets(top: contentView.frame.height - 27, left: -(button.imageView?.image?.size.width)!, bottom: 10, right: 0)
        //let bgColor = UIColor(red: 24/255, green: 45/255, blue: 64/255, alpha: 1.0)
        //button.backgroundColor = bgColor
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        IndexPathNum = num
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        if IndexPathNum == 19 {
            searchCellDelegate?.randomSegue()
        } else {
            if typeFilters.contains(numToType[IndexPathNum!]!) {
                typeFilters.remove(at: typeFilters.index(of: numToType[IndexPathNum!]!)!)
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            } else {
                typeFilters.append(numToType[IndexPathNum!]!)
                button.backgroundColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
            }
            searchCellDelegate?.checkSearchButton()
        }
        print(typeFilters)
    }
    
    
    
    
    
    
}
