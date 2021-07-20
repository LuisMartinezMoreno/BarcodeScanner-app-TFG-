//
//  AddProductViewController.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 06/06/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UITextFieldDelegate{
        
    @IBOutlet weak var NombreLbl: UITextField!
    @IBOutlet weak var PrecioLbl: UITextField!
    @IBOutlet weak var TamañoLbl: UITextField!
    @IBOutlet weak var FormatPicker: UIPickerView!
    private var codigoEan:String = ""
    private var cantidad:Int = 0;
    private var arrayProductos: [DouglasProduct] = []
    
    @IBAction func AddAction(_ sender: Any) {
        if (NombreLbl.hasText && PrecioLbl.hasText && TamañoLbl.hasText)
        {
            let date: Date = Date(timeIntervalSince1970: 0)
            let productoNuevo = DouglasProduct(code2: "0000", ean2: codigoEan, description2: NombreLbl.text!, price2: PrecioLbl.text!, season2: 200, discountPrice2: 0, dateStartPromo2: date, dateEndPromo2: date, quantity2: cantidad, size2: Int(TamañoLbl.text!)!, sizeFormat2: "ml", qte2: 100)
                arrayProductos.append(productoNuevo)
        }else
        {
            let dialogMessage = UIAlertController(title: "¡Cuidado!", message: "Se tienen que completar todos los campos", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    private let dataSource = ["l","cl","ml","kg","g", "mg", "fl oz"]
    override func viewDidLoad(){
        FormatPicker.dataSource = self
        FormatPicker.delegate = self
        PrecioLbl.keyboardType = UIKeyboardType.decimalPad
        TamañoLbl.keyboardType =  UIKeyboardType.decimalPad
    }
}
extension AddProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? MainViewController {
            destVC.setArray(array: arrayProductos)
                }
    }
    func setArray(array: [DouglasProduct]){
        arrayProductos = array
    }
    func setCodigoEan(code:String){
        codigoEan = code
    }
    func setQuantity(quantity:Int){
        cantidad = quantity
    }
}
