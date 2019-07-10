//
//  ViewController.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    fileprivate let segmentedControl = UISegmentedControl(items: ["Music","Book"])
    fileprivate let tableview = UITableView(frame: .zero)
    
    private var topPadding:CGFloat = 0
    private var bottomPadding:CGFloat = 0
    
    private let ituneService = ITunesService()
    
    fileprivate var books:[Item] = []
    fileprivate var musics:[Item] = []
    
    fileprivate var imageCache:[String:Data] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        addSegmentedControl()
        addTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControlValueChanged()
    }
    
    private func addTableView(){
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MainTableViewCell.self, forCellReuseIdentifier: String(describing:MainTableViewCell.self))
    }
    
    private func addSegmentedControl(){
        view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
        view.backgroundColor = UIColor.white
    }
    
    @objc private func segmentedControlValueChanged(){
        imageCache.removeAll()
        if segmentedControl.selectedSegmentIndex == 0{
            ituneService.fetchMusic(success: {[weak self] (items) in
                guard let strongself = self else{ return}
                
                DispatchQueue.main.async {
                    strongself.musics = items
                    strongself.tableview.reloadData()
                }
                
            }) {[weak self] (errorString) in
                guard let strongself = self else{ return}
                DispatchQueue.main.async {
                    strongself.showErrorAlert(error: errorString)
                }
            }
        }
        else{
            ituneService.fetchBooks(success: {[weak self] (items) in
                guard let strongself = self else{ return}
                
                DispatchQueue.main.async {
                    strongself.books = items
                    strongself.tableview.reloadData()
                }
                
            }) {[weak self] (errorString) in
                guard let strongself = self else{ return}
                DispatchQueue.main.async {
                    strongself.showErrorAlert(error: errorString)
                }
            }
        }
    }
    
    private func showErrorAlert(error:String){
        let alertController = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getSafePadding()
        setupSegmentControlPosition()
        setupTableView()
    }
    
    private func setupTableView(){
        let spacing:CGFloat = 10
        let y =  segmentedControl.frame.origin.y + segmentedControl.frame.height + spacing
        
        tableview.frame = CGRect(x: spacing, y: y, width: view.frame.width - spacing*2, height: view.frame.height - y - spacing*2)
        tableview.separatorColor = UIColor.clear
    }
    
    private func setupSegmentControlPosition(){
        let spacing:CGFloat = 10
        segmentedControl.frame = CGRect(x: spacing, y: topPadding + spacing, width: view.frame.width - spacing*2, height: 30)
    }
    
    private func getSafePadding(){
        let window = UIApplication.shared.keyWindow
        guard let topPadding = window?.safeAreaInsets.top else{return}
        guard let bottomPadding = window?.safeAreaInsets.bottom else{return}
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
    }
}

extension MainViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControl.selectedSegmentIndex == 0){
            return musics.count
        }
        else{
            return books.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:MainTableViewCell.self)) as? MainTableViewCell else{
            return UITableViewCell()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MainTableViewCell{
            var item:Item!
            if(segmentedControl.selectedSegmentIndex == 0){
                item = musics[indexPath.row]
            }
            else{
                item = books[indexPath.row]
            }
            cell.nameLabel.text = item.name
            
            if(imageCache[item.imageUrl] != nil){
                cell.imageview.image = UIImage( data:imageCache[item.imageUrl]!)
            }
            else{
                guard let url = URL(string: item.imageUrl) else{
                    return
                }
                
                DispatchQueue.global().async {
                    if let data = try? Data( contentsOf:url){
                        DispatchQueue.main.async {
                            cell.imageview.image = UIImage( data:data)
                            self.imageCache[item.imageUrl] = data
                        }
                    }
                }
            }
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/3
    }
    
    
}

