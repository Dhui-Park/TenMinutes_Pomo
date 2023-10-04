//
//  SelectVC.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/04.
//

import Foundation
import UIKit

class SelectVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var time: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        timeLabel.text = "\(time)"
        startTimer()
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 {
            timer.invalidate()
            time = 5
            
            self.dismiss(animated: true)
        } else {
            time -= 1
            timeLabel.text = "\(time)"
        }
    }
    
//    func formatTime() -> String {
//        let seconds = Int(time) % 60
//        return String(format: "%02i", seconds)
//    }
    
    @IBAction func breakTimeBtn(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        //MARK: - 휴식화면 띄우기
        // 1. 스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "BreakTime", bundle: nil)
        // 2. 스토리보드를 통해 뷰컨트롤러 가져오기
        guard let breakTimeVC = storyboard.instantiateInitialViewController() else { return }
        // 3. 팝업 효과 설정
        breakTimeVC.modalPresentationStyle = .overCurrentContext
        breakTimeVC.modalTransitionStyle = .crossDissolve
        
        self.present(breakTimeVC, animated: true)
        
    }
}
