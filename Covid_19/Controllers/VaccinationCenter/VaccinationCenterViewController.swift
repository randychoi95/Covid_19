//
//  ViewController.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/03.
//

import UIKit

class VaccinationCenterViewController: UIViewController {
    
    // MARK: PROPERTY
    
    var viewModel: VaccinationCenterViewModel!
    
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
        
        self.setNavigationItem()
        self.setTableView()
        self.setTextField()
        
        viewModel = VaccinationCenterViewModel(viewController: self)
        viewModel.callCenterSearchService()
    }
    
    // MARK: CUSTOM FUNCTION
    
    // 네비게이션 아이템 세팅
    private func setNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButton)
                                                                )
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
                self.viewModel.setSigungoData(sido)
            }
        } else if textFieldTag == 2 {
            if let sido = self.sido_textField.text, let sigungo = self.sigungu_textField.text {
                self.viewModel.setfacilityName(sido, sigungo)
                self.tableView.reloadData()
            }
        }
        self.view.endEditing(true)
    }
    
    // 네비게이션 백 버튼 액션함수
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextFieldDelegate
extension VaccinationCenterViewController: UITextFieldDelegate {
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
extension VaccinationCenterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFieldTag == 1 {
            return self.viewModel.sido_Info.count
        } else if textFieldTag == 2 {
            return self.viewModel.sigungu_Info.count
        } else {
            return 0
        }
    }
}

// MARK: UIPickerViewDelegate
extension VaccinationCenterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textFieldTag == 1 {
            return self.viewModel.sido_Info[row]
        } else if textFieldTag == 2 {
            return self.viewModel.sigungu_Info[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textFieldTag == 1 {
            sido_textField.text = self.viewModel.sido_Info[row]
            if let sido = sido_textField.text {
                self.viewModel.setSigungoData(sido)
            }
        } else if textFieldTag == 2 {
            sigungu_textField.text = self.viewModel.sigungu_Info[row]
        }
    }
}

// MARK: UITableViewDataSource
extension VaccinationCenterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.facilityName_Info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTableViewCell", for: indexPath) as! CenterTableViewCell
        if self.viewModel.facilityName_Info.count > 0 {
            cell.center_name.text = self.viewModel.facilityName_Info[indexPath.row]
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
extension VaccinationCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VaccinationCenterDetailViewController") as? VaccinationCenterDetailViewController else {
            return
        }
        if let data = self.viewModel.center_Info?.data {
            for item in data {
                if let facilityName = item.facilityName, facilityName.elementsEqual(self.viewModel.facilityName_Info[indexPath.row]) {
                    vc.facility_Info = item
                }
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
