//
//  ValleyGramViewController.swift
//  ValleyGram
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 01/12/16.
//  Copyright © 2016 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

import UIKit

class ValleyGramViewController: UICollectionViewController {

    let cellSize = UIScreen.main.bounds.width/2 - 10
    var imagesFromService = [ValleyGramImage]()
    var imagesDisplay = [ValleyGramImage]()
    let imageCountToLoad = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Valley Gram"
        
        ValleyGramInteractorAPI.fetchUnsplashImages({ (images) in
            self.imagesFromService.removeAll()
            self.imagesFromService.append(contentsOf: images)
            self.imagesDisplay.append(contentsOf: self.imagesFromService[0..<self.imageCountToLoad])
            self.reloadCollection()
        }) {(errorMessage) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCollection() -> Void {
        self.collectionView?.reloadData()
    }

}


// MARK: - TableViewDataSource

extension ValleyGramViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ValleyGramImageCollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _ = cell.setImage(imagesDisplay[(indexPath as NSIndexPath).row].imageUrl(CGSize(width: cellSize, height: cellSize)), imageViewName: "pictureImageView", collectionView: collectionView, indexPath: indexPath, completion: { (image) in
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // MARK: - Scrool view delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.getScrollAndReloadMoreData(scrollView: scrollView)
    }
    
    func getScrollAndReloadMoreData(scrollView: UIScrollView) -> Void {
        let point:CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if(point.y < 0) {
            let bottomEdge:CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
            if(bottomEdge >= scrollView.contentSize.height-50) {
                if(self.imagesFromService.count >= 10) {
                    self.imagesDisplay.append(contentsOf: self.imagesFromService[self.imagesDisplay.count..<self.imagesDisplay.count+self.imageCountToLoad])
                    self.reloadCollection()
                }
            }
        }
    }
    
}
