//
//  SelectVC.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/04.
//

// Framework
import Foundation
import UIKit

// dfkfkfkfkkf
class SelectVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //
    var timer: Timer? = nil
    
    var time: Int = 5
    
    var isBreakTimeSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        timeLabel.text = "\(time)"
        self.startTimer()
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 {
            timer?.invalidate()
            time = 5
            if !isBreakTimeSelected {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            time -= 1
            timeLabel.text = "\(time)"
        }
    }
    
    
    @IBAction func breakTimeBtn(_ sender: UIButton) {
        isBreakTimeSelected = true
        print(#fileID, #function, #line, "- ")
        //MARK: - 휴식화면 띄우기
        // 1. 스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "BreakTime", bundle: nil)

        if let breakTimeVC = storyboard.instantiateViewController(withIdentifier: "BreakTime") as? BreakTimeViewController {
            self.navigationController?.pushViewController(breakTimeVC, animated: true)
        }
        
        
    }
}
