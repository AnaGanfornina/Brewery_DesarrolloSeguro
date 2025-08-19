//
//  Status.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//


enum Status : Equatable{
    case none, loading, loaded, error(error: String)
}
