//
//  DataManager.swift
//  Challenge_SoftMobile
//
//  Created by 蔡念澄 on 2022/6/16.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    func fetchJSONData(completion: @escaping (Result<[DataModel], Error>) -> Void) {
        if let url = URL(string: "https://smuat.megatime.com.tw/EAS/Apps/systex/hr_elearning/hr_elearning_20220602_181350.json") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(JSONData.self, from: data)
                        let allData = self.parseJSONData(jsonData)
                        completion(.success(allData))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func parseJSONData(_ jsonData: JSONData) -> [DataModel] {
        var allData = [DataModel]()
        for record in jsonData.DataList {
            let data = DataModel(
                title: record.title,
                content: record.content,
                imgURL: record.img
            )
            allData.append(data)
        }
        return allData
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(UIImage(named: "default"))
            }
        }.resume()
    }
}
