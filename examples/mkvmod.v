import os
import term
import strings
import semver
import licenseid

struct Module {
pub mut:
	name        string
	description string
	version     string = '0.0.0'
	license     string = 'MIT'
	author      string
}

fn make() string {
	eprintln('Create new v.mod, press ^C to quit')
	mut manifest := Module{}
	for {
		name := os.input(term.bold('Name: '))
		if !name.is_blank() {
			manifest.name = name
			break
		}
		eprintln(term.bright_red('Name cannot be blank'))
	}
	manifest.description = os.input(term.bold('Description: '))
	for {
		version := os.input(term.bold('Version: '))
		if version.is_blank() {
			break
		}
		if semver.is_valid(version) {
			manifest.version = version
			break
		}
		eprintln(term.bright_red('${version} violates semantic versioning rules, see https://semver.org/ for info'))
	}
	manifest.author = os.input(term.bold('Author: '))
	for {
		license := os.input(term.bold('License: '))
		if license.is_blank() {
			break
		}
		if _ := licenseid.query(license) {
			manifest.license = license
			break
		}
		eprintln(term.bright_red('${license} is not valid SPDX license identifier, see https://spdx.org/licenses/ for info'))
	}
	vmod := gen_vmod(manifest)
	eprintln(term.bright_blue(vmod))
	if os.input(term.bold('This is correct? ')).to_lower() in ['y', 'yes'] {
		return vmod
	}
	eprintln(term.bold(term.bright_red('Aborted')))
	exit(1)
}

fn gen_vmod(m Module) string {
	mut b := strings.new_builder(200)
	b.writeln('Module {')
	b.writeln("\tname: '${m.name}'")
	b.writeln("\tdescription: '${m.description}'")
	b.writeln("\tversion: '${m.version}'")
	b.writeln("\tauthor: '${m.author}'")
	b.writeln("\tlicense: '${m.license}'")
	b.writeln('\tdependencies: []')
	b.writeln('}')
	return b.str()
}

fn main() {
	if !os.exists('v.mod') {
		vmod := make()
		os.write_file('v.mod', vmod) or {
			eprintln(err)
			exit(1)
		}
		eprintln(term.bright_green('v.mod is done'))
		return
	}
	eprintln(term.bright_yellow('v.mod is already done'))
}
