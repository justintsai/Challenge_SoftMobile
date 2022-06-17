//
//  ViewController.swift
//  Challenge_SoftMobile
//
//  Created by 蔡念澄 on 2022/6/16.
//

import UIKit

class DetailViewController: UIViewController {
    
    var data: DataModel?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "挑戰"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(popVC(sender:)))
//        let image = UIImage(systemName: "xmark")
//        navigationController?.navigationBar.backIndicatorImage = image
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image

        if let data = data {
            imageView.image = data.img
            imageView.layer.cornerRadius = imageView.frame.size.width / 20
            titleLabel.text = data.title
            contentLabel.text = data.content
        }
        
    }
    
    @objc func popVC(sender: UIBarButtonItem) {
       navigationController?.popViewController(animated: true)
    }

}

