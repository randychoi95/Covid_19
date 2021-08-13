//
//  ViewController.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/03.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: PROPERTY
    
    // sevice 키
    let serviceKey  = "9PAc6aMn2DC3xdA7rYZn71Hxr3mT9V5E4qnnakQkwj44zVNrPfV%2FVLVnDsnf30wrZZ%2BD%2FS%2BWRTNinP7J8lMjeQ%3D%3D"
    
    // 첫 네트워크 통신인지 아닌지 판별하는 변수
    var isFirstNetwork = true
    
    // json통신 후 모든 데이터 저장하는 변수
    var center_Info: Centers?
    
    // 시/도의 데이터만 저장하는 변수
    var sido_Info: [String] = []
    
    // 시/군/구의 데이터만 저장하는 변수
    var sigungu_Info: [String] = []
    
    // 피커뷰에 들어가는 데이터 저장하는 변수
    var pickerView_data: [String] = []
    
    // 시설명 데이터만 저장하는 변수
    var facilityName_Info: [String] = []
    
    // 텍스트 필드 태그 값 저장하는 변수
    var textFieldTag = 0
    
    // MARK: IBOutlet
    @IBOutlet weak var sido_textField: UITextField!
    @IBOutlet weak var sigungu_textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "코로나19 예방접종센터"
        
        self.callCenterSearchService()
        self.setTableView()
        self.setTextField()
    }
    
    // MARK: CUSTOM FUNCTION
    
    // 예방접종센터 조회
    private func callCenterSearchService(page: Int = 1, perPage: Int = 10) {
        var param: [String: Any] = [:]
        param.updateValue(page, forKey: "page")
        param.updateValue(perPage, forKey: "perPage")
        param.updateValue(serviceKey, forKey: "serviceKey")
        
        RESTful.centerSearchNetwork(param, .get) { result, model, error in
            if result == -1 {
                if let err = error {
                    self.showAlert(title: "에러", message: err.localizedDescription, completionHandler: nil)
                }
            } else {
                if let model = model {
                    if self.isFirstNetwork {
                        self.callCenterSearchService(perPage: model.totalCount ?? 10)
                        self.isFirstNetwork = false
                    } else {
                        self.center_Info = model
                        if let centerInfo = self.center_Info {
                            if let data = centerInfo.data {
                                var sidoSet:Set<String> = []
                                for item in data {
                                    if let sido = item.sido {
                                        sidoSet.insert(sido)
                                    }
                                }
                                self.sido_Info = sidoSet.map {$0}.sorted()
                                print("sido_Info = \(self.sido_Info)")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // 알람창 보여주기
    private func showAlert(title: String, message: String, completionHandler: ((UIAlertAction)-> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 테이블뷰 세팅
    private func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "CenterTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CenterTableViewCell")
        self.tableView.separatorStyle = .none
        self.tableView.bounces = false
    }
    
    // 텍스트필드 세팅
    private func setTextField() {
        self.sido_textField.tintColor = .clear
        self.sido_textField.delegate = self
        self.sigungu_textField.tintColor = .clear
        self.sigungu_textField.delegate = self
    }
    
    // 피커뷰 생성
    func createPickerView(_ textField: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPickerItem))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.selectPickerItem))

        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    // "취소"버튼 액션함수
    @objc func cancelPickerItem() {
        self.view.endEditing(true)
    }
    
    // "선택"버튼 액션함수
    @objc func selectPickerItem() {
        if textFieldTag == 1 {
            if let sido = self.sido_textField.text {
                self.setSigungoData(sido)
            }
        } else if textFieldTag == 2 {
            if let sido = self.sido_textField.text, let sigungo = self.sigungu_textField.text {
                self.setfacilityName(sido, sigungo)
            }
        }
        self.view.endEditing(true)
    }
    
    // 시군구 데이터 세팅
    private func setSigungoData(_ sido: String) {
        var sigungoSet: Set<String> = []
        if let data = self.center_Info?.data {
            for item in data {
                if let item_sido = item.sido, sido.elementsEqual(item_sido) {
                    if let item_sigungu = item.sigungu {
                        sigungoSet.insert(item_sigungu)
                    }
                }
            }
        }
        self.sigungu_Info = sigungoSet.map{$0}.sorted()
    }
    
    // 시설명 데이터 세팅
    private func setfacilityName(_ sido: String, _ sigungu: String) {
        self.facilityName_Info = []
        if let data = self.center_Info?.data {
            for item in data {
                if let item_sido = item.sido, let item_sigungu = item.sigungu, sido.elementsEqual(item_sido), sigungu.elementsEqual(item_sigungu) {
                    if let item_facilityName = item.facilityName {
                        self.facilityName_Info.append(item_facilityName)
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.textFieldTag = 1
            createPickerView(textField)
        } else if textField.tag == 2 {
            self.textFieldTag = 2
            createPickerView(textField)
        }
        return true
    }
}

// MARK: UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFieldTag == 1 {
            return sido_Info.count
        } else if textFieldTag == 2 {
            return sigungu_Info.count
        } else {
            return 0
        }
    }
}

// MARK: UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textFieldTag == 1 {
            return sido_Info[row]
        } else if textFieldTag == 2 {
            return sigungu_Info[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textFieldTag == 1 {
            sido_textField.text = sido_Info[row]
            if let sido = sido_textField.text {
                setSigungoData(sido)
            }
        } else if textFieldTag == 2 {
            sigungu_textField.text = sigungu_Info[row]
        }
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.facilityName_Info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTableViewCell", for: indexPath) as! CenterTableViewCell
        if self.facilityName_Info.count > 0 {
            cell.center_name.text = self.facilityName_Info[indexPath.row]
        } else {
            cell.center_name.text = "데이터가 없습니다."
        }
        
        let selectView = UIView()
        selectView.backgroundColor = UIColor.systemBackground
        cell.selectedBackgroundView = selectView
        return cell
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        if let data = self.center_Info?.data {
            for item in data {
                if let facilityName = item.facilityName, facilityName.elementsEqual(self.facilityName_Info[indexPath.row]) {
                    vc.facility_Info = item
                }
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
