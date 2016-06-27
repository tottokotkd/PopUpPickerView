import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class PopUpPickerView: PopUpPickerViewBase {

    var pickerView: UIPickerView!
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
    override init() {
        super.init()
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

        pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.bounds = CGRectMake(0, 0, screenSize.width, 216)
        pickerView.frame = CGRectMake(0, 44, screenSize.width, 216)

        self.addSubview(pickerView)
    }

    // MARK: Actions
    override func showPicker() {
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
            self.frame = CGRectMake(0, self.parentViewHeight() - 260.0, screenSize.width, 260.0)
        }
    }

    override func cancelPicker() {
        hidePicker()
        restoreSelectedRows()
        selectedRows = nil
    }

    override func endPicker() {
        hidePicker()
        delegate?.pickerView?(pickerView, didSelect: getSelectedRows())
        selectedRows = nil
    }

    internal func getSelectedRows() -> [Int] {
        var selectedRows = [Int]()
        for i in 0..<pickerView.numberOfComponents {
            selectedRows.append(pickerView.selectedRowInComponent(i))
        }
        return selectedRows
    }

    private func restoreSelectedRows() {
        guard let selectedRows = selectedRows else { return }
        for i in 0..<selectedRows.count {
            pickerView.selectRow(selectedRows[i], inComponent: i, animated: true)
        }
    }

}

@objc
protocol PopUpPickerViewDelegate: UIPickerViewDelegate {
    optional func pickerView(pickerView: UIPickerView, didSelect numbers: [Int])
}
