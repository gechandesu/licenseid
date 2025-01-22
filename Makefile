SRC_DIR = src
DOC_DIR = doc

SPDX_LICENSE_LIST_FILE = src/licenselist.json
SPDX_LICENSE_LIST_FILE_MIN = src/licenselist.min.json
SPDX_LICENSE_LIST_FILE_TMP = /tmp/licenselist.json.new
SPDX_LICENSE_LIST_JSON_URL = https://spdx.org/licenses/licenses.json

licenselist:
	wget -q -O $(SPDX_LICENSE_LIST_FILE_TMP) $(SPDX_LICENSE_LIST_JSON_URL)
	if ! diff $(SPDX_LICENSE_LIST_FILE) $(SPDX_LICENSE_LIST_FILE_TMP) >/dev/null 2>&1; \
		then mv -v $(SPDX_LICENSE_LIST_FILE_TMP) $(SPDX_LICENSE_LIST_FILE); \
	fi
	jq -c . < $(SPDX_LICENSE_LIST_FILE) > $(SPDX_LICENSE_LIST_FILE_MIN)

doc:
	v doc -f html -m ./$(SRC_DIR) -o $(DOC_DIR)

serve: clean doc
	v -e "import net.http.file; file.serve(folder: '$(DOC_DIR)')"

clean:
	rm -r $(DOC_DIR) || true
