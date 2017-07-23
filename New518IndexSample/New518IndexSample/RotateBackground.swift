//
//  AutoRotateBackground.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/16.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

protocol RotateBackgroundLayout {
    var scrollView:UIScrollView {get set}
    var backgroundImages:[String] {get set}
    var titles:[String] {get set}
    var descriptions:[String] {get set}
    var pageControl:UIPageControl {get set}
    
    func layoutForSubviews(superView:UIView)
}

struct RotateBackground:RotateBackgroundLayout {
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var backgroundImages: [String]
    var titles: [String]
    var descriptions: [String]
    
    init() {
        self.scrollView = UIScrollView()
        self.pageControl = UIPageControl()
        self.backgroundImages = []
        self.titles = []
        self.descriptions = []
    }
    
    func layoutForSubviews(superView:UIView) {
        let screenSize:CGSize = UIScreen.main.bounds.size
        //設置尺寸 也就是可見視圖範圍
        scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.delegate = self
        //實際視圖範圍 看幾張背景圖
        scrollView.contentSize = CGSize(width:screenSize.width*CGFloat(backgroundImages.count), height:screenSize.height)
        superView.addSubview(scrollView)
        
        for i in 0..<backgroundImages.count {
            let imageView = UIImageView(frame: CGRect(x:screenSize.width*CGFloat(i), y:0, width:screenSize.width, height:screenSize.height))
            imageView.image = UIImage(named: backgroundImages[i])
            scrollView.addSubview(imageView)
            
            let titleLabel = UILabel(frame: CGRect(x:screenSize.width*CGFloat(i)+20, y:screenSize.height*0.2, width:screenSize.width-40, height:50))
            titleLabel.text = titles[i]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
            titleLabel.textColor = .black
            scrollView.addSubview(titleLabel)
            
            let descLabel = UILabel(frame: CGRect(x:screenSize.width*CGFloat(i)+20, y:titleLabel.frame.origin.y+titleLabel.frame.size.height, width:screenSize.width-40, height:60))
            descLabel.text = descriptions[i]
            descLabel.textAlignment = .center
            descLabel.font = UIFont(name: "Helvetica", size: 16)
            descLabel.textColor = .black
            descLabel.numberOfLines = 0
            scrollView.addSubview(descLabel)
        }
        
        //UIPageControl
        pageControl.frame = CGRect(x:0, y:0, width:screenSize.width*0.85, height:50)
        pageControl.center = CGPoint(x:screenSize.width*0.5, y:screenSize.height*0.2-30)
        pageControl.numberOfPages = backgroundImages.count
        pageControl.currentPage = 0
        //目前所在頁數的點點顏色
        pageControl.currentPageIndicatorTintColor = UIColor.black
        //其餘頁數的點點顏色
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        //加入到基底的視圖中 (不是加到 UIScrollVie
        superView.addSubview(pageControl)
        
        let rotate:RotateController = RotateController()
        rotate.superView = scrollView
        rotate.pageControl = pageControl
        rotate.backgroundImages = backgroundImages
        rotate.start()
    }
    
    /*
    mutating func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
        
        autoRotateTimer.invalidate()
        autoRotateTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextImage), userInfo: nil, repeats: true)
    }
 
    
    
  */
}
