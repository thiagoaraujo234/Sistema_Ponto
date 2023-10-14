//
//  swift
//  SOL Ponto
//
//  Created by Sósthenes Oliveira Lima on 13/10/23.
//

import Foundation
import UIKit

class Recibo: NSObject {
    
    var id: UUID
    var status: Bool
    var data: Date
    var foto: UIImage
    
    init(status: Bool, data: Date, foto: UIImage) {
        self.id = UUID()
        self.status = status
        self.data = data
        self.foto = foto
    }
}
