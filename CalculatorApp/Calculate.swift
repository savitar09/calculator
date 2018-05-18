//
//  Calculate.swift
//  CalculatorApp
//
//  Created by Tuan SPK on 5/4/18.
//  Copyright © 2018 Tuan SPK. All rights reserved.
//

import Foundation

class Calculate {
    private var chuongTrinhTrong = [String]()
    
    private var bieuThuc: Double?
    private var bieuThucMoTa = ""
    
    private var chuongTrinhTruocDauNgoacDon = [Any]()
    private var chuongTrinhTruocDauNgoacDonBieuThucMoTa: [Any] = []
    
    private var truocChuongTrinhTinhToanNhiPhan = [phepTinhNhiPhanDangChoXuLy]()
    private var truocKhiBieuThucMoTaTinhToanNhiPhan: [String] = []
    
    private var dangXuLy: phepTinhNhiPhanDangChoXuLy?
    private struct phepTinhNhiPhanDangChoXuLy {
        var hamNhiPhan: (Double, Double) -> Double
        var toanTuDauTien: Double
        var moTaHamTinhToan: ((String, String) -> String)?
        var moTaToanTu: String?
        var uuTien: Int
    }
    
    var ketQuaXuLy: Bool {
        get {
            return dangXuLy != nil || !chuongTrinhTruocDauNgoacDon.isEmpty || !chuongTrinhTruocDauNgoacDonBieuThucMoTa.isEmpty || !truocChuongTrinhTinhToanNhiPhan.isEmpty
        }
    }
    
    var moTa: String {
        get {
            if ketQuaXuLy && dangXuLy != nil, dangXuLy!.moTaHamTinhToan != nil && dangXuLy!.moTaToanTu != nil {
                print("truocKhiBieuThucMoTaTinhToanNhiPhan: \(truocKhiBieuThucMoTaTinhToanNhiPhan)")
                let dieuKienBieuThucMoTa = dangXuLy!.moTaToanTu != bieuThucMoTa && dangXuLy?.moTaToanTu != "(\(bieuThucMoTa))" ? bieuThucMoTa : ""
                let truocDauNgoacDon = chuongTrinhTruocDauNgoacDonBieuThucMoTa.reduce("") {
                    var toAdd = ""
                    if let luuTinhToanDangXuLy = $1 as? [String] {
                        toAdd = luuTinhToanDangXuLy.reduce("") {$0 + $1}
                    } else {
                        toAdd = $1 as! String
                    }
                    return $0 + toAdd
                }
                print("count: \(chuongTrinhTruocDauNgoacDonBieuThucMoTa.count)")
                print(chuongTrinhTruocDauNgoacDonBieuThucMoTa)
                return truocDauNgoacDon + truocKhiBieuThucMoTaTinhToanNhiPhan.reduce("") {$0 + $1} + dangXuLy!.moTaHamTinhToan!(dangXuLy!.moTaToanTu!, dieuKienBieuThucMoTa)
            } else {
                print("truocKhiBieuThucMoTaTinhToanNhiPhan: \(truocKhiBieuThucMoTaTinhToanNhiPhan)")
                let truocDauNgoacDon = chuongTrinhTruocDauNgoacDonBieuThucMoTa.reduce("") {
                    var toAdd = ""
                    if let luuTinhToanDangXuLy = $1 as? [String] {
                        toAdd = luuTinhToanDangXuLy.reduce("") {$0 + $1}
                    } else {
                        toAdd = $1 as! String
                    }
                    return $0 + toAdd
                }
                print("count: \(chuongTrinhTruocDauNgoacDonBieuThucMoTa.count)")
                print(chuongTrinhTruocDauNgoacDonBieuThucMoTa)
                return truocDauNgoacDon + truocKhiBieuThucMoTaTinhToanNhiPhan.reduce("") {$0 + $1} + bieuThucMoTa
            }
        }
    }
    
    private enum phepToan {
        case constant(Double)
        case constantGenerated(by: () -> Double)
        case tinhToanThuanTuy(phuongThuc: (Double) -> Double, hamTinhToan: (String) -> String, dauNgoacDonMacDinh: Bool)
        case tinhToanNhiPhan(phuongThuc: (Double, Double) -> Double, hamTinhToan: (String, String) -> String, uuTien: Int)
        case ketQua
        case moNgoacDon
        case dongNgoacDon
    }
    
