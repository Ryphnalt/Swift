//
//  RotateControl.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/16.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

@objc protocol RotateControl {
    var autoRotateTimer:Timer {get set}
    func start()
    func restart()
    func moveToNextImage()
}

class RotateController:RotateControl {
    var autoRotateTimer:Timer = Timer()
    var superView:UIScrollView = UIScrollView()
    var pageControl:UIPageControl = UIPageControl()
    var backgroundImages: [String] = []
    
    func start() {
        autoRotateTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextImage), userInfo: nil, repeats: true)
    }
    
    func restart() {
        autoRotateTimer.invalidate()
        start()
    }
    
    func moveToNextImage() {
        let pageWidth:CGFloat = superView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(backgroundImages.count)
        let contentOffset:CGFloat = superView.contentOffset.x
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        let page = Int(slideToX / superView.frame.size.width)
        superView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:superView.frame.height), animated: true)
        pageControl.currentPage = page
    }
}
