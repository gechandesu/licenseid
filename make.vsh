#!/usr/bin/env -S v run

import build
import net.http

const source_url = 'https://spdx.org/licenses/licenses.json'

mut context := build.context(default: 'licenses.min.json')

context.artifact(
	name:       'licenses.json'
	help:       'SPDX licenses list in JSON format'
	should_run: |self| true
	run:        |self| http.download_file(source_url, self.name)!
)

context.artifact(
	name:       'licenses.min.json'
	help:       'The minified licenses.json ready for embedding (requires jq util)'
	depends:    ['licenses.json']
	should_run: |self| true
	run:        |self| system('jq -c . < licenses.json > ${self.name}')
)

context.run()
