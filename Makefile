archive:
	xcodebuild -workspace CLI-DB.xcworkspace -scheme CLI-DB archive -archivePath ./archive

make-symbolic:
	sudo ln -s /Users/s06100/go/src/github.com/s2mr/CLI-DB/archive.xcarchive/Products/usr/local/bin/CLI-DB /usr/local/bin/memo
