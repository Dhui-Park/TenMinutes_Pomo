//
//  ViewController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/01.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    
    #warning("TODO: - design")
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    let foreProgressLayer = CAShapeLayer()
    
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    var timer = Timer()
    var isTimerStarted: Bool = false
    var isAnimationStarted: Bool = false
    var time: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawBackLayer()
    } // viewDidLoad()

    @IBAction func startBtnClicked(_ sender: UIButton) {
        
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
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
            
            #warning("TODO: - 계속 집중 or 휴식 선택화면 띄우기")
            //MARK: - 선택화면 띄우기
            // 1. 스토리보드 가져오기
            let storyboard = UIStoryboard.init(name: "SelectVC", bundle: nil)
            // 2. 스토리보드를 통해 뷰컨트롤러 가져오기
            guard let selectVC = storyboard.instantiateInitialViewController() else { return }
            // 3. 팝업 효과 설정
            selectVC.modalPresentationStyle = .overCurrentContext
            selectVC.modalTransitionStyle = .crossDissolve
            
            self.present(selectVC, animated: true)
            
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
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Brrrrrr")
    }
}
