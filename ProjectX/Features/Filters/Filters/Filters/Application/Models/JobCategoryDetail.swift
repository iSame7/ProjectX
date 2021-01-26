//
//  JobCategoryDetail.swift
//  Filters
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

public class JobCategoryDetail {
    public var id: String?
    public var internalId: Int?
    public var name: String?
    public var slug: String?
    public var links: CategoryLinks?
    public var isSelected = false
}

public struct CategoryLinks {
    public var icon: String?
}
