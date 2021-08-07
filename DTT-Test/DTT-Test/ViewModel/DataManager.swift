//
//  DataManager.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 31.07.21.
//

import Foundation

struct DataManager {
    
    func fetchData(complation: @escaping ([House])->()){
        
        if let url = URL(string: "https://intern.docker-dev.d-tt.nl/api/house"){
            var request = URLRequest(url: url)
            request.addValue("98bww4ezuzfePCYFxJEWyszbUXc7dxRx", forHTTPHeaderField: "Access-Key")
            let dataTask = URLSession.shared.dataTask(with: request) {
                (data,response,error) in
                if let data = data {
                    do {
                        let houseJson = try JSONDecoder().decode([House].self, from: data)
                        complation(houseJson)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
 
}
