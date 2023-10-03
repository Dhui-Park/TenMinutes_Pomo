//
//  BreakTimeWordVC.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/03.
//

import Foundation
import UIKit

class BreakTimeWordVC: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    
    var index: Int = 0
    
    init?(coder: NSCoder, index: Int) {
        super.init(coder: coder)
        self.index = index
        print(#fileID, #function, #line, "- index: \(index)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#fileID, #function, #line, "- ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        switch self.index {
        case 0:
            self.wordLabel.text = "작은 것부터 꾸준히!"
        case 1:
            self.wordLabel.text = "처음에는 힘들어도 곧 20분, 30분 오랫동안 집중할 거에요!"
        case 2 :
            self.wordLabel.text = "휴식도 중요해요!"
        default:
            self.wordLabel.text = "뭐라 쓸 말이 없네ㅎㅎ"
        }
    }
    
}

//MARK: - Helpers
extension BreakTimeWordVC {
    class func getInstance(index: Int) -> BreakTimeWordVC {
        
        let storyboard = UIStoryboard(name: "BreakTimeWordVC", bundle: .main)
        
        let newBreakTimeWordVC = storyboard.instantiateInitialViewController(creator: { nscoder in
            return BreakTimeWordVC(coder: nscoder, index: index)
        })!
        
        return newBreakTimeWordVC
    }
}
