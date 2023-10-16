//
//  BreakTimeViewController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/03.
//

import Foundation
import UIKit

class BreakTimeViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var timer = Timer()
    var time: Int = 10
    
    var embededMyOnboardingPageVC: MyOnboardingPageController? {
        return children.first(where: { $0 is MyOnboardingPageController }) as? MyOnboardingPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        
        contentView.layer.cornerRadius = 30
        startTimer()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            embededMyOnboardingPageVC?.goNext()
        })
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    #warning("TODO: - Rx 적용해보기")
    @objc func updateTimer() {
        if time < 1 {
            timer.invalidate()
            time = 10
            timeLabel.text = "10:00"
            
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
}