    private var tinhToan: [String: phepToan] = [
        "%" : phepToan.tinhToanThuanTuy(phuongThuc: {$0 / 100}, hamTinhToan: {"\($0)%"}, dauNgoacDonMacDinh: false),
        "log₂" : phepToan.tinhToanThuanTuy(phuongThuc: {log2($0)}, hamTinhToan: {"log₂(\($0))"}, dauNgoacDonMacDinh: true),
        "sin" : phepToan.tinhToanThuanTuy(phuongThuc: {__sinpi($0 / 180)}, hamTinhToan: {"sin(\($0))"}, dauNgoacDonMacDinh: true),
        "cos" : phepToan.tinhToanThuanTuy(phuongThuc: {__cospi($0 / 180)}, hamTinhToan: {"cos(\($0))"}, dauNgoacDonMacDinh: true),
        "×" : phepToan.tinhToanNhiPhan(phuongThuc: {$0 * $1}, hamTinhToan: {"\($0) × \($1)"}, uuTien: 1),
        "÷" : phepToan.tinhToanNhiPhan(phuongThuc: {$0 / $1}, hamTinhToan: {"\($0) / \($1)"}, uuTien: 1),
        "+" : phepToan.tinhToanNhiPhan(phuongThuc: {$0 + $1}, hamTinhToan: {"\($0) + \($1)"}, uuTien: 0),
        "−" : phepToan.tinhToanNhiPhan(phuongThuc: {$0 - $1}, hamTinhToan: {"\($0) - \($1)"}, uuTien: 0),
        "=" : phepToan.ketQua,
        "(" : phepToan.moNgoacDon,
        ")" : phepToan.dongNgoacDon
    ]
    
    var ketQua: Double {
        get {
            return bieuThuc ?? 0
        }
    }
    
    func xoaBo(all: Bool = true) {
        dangXuLy = nil
        if all {
            chuongTrinhTrong.removeAll()
            chuongTrinhTruocDauNgoacDon.removeAll()
            chuongTrinhTruocDauNgoacDonBieuThucMoTa = []
            bieuThuc = nil
            bieuThucMoTa = ""
            truocChuongTrinhTinhToanNhiPhan = []
            truocKhiBieuThucMoTaTinhToanNhiPhan = []
        }
    }
    
    func caiDatToanTu(_ toanTu: Double) {
        bieuThuc = toanTu
        chuongTrinhTrong.append("\(toanTu)")
        bieuThucMoTa = String(format: "%g", toanTu)
    }
    
    private func moTaDieuKienGoiBieuThuc(uuTien: Int? = nil) -> String {
        if !ketQuaXuLy, (uuTien != nil ? uuTien! > 0 : true) {
            if Double(bieuThucMoTa) == nil {
                if chuongTrinhTrong.count > 1 {
                    let hamPhanTuThu2CuoiCung = chuongTrinhTrong[chuongTrinhTrong.count - 2]
                    if let hamPhanTuThu2 = tinhToan[hamPhanTuThu2CuoiCung], case .tinhToanThuanTuy(_, _, _) = hamPhanTuThu2 {
                        if uuTien != nil {
                            return "\(bieuThucMoTa == "" ? "0" : bieuThucMoTa)"
                        }
                    }
                }
                
                if let kyTuDauTien = bieuThucMoTa.characters.first,
                    let kyTuCuoiCung = bieuThucMoTa.characters.last,
                    (String(kyTuDauTien) != "(" || String(kyTuCuoiCung) != ")") {
                    return "(\(bieuThucMoTa == "" ? "0" : bieuThucMoTa))"
                }
            }
        }
        return "\(bieuThucMoTa == "" ? "0" : bieuThucMoTa)"
    }
    
    private func thucThiPhepToanNhiPhanDangChoXuLy() {
        
        if let dangXuLy = self.dangXuLy {
            bieuThuc = dangXuLy.hamNhiPhan(dangXuLy.toanTuDauTien, bieuThuc!)
            if let moTaToanTu = dangXuLy.moTaToanTu, let moTaHamTinhToan = dangXuLy.moTaHamTinhToan {
                print("moTa phuongThuc: \(dump(moTaHamTinhToan))")
                print("moTa toanTu: \(moTaToanTu)")
                bieuThucMoTa = moTaHamTinhToan(moTaToanTu, "\(bieuThucMoTa)")
            }
            self.dangXuLy = nil
        }
    }
    
