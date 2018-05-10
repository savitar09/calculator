//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Tuan SPK on 5/3/18.
//  Copyright © 2018 Tuan SPK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    @IBOutlet weak var lblBieuThuc: UILabel!
//    @IBOutlet weak var lblKetQua: UILabel!
//
//    var kiTu1 = true
//    var dongNgoac = true
//
//    var giaTriBieuThuc = ""
//
//    var displayValue:String {
//        get {
//            return lblKetQua.text!
//        } set {
//            lblKetQua.text = String(newValue)
//        }
//    }
//
//    @IBAction func bieuThuc(_ sender: Any) {
//        if kiTu1 {
//            lblBieuThuc.text = (sender as AnyObject).currentTitle!
//        } else {
//            lblBieuThuc.text! += (sender as AnyObject).currentTitle!!
//        }
//        kiTu1 = false
//    }
//    @IBAction func ngoacTron(_ sender: Any) {
//        if dongNgoac {
//            lblBieuThuc.text! += "("
//            dongNgoac = false
//        } else {
//            lblBieuThuc.text! += ")"
//            dongNgoac = true
//        }
//    }
//
//    @IBAction func hienThiKQ(_ sender: Any) {
//        if !dongNgoac {
//            print("chua dong ngoac tron !!!")
//            return
//        }
//        displayValue = thucHien(baiToan: lblBieuThuc.text!)
//    }
//
//    @IBAction func xoa(_ sender: Any) {
//        displayValue = "0"
//        lblBieuThuc.text = String("")
//        lblKetQua.text = String("0")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func layChuoi(chuoiBD:String, viTriBDCat:Int, viTriKTCat:Int) -> String {
//        if(viTriKTCat >= chuoiBD.count){
//            return ""
//        }
//        let viTriBD = chuoiBD.index(chuoiBD.startIndex, offsetBy: viTriBDCat)
//        let viTriKT = chuoiBD.index(chuoiBD.startIndex, offsetBy: viTriKTCat)
//        return String(chuoiBD[viTriBD...viTriKT])
//    }
//
//    func laySo(viTriBD:Int, doDai:Int) -> Double {
//        let kiTuBD = giaTriBieuThuc.index(giaTriBieuThuc.startIndex, offsetBy: viTriBD)
//        let kiTuKT = giaTriBieuThuc.index(giaTriBieuThuc.startIndex, offsetBy: viTriBD + doDai - 1)
//        let stringSo = giaTriBieuThuc[kiTuBD...kiTuKT]
//        return Double(stringSo)!
//    }
//
//    func tinhToan(so1:Double, so2:Double, phepTinh:String) -> Double {
//        switch phepTinh {
//        case "+":
//            return so1 + so2
//        case "-":
//            return so1 - so2
//        case "*":
//            return so1 * so2
//        case "/":
//            return so1 / so2
//        default:
//            return 0;
//        }
//    }
//
//    func thayThe(chuoiBD:String, viTriKTChuoi1:Int, viTriBDChuoi2:Int, chuoiNoi:String) -> String {
//        var chuoi1:String = ""
//        var chuoi2:String = ""
//        if(viTriKTChuoi1 != -1) {
//            let kiTuKTChuoi1 = chuoiBD.index(chuoiBD.startIndex, offsetBy: viTriKTChuoi1)
//            chuoi1 = String(chuoiBD[..<kiTuKTChuoi1])
//        }
//        if(viTriBDChuoi2 != -1) {
//            let kiTuBDChuoi2 = chuoiBD.index(chuoiBD.startIndex, offsetBy: viTriBDChuoi2)
//            chuoi2 = String(chuoiBD[kiTuBDChuoi2...])
//        }
//        let chuoi = chuoi1 + chuoiNoi + chuoi2
//        return String(chuoi)
//    }
//
//    func thucHien(baiToan:String) -> String {
//        giaTriBieuThuc = baiToan
//        for i in 0..<giaTriBieuThuc.count {
//            if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i) == "(") {
//                for j in i..<giaTriBieuThuc.count {
//                    if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == ")") {
//                        let kq = thucHien(baiToan: layChuoi(chuoiBD: giaTriBieuThuc,
//                                                            viTriBDCat: i+1, viTriKTCat: j-1))
//                        giaTriBieuThuc = thayThe(chuoiBD: giaTriBieuThuc,
//                                                 viTriKTChuoi1: i-1, viTriBDChuoi2: j+1, chuoiNoi: kq)
//                        break
//                    }
//                }
//            }
//        }
//
//        for var i in 0..<giaTriBieuThuc.count {
//            if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i) == "*" ||
//                layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i) == "/") {
//                var viTriBD = 0
//                var viTriKT = 0
//
//                var so1:Double = 0
//                for j in (0..<i).reversed() {
//                    if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "+" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "-" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "(" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == ")") {
//                        so1 = laySo(viTriBD: j, doDai: i-j)
//                        viTriBD = j
//                        break
//                    }
//                    so1 = laySo(viTriBD: 0, doDai: i)
//                }
//
//                var so2:Double = 0
//                for j in i+1..<giaTriBieuThuc.count {
//                    if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "+" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "-" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "*" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "/" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "(" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == ")") {
//                        so2 = laySo(viTriBD: j, doDai: j-i)
//                        viTriKT = 2 * j - i
//                        break
//                    }
//                    so2 = laySo(viTriBD: j, doDai: giaTriBieuThuc.count-i-1)
//                }
//                let ketQua = tinhToan(so1: so1, so2: so2, phepTinh: layChuoi(chuoiBD: giaTriBieuThuc,
//                                                                             viTriBDCat: i, viTriKTCat: i))
//                giaTriBieuThuc = thayThe(chuoiBD: giaTriBieuThuc,
//                                        viTriKTChuoi1: viTriBD, viTriBDChuoi2: viTriKT,
//                                        chuoiNoi: String(ketQua))
//                i = viTriBD
//            }
//        }
//
//        for var i in 0..<giaTriBieuThuc.count {
//            if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i) == "+" ||
//                layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i) == "-") {
//                var viTriKT = 0
//
//                let so1:Double = laySo(viTriBD: 0, doDai: i)
//
//                var so2:Double = 0
//                for j in i+1..<giaTriBieuThuc.count {
//                    if(layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "+" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "-" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "*" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "/" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == "(" ||
//                        layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: j, viTriKTCat: j) == ")") {
//                        so2 = laySo(viTriBD: i+1, doDai: j-i-1)
//                        viTriKT = j
//                        break
//                    }
//                    if(j == giaTriBieuThuc.count - 1) {
//                        so2 = laySo(viTriBD: i+1, doDai: giaTriBieuThuc.count-i-1)
//                        viTriKT = -1
//                    }
//                }
//                let toanTu = layChuoi(chuoiBD: giaTriBieuThuc, viTriBDCat: i, viTriKTCat: i)
//                let ketQua = tinhToan(so1: so1, so2: so2, phepTinh: toanTu)
//                giaTriBieuThuc = thayThe(chuoiBD: giaTriBieuThuc,
//                                        viTriKTChuoi1: -1, viTriBDChuoi2: viTriKT,
//                                        chuoiNoi: String(ketQua))
//                i = 0
//            }
//        }
//
//        kiTu1 = true
//        return giaTriBieuThuc
//    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    var userIsInTheMiddleOfTyping = false
    private var displayValue : Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            displayLabel.text = newValue.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", newValue) : String(newValue)
        }
    }
    
    private var calculate = Calculate()
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! == "," ? "." : sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = displayLabel.text!
            if Double(textCurrentlyInDisplay + digit) != nil {
                displayLabel.text = textCurrentlyInDisplay + digit
            }
        } else {
            displayLabel.text = digit
            clearButton.setTitle("C", for: .normal)
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            calculate.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematiclSymbol = sender.currentTitle {
            // Debug
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
            print("")
            print(formatter.string(from: currentDateTime))
            print("***New Operation***\nmathematiclSymbol: \(mathematiclSymbol)")
            // End debug
            
            calculate.performOperation(mathematiclSymbol)
        }
        displayValue = calculate.result
        displayDescription()
    }
    
    @IBAction private func clearOrClearAll(_ sender: UIButton) {
        displayLabel.text = "0"
        if sender.currentTitle == "C" {
            userIsInTheMiddleOfTyping = false
            sender.setTitle("AC", for: .normal)
        } else {
            calculate.clear()
            descriptionLabel.text = ""
        }
    }
    
    func displayDescription() {
        descriptionLabel.text = calculate.description + (calculate.resultIsPending ? "..." : " =")
    }
}

