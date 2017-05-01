BUILD_DIR = build
CHECK_SPELL =
DIST_DIR = $(shell git describe --tags)


present: $(BUILD_DOCUMENT)
	nohup pdfpc $(BUILD_DOCUMENT) &> /dev/null &
