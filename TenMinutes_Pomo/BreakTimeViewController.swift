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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        #warning("TODO: - 페이지뷰컨트롤러로 명언이나 화이팅하는 문구들 만들기")
        
        contentView.layer.cornerRadius = 30
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 {
            timer.invalidate()
            time = 10
            timeLabel.text = "10:00"
            
            self.dismiss(animated: true)
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
