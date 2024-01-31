//
//  TimerVM.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 1/31/24.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class TimerVM: ObservableObject {
    
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    var isAnimationStarted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var timer = Timer()
    #warning("TODO: - 체크가 끝나면 600초로 바꿀 것.")
    var time: Int = 10
    
//    var isTimerStarted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isTimerStarted: Bool = false
    
    init() {
        print(#fileID, #function, #line, "- TimerVM")
    }
    
    // fore layer
    #warning("TODO: - 버그: 세팅화면을 갔다가 오면 안되는 것")
    func drawForeLayer(_ view: UIView) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - 15), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        foreProgressLayer.path = circlePath
        foreProgressLayer.strokeColor = UIColor(named: "MainPurple")?.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        
        view.layer.addSublayer(foreProgressLayer)
    }
    
    //background layer
    func drawBackLayer(_ view: UIView) {
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
    
    
    func startAnimation(_ vc: UIViewController) {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10
        animation.delegate = vc.self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        self.isAnimationStarted.accept(true)
    }
    
    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0
        foreProgressLayer.beginTime = 0
        foreProgressLayer.strokeEnd = 0
        self.isAnimationStarted.accept(false)
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
        self.isAnimationStarted.accept(false)
    }
    
    func startResumeAnimation(_ vc: UIViewController) {
        if !self.isAnimationStarted.value {
            startAnimation(vc)
        } else {
            resumeAnimation()
        }
    }
    
    /// internal func에 대해서
    /// internal: 내부의
    /// 그럼 fileprivate와는 다른 것?
    /// fileprivate와 private는?
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func startTimer(resetBtn: UIButton, startBtn: UIButton, timeLabel: UILabel) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(resetBtn: UIButton, startBtn: UIButton, timeLabel: UILabel, gritLabel: UILabel, vc: UIViewController) {
        
        //        - [ ]  10분이 지나면
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
            fetchTodayGritUIApply(gritLabel: gritLabel)
            
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
                vc.navigationController?.pushViewController(selectVC, animated: true)
            }
            
            
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }

    }
    
    func timerStartBtnClicked(startBtn: UIButton, resetBtn: UIButton, timeLabel: UILabel, view: UIView, vc: UIViewController) {
        resetBtn.isEnabled = true
        resetBtn.alpha = 1.0
        
        if !isTimerStarted {
            self.drawForeLayer(view)
            self.startResumeAnimation(vc)
            self.startTimer(resetBtn: resetBtn, startBtn: startBtn, timeLabel: timeLabel)
            self.isTimerStarted = true
            startBtn.setImage(UIImage(systemName: "pause"), for: .normal)
            resetBtn.isEnabled = false
        } else {
            self.pausedAnimation()
            self.timer.invalidate()
            self.isTimerStarted = false
            startBtn.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    
    // 오늘 그릿들의 카운트를 가져와서 UI에 반영
    func fetchTodayGritUIApply(gritLabel: UILabel) {
        let fetchedGrits : [GritEntity] = GritRepository.shared.fetchGritsForToday().map{ $0 }
        
        
        // createdAt이 오늘에 들어가있으면 가져온다
        
        //                - [ ]  (조건안에서) 그릿들을 가져온다 - 가져온 그릿수
        
        //            let gritCounts = GritRepository.shared.fetchGrits().count
        
        //                - [ ]  가져온 그릿수를 UI에 반영한다
        
        gritLabel.text = "\(fetchedGrits.count)"
    }
    
    
    // 오늘 브레이크들의 카운트를 가져와서 UI에 반영
    func fetchTodayBreakUIApply(breakTimeLabel: UILabel) {
        let fetchedBreaks : [BreakEntity] = BreakRepository.shared.fetchBreaksForToday().map{ $0 }
        
        breakTimeLabel.text = "\(fetchedBreaks.count)"
    }
    
}
