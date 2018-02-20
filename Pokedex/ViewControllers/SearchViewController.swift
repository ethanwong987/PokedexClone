//
//  SearchViewController.swift
//  Pokedex
//
//  Created by Aditya Yadav on 2/13/18.
//  Copyright © 2018 trainingprogram. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

var typeFilters = [String]()

protocol SearchControllerDelegate {
    func changeNavBarColor(color: UIColor)
    func hideNavBar()
    func setNavBarTitle(name: String)
    func setUpResultBack()
    func setUpProfileBack()
    func removeNavBarTitle()
    func segueBackResult()
}

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var delegate: SearchControllerDelegate?
    var collectionView: UICollectionView!
    
    var minAttack: SkyFloatingLabelTextField!
    var minDefense: SkyFloatingLabelTextField!
    var minHealth: SkyFloatingLabelTextField!
    
    var scrollView: UIScrollView!
    
    var searchBar: UISearchBar!
    
    var random = false
    
    var searchButton: UIButton!
    var textFieldsInput = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate?.changeNavBarColor(color: UIColor.red)
        setUpScrollView()
        setUpCollectionView()
        setUpSearchButton()
        setUpTextInput()
        searchButton.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
        
    }

    
    func setUpSearchButton() {
        let reddishColor : UIColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
        searchButton = UIButton(frame: CGRect(x: view.frame.width / 4, y: view.frame.height - (view.frame.height / 4) - 50, width: view.frame.width / 2, height: 50))
        searchButton.backgroundColor = reddishColor
        searchButton.setTitle("Search!", for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: 20)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 10
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
    }
    
    func setUpScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.2)
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.hideNavBar()
        setUpNavBar()
    }
    
    func setUpTextInput() {
        
        let reddishColor : UIColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
        
        minAttack = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! - 20, width: view.frame.width - 40, height: 30))
        minAttack.delegate = self
        minAttack.selectedTitleColor = reddishColor
        minAttack.selectedLineColor = reddishColor
        
        minDefense = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! - 20 + 35, width:
            view.frame.width - 40, height: 30))
        minDefense.delegate = self
        minDefense.selectedTitleColor = reddishColor
        minDefense.selectedLineColor = reddishColor
        
        minHealth = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! - 20 + 70, width: view.frame.width - 40, height: 30))
        minHealth.selectedTitleColor = reddishColor
        minHealth.selectedLineColor = reddishColor
        minHealth.delegate = self
        
        minAttack.placeholder = " Minimum Attack Points"
        minDefense.placeholder = " Minimum Defense Points"
        minHealth.placeholder = " Minimum Health Points"
        
        scrollView.addSubview(minAttack)
        scrollView.addSubview(minDefense)
        scrollView.addSubview(minHealth)
    }
    
    func setUpNavBar() {
        
        self.navigationController?.navigationBar.isHidden = true
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let leftBarButtonIcon = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(searchIconPressed))
        self.tabBarController?.navigationItem.leftBarButtonItem = leftBarButtonIcon
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = .white
        
        searchBar = UISearchBar(frame: CGRect(x: -1000, y: 0, width: view.frame.width - 70, height: 20))
        searchBar.placeholder = "Search for specific pokemon"
        searchBar.delegate = self
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        searchBar.showsCancelButton = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    
        view.addGestureRecognizer(tap)
    }
        
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        
        // Perform any necessary work.  E.g., repopulating a table view
        // if the search bar performs filtering.
        self.searchDisplayController?.setActive(false, animated: true)
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar!)
    {
        performSegue(withIdentifier: "toSearch", sender: self)
    }

    
    func searchIconPressed() {
        var temp = UIBarButtonItem(customView: searchBar)
        self.tabBarController?.navigationItem.leftBarButtonItem = temp
        let image = UIImage(named: "play")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        UIView.animate(withDuration: 0.5) {
            self.searchBar.frame.origin.x = 1000
            self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .white
        
            
        
        }
    }
    
    func playPressed() {
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if !random {
            let destVC  = segue.destination as? ResultsViewController
            destVC?.searchDelegate = self.delegate
            if let temp = Int(minAttack.text!) {
                destVC?.minAttack = temp
            } else {
                destVC?.minAttack = 0
            }
            if let temp = Int(minDefense.text!) {
                destVC?.minDefense = temp
            } else {
                destVC?.minDefense = 0
            }
            if let temp = Int(minHealth.text!) {
                destVC?.minHealth = temp
            } else {
                destVC?.minHealth = 0
            }
            destVC?.searchBar = searchBar.text
        } else {
            let destVC  = segue.destination as? ResultsViewController
            destVC?.searchDelegate = self.delegate
            destVC?.random = true
        }
    }
    
    func setUpCollectionView() {
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! - 20 + 120, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        //let bgColor = UIColor(red: 18/255, green: 33/255, blue: 49/255, alpha: 1.0)
        //collectionView.backgroundColor = bgColor
        collectionView.backgroundColor = .white
        collectionView.register(SearchButtonsCell.self, forCellWithReuseIdentifier: "button")
        scrollView.addSubview(collectionView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "button", for: indexPath) as! SearchButtonsCell
        cell.awakeFromNib()
        cell.searchCellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! SearchButtonsCell
        cell.setButton(num: indexPath.item + 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 4.0) - (25 / 4)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("yo")
    //    }
    
    
}

extension SearchViewController: searchButtonCellDelegate {
    
    func checkSearchButton() {
        //        minAttack.endEditing(true)
        //        minDefense.endEditing(true)
        //        minHealth.endEditing(true)
        if (typeFilters.count == 0) {
            if textFieldsInput == false {
                searchButton.isHidden = true
            }
        } else {
            searchButton.isHidden = false
        }
    }
    
    func randomSegue() {
        random = true
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldsInput = true
        searchButton.isHidden = false
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}