    func thucHienTinhToan(_ kyHieuPhepToan: String) {
        chuongTrinhTrong.append(kyHieuPhepToan)
        
        if let phepToan = tinhToan[kyHieuPhepToan] {
            switch phepToan {
            case .constant(let value):
                bieuThuc = value
                bieuThucMoTa = kyHieuPhepToan
            case .constantGenerated(let phuongThuc):
                bieuThuc = phuongThuc()
                bieuThucMoTa = kyHieuPhepToan
            case .tinhToanThuanTuy(let bieuThucThuanTuy, let moTaHamTinhToan, let dauNgoacDonMacDinh):
                if chuongTrinhTrong.count > 2 {
                    let hamPhanTuThu2CuoiCung = chuongTrinhTrong[chuongTrinhTrong.count - 2]
                    if let hamPhanTuThu2 = tinhToan[hamPhanTuThu2CuoiCung], case .tinhToanNhiPhan(_, _, _) = hamPhanTuThu2 {
                        dangXuLy = nil
                        chuongTrinhTrong.remove(at: chuongTrinhTrong.count - 2)
                        debugPrint("Binary phepToan is followed by another phepToan, so binary phepToan will been removed")
                    }
                }
                self.bieuThuc = bieuThucThuanTuy(bieuThuc ?? 0)
                print("phepToanThuanTuy bieuThuc: \(self.bieuThuc)")
                bieuThucMoTa = moTaHamTinhToan(dauNgoacDonMacDinh ? (bieuThucMoTa == "" ? "0" : bieuThucMoTa) : self.moTaDieuKienGoiBieuThuc())
            case .tinhToanNhiPhan(let phuongThuc, let moTaHamTinhToan, let uuTienHienTai):
                if chuongTrinhTrong.count > 1 {
                    let hamPhanTuThu2CuoiCung = chuongTrinhTrong[chuongTrinhTrong.count - 2]
                    if let hamPhanTuThu2 = tinhToan[hamPhanTuThu2CuoiCung], case .tinhToanNhiPhan(_, _, _) = hamPhanTuThu2 {
                        dangXuLy?.hamNhiPhan = phuongThuc
                        dangXuLy?.moTaHamTinhToan = moTaHamTinhToan
                        dangXuLy?.uuTien = uuTienHienTai
                        chuongTrinhTrong.remove(at: chuongTrinhTrong.count - 2)
                        debugPrint("phepToan is followed by phepToan, so last phepToan has been ignored")
                        break
                    }
                }
                if let dangXuLy = dangXuLy, dangXuLy.uuTien < uuTienHienTai {
                    print("1. truocKhiBieuThucMoTaTinhToanNhiPhan: \(truocKhiBieuThucMoTaTinhToanNhiPhan)")
                    truocKhiBieuThucMoTaTinhToanNhiPhan.append(dangXuLy.moTaHamTinhToan!(dangXuLy.moTaToanTu!, ""))
                    truocChuongTrinhTinhToanNhiPhan.append(dangXuLy)
                    
                    print("2. truocKhiBieuThucMoTaTinhToanNhiPhan: \(truocKhiBieuThucMoTaTinhToanNhiPhan)")
                } else {
                    thucThiPhepToanNhiPhanDangChoXuLy()
                    if !truocChuongTrinhTinhToanNhiPhan.isEmpty {
                        for index in 0..<truocChuongTrinhTinhToanNhiPhan.count {
                            print("index: \(index)")
                            let dangXuLyDuocLuu = truocChuongTrinhTinhToanNhiPhan.last!
                            if dangXuLyDuocLuu.uuTien < uuTienHienTai {
                                break
                            }
                            bieuThuc = dangXuLyDuocLuu.hamNhiPhan(dangXuLyDuocLuu.toanTuDauTien, (bieuThuc ?? 0))
                            truocChuongTrinhTinhToanNhiPhan.removeLast()
                            bieuThucMoTa = truocKhiBieuThucMoTaTinhToanNhiPhan.removeLast() + bieuThucMoTa
                        }
                    }
                }
                dangXuLy = phepTinhNhiPhanDangChoXuLy(
                    hamNhiPhan: phuongThuc, toanTuDauTien: bieuThuc ?? 0,
                    moTaHamTinhToan: moTaHamTinhToan, moTaToanTu: self.moTaDieuKienGoiBieuThuc(uuTien: uuTienHienTai),
                    uuTien: uuTienHienTai)
            case .ketQua:
                print("ketQua: \(chuongTrinhTrong)")
                thucThiPhepToanNhiPhanDangChoXuLy()
                if !truocChuongTrinhTinhToanNhiPhan.isEmpty {
                    let _ = truocChuongTrinhTinhToanNhiPhan.reversed().map { bieuThuc = $0.hamNhiPhan($0.toanTuDauTien, bieuThuc!) }
                }
                bieuThucMoTa = truocKhiBieuThucMoTaTinhToanNhiPhan.reduce("") {$0 + $1} + bieuThucMoTa
                truocKhiBieuThucMoTaTinhToanNhiPhan.removeAll()
                truocChuongTrinhTinhToanNhiPhan.removeAll()
                if !chuongTrinhTruocDauNgoacDon.isEmpty {
                    chuongTrinhTrong.removeLast()
                    thucHienTinhToan(")")
                }
                
            case .moNgoacDon:
                print("***.moNgoacDon***")
                print("bieuThuc in parethesis: \(bieuThuc)")
                if chuongTrinhTrong.count > 1 {
                    let hamPhanTuThu2CuoiCung = chuongTrinhTrong[chuongTrinhTrong.count - 2]
                    var laPhepToanNhiPhan = false
                    if let tinhToanTrongNgoacDon = tinhToan[hamPhanTuThu2CuoiCung], case .tinhToanNhiPhan(_, _, _) = tinhToanTrongNgoacDon {
                        laPhepToanNhiPhan = true
                    }
                    if hamPhanTuThu2CuoiCung == "=" || laPhepToanNhiPhan {
                        if !truocChuongTrinhTinhToanNhiPhan.isEmpty {
                            chuongTrinhTruocDauNgoacDon.append( truocChuongTrinhTinhToanNhiPhan as Any )
                            truocChuongTrinhTinhToanNhiPhan.removeAll()
                            chuongTrinhTruocDauNgoacDonBieuThucMoTa.append( truocKhiBieuThucMoTaTinhToanNhiPhan )
                            truocKhiBieuThucMoTaTinhToanNhiPhan.removeAll()
                        }
                        if let dangXuLy = dangXuLy, let moTaHamDangXuLy = dangXuLy.moTaHamTinhToan, let moTaToanTuDangXuLy = dangXuLy.moTaToanTu {
                            chuongTrinhTruocDauNgoacDon.append( self.dangXuLy as Any)
                            chuongTrinhTruocDauNgoacDonBieuThucMoTa.append( moTaHamDangXuLy(moTaToanTuDangXuLy, "(") )
                        } else {
                            chuongTrinhTruocDauNgoacDonBieuThucMoTa.append("(")
                        }
                        bieuThucMoTa = ""
                        dangXuLy = nil
                    } else {
                        chuongTrinhTrong.removeLast()
                    }
                } else {
                    chuongTrinhTruocDauNgoacDonBieuThucMoTa.append("(")
                }
                print("savedBeforeParenthesis: \(chuongTrinhTruocDauNgoacDon)")
            case .dongNgoacDon:
                if chuongTrinhTruocDauNgoacDon.isEmpty && chuongTrinhTruocDauNgoacDonBieuThucMoTa.isEmpty {
                    chuongTrinhTrong.removeLast()
                    break
                }
                bieuThucMoTa += ")"
                thucThiPhepToanNhiPhanDangChoXuLy()
                if !truocChuongTrinhTinhToanNhiPhan.isEmpty {
                    let _ = truocChuongTrinhTinhToanNhiPhan.reversed().map { bieuThuc = $0.hamNhiPhan($0.toanTuDauTien, bieuThuc!) }
                    truocChuongTrinhTinhToanNhiPhan.removeAll()
                    self.bieuThucMoTa = truocKhiBieuThucMoTaTinhToanNhiPhan.reduce("") {$0 + $1} + self.bieuThucMoTa
                    truocKhiBieuThucMoTaTinhToanNhiPhan.removeAll()
                }
                if !chuongTrinhTruocDauNgoacDon.isEmpty && !chuongTrinhTruocDauNgoacDonBieuThucMoTa.isEmpty {
                    if let choXuLyTruocDauNgoacDon = chuongTrinhTruocDauNgoacDon.removeLast() as? phepTinhNhiPhanDangChoXuLy {
                        self.dangXuLy = choXuLyTruocDauNgoacDon
                        chuongTrinhTruocDauNgoacDonBieuThucMoTa.removeLast()
                    }
                    if !chuongTrinhTruocDauNgoacDon.isEmpty, let chuongTrinhTinhToanNhiPhanTruocDauNgoacDon = chuongTrinhTruocDauNgoacDon.removeLast() as? [phepTinhNhiPhanDangChoXuLy] {
                        self.truocChuongTrinhTinhToanNhiPhan = chuongTrinhTinhToanNhiPhanTruocDauNgoacDon
                        
                        if let bieuThucMoTaTinhToanNhiPhanTruocDauNgoacDon = chuongTrinhTruocDauNgoacDonBieuThucMoTa.removeLast() as? [String] {
                            self.truocKhiBieuThucMoTaTinhToanNhiPhan = bieuThucMoTaTinhToanNhiPhanTruocDauNgoacDon + self.truocKhiBieuThucMoTaTinhToanNhiPhan
                        }
                    }
                    self.bieuThucMoTa = "(" + self.bieuThucMoTa
                } else if !chuongTrinhTruocDauNgoacDonBieuThucMoTa.isEmpty, let moTaTruocDauNgoacDon = chuongTrinhTruocDauNgoacDonBieuThucMoTa.removeLast() as? String {
                    bieuThucMoTa = moTaTruocDauNgoacDon + bieuThucMoTa
                }
            }
        }
    }
    
}
