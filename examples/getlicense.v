import os
import os.cmdline
import licenseid

const help_text = 'download license text from internet and apply width (80 by default)'
const usage_text = 'usage: getlicense [-help] [-w <width>] <license_id>'

fn main() {
	argv := os.args[1..]
	opts := cmdline.only_options(argv)
	mut args := cmdline.only_non_options(argv)
	mut width := 80
	for opt in opts {
		match true {
			opt in ['-h', '-help', '--help'] {
				println(help_text)
				println(usage_text)
				exit(0)
			}
			opt == '-w' {
				arg := cmdline.option(argv, '-w', '')
				if arg.int() <= 0 {
					eprintln('invalid width ${opt}')
					exit(2)
				}
				width = arg.int()
				args.delete(args.index(arg))
			}
			else {
				eprintln('unrecognized option ${opt}')
				exit(2)
			}
		}
	}
	if args.len != 1 {
		eprintln(usage_text)
		exit(2)
	}
	license := licenseid.query(args[0]) or {
		eprintln(err)
		exit(1)
	}
	details := license.details() or {
		eprintln(err)
		exit(1)
	}
	for line in details.license_text.split_into_lines() {
		if line == '' {
			println('')
		} else {
			println(line.wrap(width: width))
		}
	}
}
