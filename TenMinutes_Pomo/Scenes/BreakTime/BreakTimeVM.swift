//
//  BreakTimeVM.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2/2/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

// 아웃풋 ->
//
// 가장 중요하게 생각하는 데이터 중점적으로 생각해보기!
class BreakTimeVM {
    
    // subject == relay
    
    // .value = behavior
    // .value 할 필요 X = publish
    
    // vm
    var timer = Timer()
    // vm
//    var time: Int = 10
    private var time: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 10)
    
    
    //MARK: - OUTPUT State or event
    
    var tenMinutesString: Observable<String> = Observable.empty()
    
    var popEvent: PublishRelay<Void> = PublishRelay()
    
    /// 다음 페이지로 넘어가는 이벤트
    var goNextPageEvent: PublishRelay<Void> = PublishRelay()
    
    var goNextPageObservable: Observable<Void> = Observable.empty()
    
//    enum Output {
//
//    }
    
    var disposeBag = DisposeBag()
    
    
    //MARK: - INPUT ACTION
    
    var inputAction : PublishRelay<Input> = PublishRelay()
    
    
    enum Input {
        case startTimer
        case resetTimer(data: Int)
        case pauseTimer
    }
    
    
    init() {
        
        inputAction
            .subscribe(onNext: { event in
                switch event {
                case .startTimer:
                    self.startTimer()
                case .pauseTimer:
                    break
                case .resetTimer(let data):
                    break
                }
            }).disposed(by: disposeBag)
        
        
        // vc로 보내줄 String 가공해서 주자!
        tenMinutesString = time
            .map { time in
            if time < 1 {
                return "10:00"
            } else {
                return time.formattedTime()
            }
        } // presentation logic(화면에 보여주기 위한 로직도 vm로 보내기)(선택사항이지만 훨씬 깔끔하게 정리 가능!)
        
        
        goNextPageObservable =  Observable<Int>
            .interval(.seconds(3), scheduler: MainScheduler()) // TimeInterval
            .map{ _ in }
        
    }
    
    
    // vc -> VM
    // INPUT
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
//        Observable<Int>
//            .interval(.seconds(3), scheduler: MainScheduler()) // TimeInterval
//            .withUnretained(self)
//            .bind(onNext: { vm, _ in
//                vm.goNextPageEvent.accept(())
//            })
//            .disposed(by: disposeBag)
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in
//            guard let self = self else { return }
//            // vc
////            embededMyOnboardingPageVC?.goNext()
//            goNextPageEvent.accept(())
//        })
    }
    
    #warning("TODO: - Rx 적용해보기")
    // vm
    
    //
    
    /// timer 데이터를 변경 (-1씩)
    @objc private func updateTimer() {
        if time.value < 1 {
            timer.invalidate()
            time.accept(10)
            
            BreakRepository.shared.addABreak()
            
            // 오늘 break들
            var calendar = NSCalendar.current
            calendar.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
            
            let now = Date.now
            let date = now.formatted(date: .abbreviated, time: .omitted)
            
            //            let today = Date().removeTimeStamp
            print(#fileID, #function, #line, "- today: \(date)")
            
            popEvent.accept(())
//
        } else {
            time.accept(time.value - 1)
        }
    }
    
}
