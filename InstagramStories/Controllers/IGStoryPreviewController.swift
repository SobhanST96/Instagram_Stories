//
//  IGStoryPreviewController.swift
//  InstagramStories
//
//  Created by Srikanth Vellore on 06/09/17.
//  Copyright © 2017 Dash. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

struct StoryConstants {
    static let snapTime:Double = 1.0
}

class IGStoryPreviewController: UIViewController {

    public var stories:IGStories?
    public var storyIndex:Int = 0
    private var snapTimer:Timer?
    
    override var prefersStatusBarHidden: Bool { return true }
    var direction: UICollectionViewScrollDirection = .horizontal
    var animator: (LayoutAttributesAnimator, Bool, Int, Int) = (CubeAttributesAnimator(), true, 1, 1)

    @IBOutlet var dismissGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var collectionview: UICollectionView! {
        didSet {
            collectionview.delegate = self
            collectionview.dataSource = self
            let storyNib = UINib.init(nibName: IGStoryPreviewCell.reuseIdentifier(), bundle: nil)
            collectionview.register(storyNib, forCellWithReuseIdentifier: IGStoryPreviewCell.reuseIdentifier())
            collectionview?.isPagingEnabled = true

            if let layout = collectionview?.collectionViewLayout as? AnimatedCollectionViewLayout {
                layout.scrollDirection = direction
                layout.animator = animator.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Story"
        self.automaticallyAdjustsScrollViewInsets = false
        dismissGesture.direction = direction == .horizontal ? .down : .left
        
//        snapTimer = Timer.scheduledTimer(timeInterval: StoryConstants.snapTime, target: self, selector: #selector(IGStoryPreviewController.didMoveNextSnap), userInfo: nil, repeats: true)
    }
    
    //MARK: - Selectors
    func didMoveNextSnap(){
        guard let count = stories?.count else {
            return
        }
        storyIndex = storyIndex+1
        if storyIndex == count-1 {
            snapTimer?.invalidate()
            return
        }
        if storyIndex<count{
            let indexPath = IndexPath.init(row: storyIndex, section: 0)
            collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    //MARK: -
    deinit {
        snapTimer?.invalidate()
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension IGStoryPreviewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Start with handpicked story from Home.
        return (stories?.count)!-storyIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGStoryPreviewCell.reuseIdentifier(), for: indexPath) as! IGStoryPreviewCell
        cell.storyHeaderView?.delegate = self
        //Start with handpicked story from Home.
        let story = stories?.stories?[indexPath.row+storyIndex]
        cell.storyHeaderView?.story = story
        cell.storyHeaderView?.generateSnappers()
        cell.storyHeaderView?.snaperImageView.RK_setImage(urlString: story?.user?.picture ?? "")
        let snap = story?.snaps?.first
        cell.imageview.RK_setImage(urlString: snap?.mediaURL ?? "",imageStyle: .squared)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}

extension IGStoryPreviewController:StoryPreviewHeaderTapper {
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}