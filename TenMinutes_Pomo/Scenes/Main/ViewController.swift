//
//  ViewController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/01.
//

// frameworks
import UIKit
// AV: AudioVisual
import AVFoundation

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
class ViewController: UIViewController, CAAnimationDelegate {

    // @IBOutlet에서 IB는 Interface Builder
    // weak 약한 참조? -> 더 알아보기(영어로 잘 이해X)
    
    @IBOutlet weak var timeLabel: UILabel!
    
    #warning("TODO: - design")
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    /// for animation
    /// CA = Core Animation
    /// 변수를 설정해 각각 인스턴스를 만들어준다.
    /// downcasting - type casting
    /// ㅎㅕㅇ
    ///
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    /// for timer
    /// 타이머 기능을 사용하기 위해 timer라는 변수에 Timer의 인스턴스를 생성해 선언해 준다.
    var timer = Timer()
    var isTimerStarted: Bool = false
    var isAnimationStarted: Bool = false
    // 체크를 위해서 10초로 설정.
    #warning("TODO: - 체크가 끝나면 600초로 바꿀 것.")
    var time: Int = 10
    
    #warning("TODO: - RxSwift 공부할 것")
    // 연속으로 집중한 시간, 10분 타이머 재생횟수
    var gritCount: Int = 0
    // 휴식시간을 가진 횟수
    var breakTime: Int = 0
    
    var gritHour: Int = 0
    
    @IBOutlet weak var gritLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    // viewDidLoad()는 앱이 처음 실행될때 뷰가 로드된 뒤 실행된다. 
    // 앱의 생명주기에 대해서
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        fetchTodayGritUIApply()
        fetchTodayBreakUIApply()
    } // viewDidLoad()

    
    @IBAction func startBtnClicked(_ sender: UIButton) {
        
        /// @MainActor open class UIControl:
        /// @MainActor란?
        /// open과 public의 차이는 뭘까?
        resetBtn.isEnabled = true
        resetBtn.alpha = 1.0
        
        if !isTimerStarted {
            drawForeLayer()
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            startBtn.setImage(UIImage(systemName: "pause"), for: .normal)
            resetBtn.isEnabled = false
        } else {
            pausedAnimation()
            timer.invalidate()
            isTimerStarted = false
            startBtn.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        stopAnimation()
        resetBtn.isEnabled = false
        resetBtn.alpha = 0.5
        timer.invalidate()
        time = 10
        isTimerStarted = false
        timeLabel.text = "10:00"
    }
    
    
    func startTimer() {
        /// class func scheduledTimer()
        /// class func에 대해서
        ///
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /// @objc로 해야하는 이유가 뭘까?
    @objc func updateTimer() {
        
        //            - [ ]  10분이 지나면
        if time < 1 {
            resetBtn.isEnabled = false
            resetBtn.alpha = 0.5
            startBtn.setImage(UIImage(systemName: "play"), for: .normal)
            timer.invalidate()
            time = 10
            isTimerStarted = false
            timeLabel.text = "10:00"
            
            #warning("TODO: - 진동 실기계 테스트 필요")
            //MARK: - Vibration
            UIDevice.vibrate()
            
//                - [ ]  그릿을 하나 추가한다
            GritRepository.shared.addAGrit()
            
//                - [ ]  그릿 카운트 변경을 감지한다
            
            // 오늘 그릿들
            var calendar = NSCalendar.current
            calendar.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
            
            let now = Date.now
            let date = now.formatted(date: .abbreviated, time: .omitted)
            
//            let today = Date().removeTimeStamp
            print(#fileID, #function, #line, "- today: \(date)")
            fetchTodayGritUIApply()
            
            #warning("TODO: - 시간이 같다면 addRecord()가 아니라 updateRecordItem()")

            
            
//            let result = recordGritCount.fetchRecords()
            
            let recordVC = RecordVC()
            #warning("TODO: - 실시간 반영을 위해 했는데 RecordVC애서 반영X")
            recordVC.updateChartWithData()
            
//            print("result from VC: \(result)")
            
            //MARK: - 선택화면 띄우기
            // 1. 스토리보드 가져오기
            let storyboard = UIStoryboard.init(name: "SelectVC", bundle: nil)

            if let selectVC = storyboard.instantiateViewController(withIdentifier: "SelectVC") as? SelectVC {
                self.navigationController?.pushViewController(selectVC, animated: true)
            }
            
            
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }

    }
    
    
    // 오늘 그릿들의 카운트를 가져와서 UI에 반영
    func fetchTodayGritUIApply() {
        let fetchedGrits : [GritEntity] = GritRepository.shared.fetchGritsForToday().map{ $0 }
        
        
        // createdAt이 오늘에 들어가있으면 가져온다
        
//                - [ ]  (조건안에서) 그릿들을 가져온다 - 가져온 그릿수
        
//            let gritCounts = GritRepository.shared.fetchGrits().count
        
//                - [ ]  가져온 그릿수를 UI에 반영한다
        gritLabel.text = "\(fetchedGrits.count)"
    }
    
    
    // 오늘 브레이크들의 카운트를 가져와서 UI에 반영
    func fetchTodayBreakUIApply() {
        let fetchedBreaks : [BreakEntity] = BreakRepository.shared.fetchBreaksForToday().map{ $0 }
        
        
        // createdAt이 오늘에 들어가있으면 가져온다
        
//                - [ ]  (조건안에서) 그릿들을 가져온다 - 가져온 그릿수
        
//            let gritCounts = GritRepository.shared.fetchGrits().count
        
//                - [ ]  가져온 그릿수를 UI에 반영한다
        self.breakTimeLabel?.text = "\(fetchedBreaks.count)"
    }
    
    
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    //background layer
    func drawBackLayer() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - 15), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        backProgressLayer.path = circlePath
        backProgressLayer.strokeColor = UIColor(named: "MainPurple")?.cgColor
        backProgressLayer.opacity = 0.6
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        
        backProgressLayer.shadowColor = UIColor(named: "MainPurple")?.cgColor
        
        backProgressLayer.shadowRadius = 25.0
        backProgressLayer.shadowOpacity = 1
        backProgressLayer.shadowPath = circlePath.copy(strokingWithWidth: 20, lineCap: .round, lineJoin: .miter, miterLimit: 0)

        foreProgressLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        
        view.layer.addSublayer(backProgressLayer)
    }
    
    // fore layer
    #warning("TODO: - 버그: 세팅화면을 갔다가 오면 안되는 것")
    func drawForeLayer() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - 15), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        foreProgressLayer.path = circlePath
        
        foreProgressLayer.strokeColor = UIColor(named: "MainPurple")?.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0
        foreProgressLayer.beginTime = 0
        foreProgressLayer.strokeEnd = 0
        isAnimationStarted = false
    }
    
    func pausedAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0
        foreProgressLayer.beginTime = 0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0
        foreProgressLayer.beginTime = 0
        foreProgressLayer.strokeEnd = 0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    /// internal func에 대해서
    /// internal: 내부의
    /// 그럼 fileprivate와는 다른 것?
    /// fileprivate와 private는?
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}

/// extension
extension Int {
    /// @frozen?
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension UIDevice {
    /// static func에 대해서
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Brrrrrr")
    }
}
