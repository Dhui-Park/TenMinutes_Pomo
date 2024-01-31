//
//  ViewController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/01.
//

// frameworks
import UIKit
import RxSwift
import RxRelay
import RxCocoa

/// 클래스 ViewController는 UIViewController를 상속하고, 또 CAAnimationDelegate를 '채택'한다.
/// class와 struct의 차이는?
///
/// Apple documents <Structures vs Classes>
/// Structures: value types
/// Classes: reference types
///  Swift의 타입에는 두 종류가 있다. value / reference
///  예를 들어 친구에게 문서를 보여준다고 했을 때,
///  1. 복사해서 보내준다
///  2. 구글 닥스나 icloud에 공유해서 보여준다.
///  이 두가지 방법이 있을 것이다. 두가지 모두 친구가 읽고, 그 문서를 수정하고 등등 할 수 있는 것은 마찬가지.
///  하지만 1번은 친구가 아무리 수정해도 복사하기 전 나의 문서에는 아무런 영향 x
///
///  value type:
///  Structures, enum, tuple이 있다.
///  1번과 유사(복사본을 넘겨준다)
///
///  reference type:
///  Classes, actors, closures
///  2번과 유사(링크를 보내준다)
///
/// - Use structures by default.
/// 
/// - Use classes when you need Objective-C interoperability(정보처리상호운용). : objective-c가 필요하다면
/// - Use classes when you need to control the identity of the data you’re modeling.
/// class 사용하면 앱 전반적으로 한번 변경할때 다 바꿀 수 있다. class는 reference type이기에
/// - Use structures along with protocols to adopt behavior by sharing implementations.
///
// [A1-02]
class ViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
#warning("TODO: - design")
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    var timerVM: TimerVM = TimerVM()
    
    /// for animation
    /// CA = Core Animation
    /// 변수를 설정해 각각 인스턴스를 만들어준다.
    /// downcasting - type casting
    /// 형
    ///
    
    
    
    //    let foreProgressLayer = CAShapeLayer()
    
    //    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    /// for timer
    /// 타이머 기능을 사용하기 위해 timer라는 변수에 Timer의 인스턴스를 생성해 선언해 준다.
    //    var timer = Timer()
    
    //    var isTimerStarted: Bool = false
    //    var isTimerStarted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //    var isAnimationStarted: Bool = false
    // 체크를 위해서 10초로 설정.
    //    #warning("TODO: - 체크가 끝나면 600초로 바꿀 것.")
    //    var time: Int = 10
    
#warning("TODO: - RxSwift 공부할 것")
    
    var focusCount: PublishSubject<Int> = PublishSubject<Int>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var gritLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerVM.drawBackLayer(view)
        self.timerVM.fetchTodayGritUIApply(gritLabel: self.gritLabel)
        self.timerVM.fetchTodayBreakUIApply(breakTimeLabel: self.breakTimeLabel)
        
//        startBtn.rx.tap
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: { [weak self] in
//                guard let self = self else { return }
//                
//                self.resetBtn.isEnabled = true
//                self.resetBtn.alpha = 1.0
//                
//                if !self.timerVM.isTimerStarted.value {
//                    self.timerVM.drawForeLayer(view)
//                    self.timerVM.startResumeAnimation(self)
//                    self.timerVM.startTimer(resetBtn: self.resetBtn, startBtn: self.startBtn, timeLabel: self.timeLabel)
//                    self.timerVM.isTimerStarted.accept(true)
//                    startBtn.setImage(UIImage(systemName: "pause"), for: .normal)
//                    resetBtn.isEnabled = false
//                } else {
//                    self.timerVM.pausedAnimation()
//                    self.timerVM.timer.invalidate()
//                    self.timerVM.isTimerStarted.accept(false)
//                    startBtn.setImage(UIImage(systemName: "play"), for: .normal)
//                }
//            }).disposed(by: disposeBag)
        
//        resetBtn.rx.tap
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: {
//                print(#fileID, #function, #line, "- resetBtntapped")
//                self.timerVM.stopAnimation()
//                self.resetBtn.isEnabled = false
//                self.resetBtn.alpha = 0.5
//                self.timerVM.timer.invalidate()
//                self.timerVM.time = 10
//                self.timerVM.isTimerStarted.accept(false)
//                self.timeLabel.text = "10:00"
//            })
//            .disposed(by: disposeBag)
        
    } // viewDidLoad()
    
    @IBAction func startBtnClicked(_ sender: UIButton) {
        
        self.timerVM.timerStartBtnClicked(startBtn: self.startBtn, resetBtn: self.resetBtn, timeLabel: self.timeLabel, view: view, vc: self)
        
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        
        print(#fileID, #function, #line, "- resetBtntapped")
        self.timerVM.stopAnimation()
        self.resetBtn.isEnabled = false
        self.resetBtn.alpha = 0.5
        self.timerVM.timer.invalidate()
        self.timerVM.time = 10
        self.timerVM.isTimerStarted = false
        self.timeLabel.text = "10:00"
        
    }
    
}
