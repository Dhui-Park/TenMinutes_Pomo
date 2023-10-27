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
    ///메모리에 바로 올리지 않고 선언
    var currentIndex: Int? = nil
    var pageVCList: [BreakTimeWordVC] = []
    var currentPageChanged: ((Int) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        ///map
        pageVCList = numbers.map { BreakTimeWordVC.getInstance(index: $0) }
        
        setViewControllers([pageVCList[0]], direction: .forward, animated: true, completion: { value in
            print(#fileID, #function, #line, "- value: \(value)")
        })
        
        self.dataSource = self
    }
    
    func goNext(){
        print(#fileID, #function, #line, "- ")
        
        var nextPageIndex: Int = 0
        let currentPageIndex = currentIndex ?? 0
        
        nextPageIndex = currentPageIndex + 1
        
        if nextPageIndex >= pageVCList.count {
            nextPageIndex = 0
        }
        
        
        setViewControllers([pageVCList[nextPageIndex]], direction: .forward, animated: true, completion: { [weak self] value in
            print(#fileID, #function, #line, "- value: \(value)")
            guard let self = self else { return }
            self.currentIndex = nextPageIndex
            currentPageChanged?(nextPageIndex)
        })
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
