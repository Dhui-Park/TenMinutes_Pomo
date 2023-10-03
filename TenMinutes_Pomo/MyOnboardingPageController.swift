//
//  MyOnboardingPageController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/03.
//

import Foundation
import UIKit

class MyOnboardingPageController: UIPageViewController {
    
    var numbers: [Int] = [0, 1, 2, 3]
    
    var pageVCList: [BreakTimeWordVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        pageVCList = numbers.map { BreakTimeWordVC.getInstance(index: $0) }
        
        setViewControllers([pageVCList[0]], direction: .forward, animated: true, completion: { value in
            print(#fileID, #function, #line, "- value: \(value)")
        })
        
        self.dataSource = self
    }
    
}

extension MyOnboardingPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentPageIndex = pageVCList.firstIndex(of: viewController as! BreakTimeWordVC) ?? 0
        
        if currentPageIndex == 0 { return pageVCList[pageVCList.count - 1] }
        
        return pageVCList[currentPageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentPageIndex = pageVCList.firstIndex(of: viewController as! BreakTimeWordVC) ?? 0
        
        if currentPageIndex == pageVCList.count - 1 { return pageVCList[0] }
        
        return pageVCList[currentPageIndex + 1]
    }
}
