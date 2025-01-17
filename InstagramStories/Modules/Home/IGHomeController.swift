//
//  IGHomeController.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/6/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import UIKit
import EVStories

fileprivate let isClearCacheEnabled = true
internal var isDeleteSnapEnabled = true

final class IGHomeController: UIViewController {
    
    //MARK: - iVars
//    private var _view: IGHomeView{return view as! IGHomeView}
    private var viewModel: IGHomeViewModel = IGHomeViewModel()
    
    //MARK: - Overridden functions
    override func loadView() {
        super.loadView()
        DispatchQueue.main.async {
            if let stories = self.viewModel.getStories(), let stories_copy = try? stories.copy().stories {
                let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex:  0, handPickedSnapIndex: 0)
                self.present(storyPreviewScene, animated: true, completion: nil)
            }
        }
//        view = IGHomeView(frame: UIScreen.main.bounds)
//        _view.collectionView.delegate = self
//        _view.collectionView.dataSource = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        automaticallyAdjustsScrollViewInsets = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var navigationItem: UINavigationItem {
        let navigationItem = UINavigationItem()
        navigationItem.titleView = UIImageView(image: UIImage(named: "icInstaLogo"))
        if isClearCacheEnabled {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear Cache", style: .done, target: self, action: #selector(clearImageCache))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 203.0/255, green: 69.0/255, blue: 168.0/255, alpha: 1.0)
        }
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 203.0/255, green: 69.0/255, blue: 168.0/255, alpha: 1.0)
        return navigationItem
    }
    
    //MARK: - Private functions
    @objc private func clearImageCache() {
        IGCache.shared.removeAllObjects()
        IGStories.removeAllVideoFilesFromCache()
        showAlert(withMsg: "Images & Videos are deleted from cache")
    }
    
    private func showAlert(withMsg: String) {
        let alertController = UIAlertController(title: withMsg, message: nil, preferredStyle: .alert)
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5){
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

//MARK: - Extension|UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension IGHomeController: UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGStoryListCell.reuseIdentifier, for: indexPath) as? IGStoryListCell else { fatalError() }
            let story = viewModel.cellForItemAt(indexPath: indexPath)
            cell.story = story
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isDeleteSnapEnabled = false
        DispatchQueue.main.async {
            if let stories = self.viewModel.getStories(), let stories_copy = try? stories.copy().stories {
                let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex:  indexPath.row, handPickedSnapIndex: 0)
                self.present(storyPreviewScene, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row == 0 ? CGSize(width: 100, height: 100) : CGSize(width: 80, height: 100)
    }
}
