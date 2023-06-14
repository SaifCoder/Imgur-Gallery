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
    var imageService: ImageService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInitialView()
    }


    func setupInitialView() {
        imageService = ImageService(delegate: self)
        navigationItem.titleView = searchBarView
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        self.collectionView.setEmptyMessage("Search image and we will show the results")
    }

    @IBAction func toggleButtonAction(_ sender: Any) {
        if isListView {
            isListView = false
            toggleViewButton.image = UIImage(imageLiteralResourceName: "grid")
        } else {
            isListView = true
            toggleViewButton.image = UIImage(imageLiteralResourceName: "list")
        }
        collectionView.reloadData()
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
        if isListView {
            return CGSize(width: (collectionView.frame.size.width - Constants.collectionViewPadding), height: Constants.collectionViewCellHeight)
        } else {
            return CGSize(width: (collectionView.frame.size.width/2 - Constants.collectionViewPadding), height: Constants.collectionViewCellHeight)
        }

    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.imageData?.removeAll()
        self.collectionView.reloadData()
        self.collectionView.setEmptyMessage("Searching..")
        searchBar.resignFirstResponder()
        guard let text = self.searchBarView.text else { return }
        imageService?.getTopImagesOfWeek(text: text)
    }
}

extension HomeViewController: ImageServiceDelegate {
    func getTopImagesOfWeek(data: [ImageData]?) {
        DispatchQueue.main.async {
            self.imageData = data
            self.collectionView.reloadData()
            self.collectionView.restore()
        }
    }

    func didFailToFetchResult() {
        DispatchQueue.main.async {
            self.imageData?.removeAll()
            self.collectionView.reloadData()
            self.collectionView.setEmptyMessage("No results found!")
        }
    }
}


