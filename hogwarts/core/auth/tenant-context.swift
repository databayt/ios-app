import SwiftUI

/// Tenant context for multi-tenant isolation
/// Mirrors: src/lib/tenant-context.ts
/// CRITICAL: All API requests must include schoolId
@Observable
final class TenantContext {
    /// Current school ID (tenant identifier)
    var schoolId: String?

    /// Current school details
    var school: School?

    /// School subdomain
    var subdomain: String?

    /// Check if tenant context is valid
    var isValid: Bool {
        schoolId != nil
    }

    /// Set tenant from session
    func setTenant(schoolId: String, school: School? = nil) {
        self.schoolId = schoolId
        self.school = school
        if let domain = school?.domain {
            self.subdomain = domain
        }
    }

    /// Clear tenant (on logout)
    func clear() {
        schoolId = nil
        school = nil
        subdomain = nil
    }
}

/// School model for tenant context
/// Web API: GET /mobile/schools returns [{id, name, name_en, logo_url, domain}]
/// Full school details available via GET /mobile/admin/school
struct School: Codable, Identifiable {
    let id: String
    let name: String
    let nameEn: String?
    let logoUrl: String?
    let domain: String?

    // Extended fields (only present from /mobile/admin/school)
    let email: String?
    let phone: String?
    let plan: SchoolPlan?
    let maxStudents: Int?
    let maxTeachers: Int?

    enum SchoolPlan: String, Codable {
        case basic = "BASIC"
        case premium = "PREMIUM"
        case enterprise = "ENTERPRISE"
    }
}
