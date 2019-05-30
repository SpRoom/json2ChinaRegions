//
//  FileController.swift
//  json2ChinaRegions
//
//  Created by ios-spec on 2019/5/30.
//  Copyright © 2019 mhly. All rights reserved.
//

import Cocoa
import FileKit

class FileController {

    public static let shared = FileController()
    private init() {}


    let manager = FileManager.default

}

extension FileController {

    func exportFile(path: String, data: String) {

        var filePath: Path = "\(path)"
        let file = TextFile(path: filePath, encoding: .utf8)


        if !file.exists {
            do {
                try file.create()
            } catch let e as FileKitError {
                fileKitErrorHandler(error: e)
            } catch let err {
                print(err)
            }

        }

//        guard filePath.isReadable && filePath.isWritable else { return }


        do {
            try file.write(data, atomically: true)
        } catch let e as FileKitError {
            fileKitErrorHandler(error: e)
        } catch let err {
            print(err)
        }

    }
}


extension FileController {

    func fileKitErrorHandler(error: FileKitError, path: String? = nil) {


        switch error {
        case .fileDoesNotExist(path: let path):
            print("file dose not exist, path -- \(path.rawValue)")
        case .fileAlreadyExists(path: let path):
            print("file already exists, path -- \(path.rawValue)")
        case .changeDirectoryFail(from: let from, to: let to, error: let e):
            print("change dir failed, from -- \(from.rawValue) to -- \(to.rawValue), reason is -- \(e.localizedDescription)")
        case .createSymlinkFail(from: let from, to: let to, error: let e):
            print("create syslink failed, from -- \(from.rawValue) to -- \(to.rawValue), reason is -- \(e.localizedDescription)")
        case .createHardlinkFail(from: let from, to: let to, error: let e):
            print("create hardlink failed, from -- \(from.rawValue) to -- \(to.rawValue), reason is -- \(e.localizedDescription)")
        case .createFileFail(path: let path):
            print("create file failed, path -- \(path.rawValue)")
        case .createDirectoryFail(path: let path, error: let e):
            print("create dir failed, path -- \(path.rawValue), reason is -- \(e.localizedDescription)")
        case .deleteFileFail(path: let path, error: let e):
            print("delete file failed, path -- \(path.rawValue), reason is -- \(e.localizedDescription)")
        case .readFromFileFail(path: let path, error: let e):
            print("read file failed, path -- \(path.rawValue), reason is -- \(e.localizedDescription)")
        case .writeToFileFail(path: let path, error: let e):
            print("write file failed, path -- \(path.rawValue), reason is -- \(e.localizedDescription)")
        case .moveFileFail(from: let from, to: let to, error: let e):
            print("move file failed, from -- \(from.rawValue) to -- \(to.rawValue), reason is -- \(e.localizedDescription)")
        case .copyFileFail(from: let from, to: let to, error: let e):
            print("copy file failed, from -- \(from.rawValue) to -- \(to.rawValue), reason is -- \(e.localizedDescription)")
        case .attributesChangeFail(path: let path, error: let e):
            print("change file failed, path -- \(path.rawValue), reason is -- \(e.localizedDescription)")

        }
    }

}
