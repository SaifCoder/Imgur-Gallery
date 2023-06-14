//
//  HomeViewController.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 14/06/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var toggleViewButton: UIBarButtonItem!
    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var isListView = false
    let apiManager = ApiManager()
    var imageData: [ImageData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.titleView = searchBarView
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        apiManager.getTopImagesOfWeek(text: "wallpaper") { data in
            DispatchQueue.main.async {
                if let result = data {
                    self.imageData = result
                    self.collectionView.reloadData()
                }
            }
        }
    }


    @IBAction func toggleButtonAction(_ sender: Any) {
        if isListView {
            isListView = false
            toggleViewButton.image = UIImage(imageLiteralResourceName: "grid")
        } else {
            isListView = true
            toggleViewButton.image = UIImage(imageLiteralResourceName: "list")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData?.count ?? 0
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.setData(data: imageData?[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.size.width/2 - 4), height: 250)
    }
}


