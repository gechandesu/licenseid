module licenseid

import json
import net.http

const licenses_file = $embed_file('licenselist.min.json')
const licenses = json.decode(LicenseList, licenses_file.to_string()) or { LicenseList{} }

struct LicenseList {
	licenses []License
}

pub struct License {
pub:
	license_id               string @[json: licenseId]
	name                     string
	reference                string
	reference_number         int      @[json: referenceNumber]
	details_url              string   @[json: detailsUrl]
	is_osi_approved          bool     @[json: isOsiApproved]
	is_deprecated_license_id bool     @[json: isDeprecatedLicenseId]
	see_also                 []string @[json: seeAlso]
}

pub struct LicenseDetails {
pub:
	license_id               string @[json: licenseId]
	name                     string
	license_text             string      @[json: licenseText]
	license_text_html        string      @[json: licenseTextHtml]
	license_template         string      @[json: standardLicenseTemplate]
	is_osi_approved          bool        @[json: isOsiApproved]
	is_deprecated_license_id bool        @[json: isDeprecatedLicenseId]
	cross_ref                []Reference @[json: crossRef]
	see_also                 []string    @[json: seeAlso]
}

pub struct Reference {
pub:
	match           string
	url             string
	is_valid        bool @[json: isValid]
	is_live         bool @[json: isLive]
	is_way_backlink bool @[json: isWayBackLink]
	timestamp       string
	order           int
}

// details fetches the license details object from SPDX data file using the
// details_url. Requires access to public network.
pub fn (l License) details() !LicenseDetails {
	response := http.get(l.details_url)!
	details := json.decode(LicenseDetails, response.body)!
	return details
}

// query returns license object from embedded SPDX license list data file.
pub fn query(license_id string) !License {
	for license in licenses.licenses {
		if license.license_id == license_id {
			return license
		}
	}
	return error('${license_id} is not valid SPDX license ID')
}
