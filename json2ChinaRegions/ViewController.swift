//
//  ViewController.swift
//  json2ChinaRegions
//
//  Created by ios-spec on 2019/5/30.
//  Copyright © 2019 mhly. All rights reserved.
//

import Cocoa
import FileKit
import HandyJSON
import SwiftyJSON

class ViewController: NSViewController {

    var provinces: [AreaTypes] = []
    var citys: [AreaTypes] = []
    var country: [AreaTypes] = []

    var provinceJson = ""
    var cityJson = ""
    var countryJson = ""
    var townJson = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        loadResources()

    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }


    @IBAction func startExport(_ sender: Any) {

        let filePath = "/Users/zyt/Desktop/json/test.json"

        guard !filePath.isEmpty else { return }

        if let text = generatStr() {

            FileController.shared.exportFile(path: filePath, data: text)
        }
    }


    func generatStr() -> String? {

        if let provincesOp = [AreaTypes].deserialize(from: provinceJson) {
            let provinces = provincesOp.compactMap { $0 }

            let citysJSON = JSON(parseJSON: cityJson)
            let countryJSON = JSON(parseJSON: countryJson)
            let townJSON = JSON(parseJSON: townJson)


            var provincesArr: [Province] = []

            for area in provinces {

                var citys: [City] = []

                if let cityArr = citysJSON[area.id].array {

                    for city in cityArr {

                        // id name province

                        if let cityId = city["id"].string {

                            guard let cityName = city["name"].string else { continue }


                            var countrys: [String] = []

                            if let countryArr = countryJSON[cityId].array {

                                for country in countryArr {

                                    // id name city

                                    if let name = country["name"].string {
                                        countrys.append(name)
                                    }
                                }
                            }

                            if let townArr = townJSON[cityId].array {

                                for town in townArr {

                                    if let name = town["name"].string {
                                        countrys.append(name)
                                    }
                                }
                            }

                            let city = City()
                            city.name = cityName
                            city.area = countrys
                            citys.append(city)
                        }
                    }
                }

                let province = Province()
                province.name = area.name
                province.city = citys
                provincesArr.append(province)
            }


            if  let resultStr = provincesArr.toJSONString(prettyPrint: true) {
                return resultStr
            }
            return nil

        }
        return nil
    }


    func loadResources() {
        if let regionFiles = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {

            for region in regionFiles {

                print(region.lastPathComponent)

                if region.lastPathComponent == "province.json" { parseProvince(region) }
                if region.lastPathComponent == "city.json" { parseCity(region) }
                if region.lastPathComponent == "country.json" { parseCountry(region) }
                if region.lastPathComponent == "town.json" { parseTown(region) }
            }

        }
    }

    func parseTown(_ url: URL) {
        if let json = readFile(url) {
            townJson = json
        }
    }

    func parseCountry(_ url: URL) {
        if let json = readFile(url) {
            countryJson = json
        }
    }

    func parseCity(_ url: URL) {

        if let json = readFile(url) {
            cityJson = json
        }
    }

    func parseProvince(_ url: URL) {

        if let json = readFile(url) {
            provinceJson = json
        }

    }

    func readFile(_ url: URL) -> String? {
        guard let filePath = Path(url: url) else { return nil }

        guard filePath.exists else {
            return nil
        }

        if filePath.isReadable {

            do {
                let file = TextFile(path: filePath)
                let content = try file.read()

                return content
            } catch {
                print(error)
            }
        }

        return nil
    }
}


class Province: HandyJSON {
    var name: String = ""
    var city: [City] = []

    required init() {}
}

class City: HandyJSON {
    var name: String = ""
    var area: [String] = []
    required init() {}
}

class AreaTypes: HandyJSON {

    var id: String = ""
    var name: String = ""

    required init() {}
}

class ParseTypes: HandyJSON {

    var key: String = ""
    var datas: [AreaTypes] = []

    required init() {}
}
