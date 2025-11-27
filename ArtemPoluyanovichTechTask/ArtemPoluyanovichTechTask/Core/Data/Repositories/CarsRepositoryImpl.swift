//
//  CarsRepositoryImpl.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - CarsRepositoryImpl
final class CarsRepositoryImpl: CarsRepository {
    private let restService: RestServiceProtocol
    
    init(restService: RestServiceProtocol) {
        self.restService = restService
    }

    func fetchManufacturers(page: Int, pageSize: Int) async throws -> PagedResult<Manufacturer> {
        let request = ApiRequest(
            path: CarsRepositoryUrlPaths.manufacturers,
            queryParameters: [
                "page": String(page),
                "pageSize": String(pageSize)
            ],
            method: .GET,
        )
        
        do {
            let response: PaginatedResponse<[String: String]> = try await restService.send(request)
            let models = ManufacturerModel.fromWkdaDictionary(response.wkda)
            let entities = ManufacturerModel.toDomain(models)
            
            return PagedResult(
                items: entities,
                currentPage: response.page,
                totalPages: response.totalPageCount
            )
        } catch let error as NetworkError {
            throw ErrorMapper.toAppError(error)
        } catch {
            throw AppError.unknown(message: error.localizedDescription)
        }
    }
    
    func fetchMainTypes(manufacturerId: String, page: Int, pageSize: Int) async throws -> PagedResult<MainType> {
        let request = ApiRequest(
            path: CarsRepositoryUrlPaths.mainTypes,
            queryParameters: [
                "manufacturer": String(manufacturerId),
                "page": String(page),
                "pageSize": String(pageSize)
            ],
            method: .GET,
        )
        
        do {
            let response: PaginatedResponse<[String: String]> = try await restService.send(request)
            let models = MainTypeModel.fromWkdaDictionary(response.wkda)
            let entities = MainTypeModel.toDomain(models)
            
            return PagedResult(
                items: entities,
                currentPage: response.page,
                totalPages: response.totalPageCount
            )
        } catch let error as NetworkError {
            throw ErrorMapper.toAppError(error)
        } catch {
            throw AppError.unknown(message: error.localizedDescription)
        }
    }
}

// MARK: - CarsRepositoryUrlPaths
enum CarsRepositoryUrlPaths {
    static let manufacturers: String = "/car-types/manufacturer"
    static let mainTypes: String = "/car-types/main-types"
}
