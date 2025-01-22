import licenseid

fn test_query() {
	l := licenseid.query('GPL-3.0-or-later')!
	assert l.license_id == 'GPL-3.0-or-later'
}

fn test_details() {
	l := licenseid.query('Unlicense')!
	details := l.details()!
	assert details.name == 'The Unlicense'
}
