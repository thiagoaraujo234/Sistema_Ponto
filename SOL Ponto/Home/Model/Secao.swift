//
//  swift
//  SOL Ponto
//
//  Created by Sósthenes Oliveira Lima on 13/10/23.
//

import Foundation

class Secao {
    
    // MARK: - Attributes
    
    static let shared = Secao()
    var listaDeRecibos: [Recibo] = []
    
    // MARK: - Struct Methods
    
    func addRecibos(_ recibo: Recibo) {
        listaDeRecibos.insert(recibo, at: 0)
    }
}
