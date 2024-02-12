//
//  SelectVC.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/04.
//

// Framework
import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

// 아웃풋 -> time이라는 데이터 = 관리해야하는 데이터 상태
class SelectVM {
    
    // vm
    var timer: Timer? = nil
    
    // vm
//    var time: Int = 5
    var time: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 5)
    
    // vm
    var isBreakTimeSelected: Bool = false
    
    init() {
        
    }
    
    // vm
    // 이 로직의 어떠한 것이 핵심인가 잘 생각해보자.
    // selectVC의 viewDidLoad에서 startTimer()를 하면
    // VM의 startTimer가 updateTimer()를 때리고
    // time이라는 데이터에 따라서 로직이 움직인다.
    // time이라는 데이터가 핵심!
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // vm
    /// timer 데이터를 변경.(-1씩)
    @objc func updateTimer() {
        if time.value < 1 {
            timer?.invalidate()
            time.accept(5)
            if !isBreakTimeSelected {
//                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            time.accept(time.value - 1)
//            timeLabel.text = "\(time)"
        }
    }
    
}

// dfkfkfkfkkf
class SelectVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var selectVM: SelectVM = SelectVM()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.selectVM.startTimer()
        
        self.selectVM.time
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }
                if time < 1 {
                    // 뷰 다시 메인화면으로 돌아가기
                    print(#fileID, #function, #line, "- 뷰 다시 메인화면으로 돌아가기")
                } else {
                    self.timeLabel.text = "\(time)"
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    @IBAction func breakTimeBtn(_ sender: UIButton) {
//        isBreakTimeSelected = true
        print(#fileID, #function, #line, "- ")
        //MARK: - 휴식화면 띄우기
        // 1. 스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "BreakTime", bundle: nil)

        if let breakTimeVC = storyboard.instantiateViewController(withIdentifier: "BreakTime") as? BreakTimeViewController {
            self.navigationController?.pushViewController(breakTimeVC, animated: true)
        }
        
        
    }
}
