DOC_DIR = doc

SPDX_LICENSE_LIST_FILE = licenses.json
SPDX_LICENSE_LIST_FILE_MIN = licenses.min.json
SPDX_LICENSE_LIST_FILE_TMP = /tmp/licenses.json.new
SPDX_LICENSE_LIST_JSON_URL = https://spdx.org/licenses/licenses.json

licenses:
	wget -q -O $(SPDX_LICENSE_LIST_FILE_TMP) $(SPDX_LICENSE_LIST_JSON_URL)
	if ! diff $(SPDX_LICENSE_LIST_FILE) $(SPDX_LICENSE_LIST_FILE_TMP) >/dev/null 2>&1; \
		then mv -v $(SPDX_LICENSE_LIST_FILE_TMP) $(SPDX_LICENSE_LIST_FILE); \
	fi
	jq -c . < $(SPDX_LICENSE_LIST_FILE) > $(SPDX_LICENSE_LIST_FILE_MIN)

doc:
	v doc -f html -m . -o $(DOC_DIR)

serve: clean doc
	v -e "import net.http.file; file.serve(folder: '$(DOC_DIR)')"

clean:
	rm -r $(DOC_DIR) || true
