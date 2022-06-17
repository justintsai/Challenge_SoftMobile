//
//  MainCollectionViewController.swift
//  Challenge_SoftMobile
//
//  Created by 蔡念澄 on 2022/6/16.
//

import UIKit

private let reuseIdentifier = "CollectionViewCell"

class MainCollectionViewController: UICollectionViewController {
    
    var allData: [DataModel] = []
    var titleIsHidden: Bool = UIDevice.current.orientation.isLandscape ? true : false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "挑戰"
//        navigationItem.backButtonTitle = ""
//        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "xmark")
        
        DataManager.shared.fetchJSONData { result in
            switch result {
            case .success(let allData):
                self.allData = allData
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        configureCellSize()
    }

    func configureCellSize() {
        let width = UIScreen.main.bounds.width
//        let height = collectionView.bounds.height
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: width - 140)
        flowLayout?.estimatedItemSize = .zero
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.data = allData[indexPath.row]
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let url = allData[indexPath.item].imgURL
        DataManager.shared.fetchImage(url: url) { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
            self.allData[indexPath.item].img = image
        }
        cell.imageView.image = allData[indexPath.item].img
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 20
        cell.imageView.clipsToBounds = true
        cell.titleLabel.text = allData[indexPath.item].title
        cell.titleLabel.isHidden = titleIsHidden
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { _ in
                print("collectionView.frame: \(self.collectionView.frame)")
                self.configureCellSize()
            },
            completion: nil
        )
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if UIDevice.current.orientation.isLandscape {
            collectionView.allowsSelection = false
            titleIsHidden = true
        } else {
            collectionView.allowsSelection = true
            titleIsHidden = false
        }
        
        flowLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
}
