//
//  BreakTimeViewController.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/03.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class BreakTimeViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var breakTimeVM: BreakTimeVM = BreakTimeVM()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    var embededMyOnboardingPageVC: MyOnboardingPageController? {
        return children.first(where: { $0 is MyOnboardingPageController }) as? MyOnboardingPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        
        contentView.layer.cornerRadius = 30
        
        setBindings()
        
        
        // vm
//        breakTimeVM.startTimer()
        breakTimeVM.inputAction.accept(.startTimer)

        // vm
    }
    
    private func setBindings(){
        
        self.breakTimeVM
            .tenMinutesString
            .bind(to: self.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.breakTimeVM
            .popEvent
            .bind(to: self.rx.popHandler)
            .disposed(by: disposeBag)
        
        self.breakTimeVM
            .goNextPageObservable
            .debug("debug go next")
//            .goNextPageEvent
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.embededMyOnboardingPageVC?.goNext()
            })
            .disposed(by: disposeBag)
        
    }
    
}


// from RxGeoLocationExample
private extension Reactive where Base: BreakTimeViewController {
    var popHandler: Binder<Void> {
        return Binder(base) { vc, _ in
            if let viewController = vc.navigationController?.viewControllers.first as? ViewController {
                viewController.fetchTodayBreakUIApply()
            }
            vc.navigationController?.popToRootViewController(animated: true)
        }
    }
}
