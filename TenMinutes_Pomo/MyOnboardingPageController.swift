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
    }
    
}
