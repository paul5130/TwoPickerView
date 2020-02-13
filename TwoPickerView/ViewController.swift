
import UIKit
import SwiftUI

class ViewController: UIViewController {
    lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    let textfield: UITextField = {
        let tv = UITextField()
        tv.borderStyle = .roundedRect
        tv.placeholder = "點我顯示picker view"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var cities = [City]()
    var districtNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textfield)
        textfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        textfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textfield.inputView = pickerView
        loadJSON()
    }
    private func loadJSON(){
        guard let url = Bundle.main.url(forResource: "Taiwan", withExtension: "json") else { return }
        let data = try! Data(contentsOf: url)
        print(String(decoding: data, as: UTF8.self))
        do{
            let result = try JSONDecoder().decode([City].self, from: data)
            self.cities = result
            print(result)
        }catch let error{
            print(error)
        }
    }
}
extension ViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return cities.count
        case 1:
            return cities[districtNumber].district.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            districtNumber = row
            return cities[row].city
        case 1:
            return cities[districtNumber].district[row]
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 1, animated: true)
            districtNumber = row
            textfield.text = "縣市：" + cities[row].city
        case 1:
            textfield.text = "縣市：" + cities[districtNumber].city + " 地區：" + cities[districtNumber].district[row]
        default:
            print("Failed to select picker view . ")
        }
    }
}
struct City: Decodable{
    let city: String
    let district: [String]
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    struct ContainerView: UIViewControllerRepresentable{
        func updateUIViewController(_ uiViewController: ViewController, context: Context) {
            
        }
        func makeUIViewController(context: Context) -> ViewController {
            ViewController()
        }
    }
}
