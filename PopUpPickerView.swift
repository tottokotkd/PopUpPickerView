import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class PopUpPickerView: UIView {

    var pickerView: UIPickerView!
    var pickerToolbar: UIToolbar!
    var toolbarItems = [UIBarButtonItem]()
    lazy var doneButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(PopUpPickerView.endPicker))
    }()
    lazy var itemSelected: Driver<[Int]> = {
        return self.doneButtonItem.rx_tap.asDriver()
            .map { _ in
                self.hidePicker()
                self.selectedRows = nil
                return self.getSelectedRows()
            }
            .startWith(self.selectedRows ?? [])
    }()

    var delegate: PopUpPickerViewDelegate? {
        didSet {
            pickerView.delegate = delegate
        }
    }
    internal var selectedRows: [Int]?

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

    convenience init(rows: [Int]) {
        self.init()
        selectedRows = rows
    }

    private func initFunc() {
        let screenSize = UIScreen.mainScreen().bounds.size
        self.backgroundColor = UIColor.blackColor()

        pickerToolbar = UIToolbar()
        pickerView = UIPickerView()

        pickerToolbar.translucent = true
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.whiteColor()

        self.bounds = CGRectMake(0, 0, screenSize.width, 260)
        self.frame = CGRectMake(0, screenSize.height, screenSize.width, 260)
        pickerToolbar.bounds = CGRectMake(0, 0, screenSize.width, 44)
        pickerToolbar.frame = CGRectMake(0, 0, screenSize.width, 44)
        pickerView.bounds = CGRectMake(0, 0, screenSize.width, 216)
        pickerView.frame = CGRectMake(0, 44, screenSize.width, 216)

        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(PopUpPickerView.cancelPicker))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]

        pickerToolbar.setItems(toolbarItems, animated: false)
        self.addSubview(pickerToolbar)
        self.addSubview(pickerView)
    }

    // MARK: Actions
    func showPicker() {
        if selectedRows == nil {
            selectedRows = getSelectedRows()
        }
        if let selectedRows = selectedRows {
            for (component, row) in selectedRows.enumerate() {
                pickerView.selectRow(row, inComponent: component, animated: false)
            }
        }
        let screenSize = UIScreen.mainScreen().bounds.size
        UIView.animateWithDuration(0.2) {
            self.frame = CGRectMake(0, screenSize.height - 260.0, screenSize.width, 260.0)
        }
    }

    func cancelPicker() {
        hidePicker()
        restoreSelectedRows()
        selectedRows = nil
    }

    func endPicker() {
        hidePicker()
        delegate?.pickerView?(pickerView, didSelect: getSelectedRows())
        selectedRows = nil
    }

    func hidePicker() {
        let screenSize = UIScreen.mainScreen().bounds.size
        UIView.animateWithDuration(0.2) {
            self.frame = CGRectMake(0, screenSize.height, screenSize.width, 260.0)
        }
    }

    internal func getSelectedRows() -> [Int] {
        var selectedRows = [Int]()
        for i in 0..<pickerView.numberOfComponents {
            selectedRows.append(pickerView.selectedRowInComponent(i))
        }
        return selectedRows
    }

    private func restoreSelectedRows() {
        for i in 0..<selectedRows!.count {
            pickerView.selectRow(selectedRows![i], inComponent: i, animated: true)
        }
    }

}

@objc
protocol PopUpPickerViewDelegate: UIPickerViewDelegate {
    optional func pickerView(pickerView: UIPickerView, didSelect numbers: [Int])
}
