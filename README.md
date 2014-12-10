PopUpPickerView
===============

just pop-up UIPickerView

# how to use

1. declare: `var pickerView: PopUpPickerView!`
2. set: `pickerView = PopUpPickerView(); pickerView.delegate = self; self.view.addSubview(pickerView)`
3. show: `pickerView.showPicker()`

## exmaple

```
import UIKit
class ViewController: UIViewController, PopUpPickerViewDelegate {
    var pickerView: PopUpPickerView!
    let array = ["test1", "test2", "test3", "test4", "test5"]

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView = PopUpPickerView()
        pickerView.delegate = self
        self.view.addSubview(pickerView)
        
        let button = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        button.frame = CGRectMake(50, 100, 30, 30);
        button.addTarget(self, action: "showPicker", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(button)
    }
    func showPicker() {
        pickerView.showPicker()
    }
    // for delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return array[row]
    }
    func pickerView(pickerView: UIPickerView, didSelect numbers: [Int]) {
        println(numbers)
    }
}
```
