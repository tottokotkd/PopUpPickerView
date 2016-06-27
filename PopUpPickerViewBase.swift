//
//  PopUpPickerViewBase.swift
//  AITravel-iOS
//
//  Created by 村田 佑介 on 2016/06/27.
//  Copyright © 2016年 Best10, Inc. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class PopUpPickerViewBase: UIView {

    var pickerToolbar: UIToolbar!
    var toolbarItems = [UIBarButtonItem]()
    lazy var doneButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(self.endPicker))
    }()

    // MARK: Initializer
    init() {
        super.init(frame: CGRect.zero)
        initFunc()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFunc()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFunc()
    }

    private func initFunc() {
        let screenSize = UIScreen.mainScreen().bounds.size
        self.backgroundColor = UIColor.blackColor()

        pickerToolbar = UIToolbar()
        pickerToolbar.translucent = true

        self.bounds = CGRectMake(0, 0, screenSize.width, 260)
        self.frame = CGRectMake(0, parentViewHeight(), screenSize.width, 260)
        pickerToolbar.bounds = CGRectMake(0, 0, screenSize.width, 44)
        pickerToolbar.frame = CGRectMake(0, 0, screenSize.width, 44)

        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(PopUpPickerView.cancelPicker))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]

        pickerToolbar.setItems(toolbarItems, animated: false)
        self.addSubview(pickerToolbar)
    }

    // MARK: Actions
    func showPicker() {
    }

    func cancelPicker() {
    }

    func endPicker() {
    }

    func hidePicker() {
        let screenSize = UIScreen.mainScreen().bounds.size
        UIView.animateWithDuration(0.2) {
            self.frame = CGRectMake(0, self.parentViewHeight(), screenSize.width, 260.0)
        }
    }

    func parentViewHeight() -> CGFloat {
        return superview?.frame.height ?? UIScreen.mainScreen().bounds.size.height
    }

}
