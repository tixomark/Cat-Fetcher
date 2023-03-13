//
//  NeViewController.swift
//  catFetcher
//
//  Created by tixomark on 3/6/21.
//

import UIKit

class NeViewController: UIViewController {

    let imageView = UIImageView()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        scrollView.delegate = self
    }
    
    private func configureView() {
        
        view.backgroundColor = .systemPink
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width , height: view.bounds.width)
//        navigationController?.navigationBar.isHidden = true
        
        scrollView.frame = view.bounds
        scrollView.contentSize = imageView.bounds.size
        scrollView.backgroundColor = .systemRed
        scrollView.maximumZoomScale = 2.0
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        
    }

}

extension NeViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
}
