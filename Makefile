beardropper: src/bearDropper.sh src/bddb.sh
	sed -n '1,/_LOAD_MEAT_/p' src/bearDropper.sh | fgrep -v _MEAT_ > beardropper
	sed -n '/_BEGIN_MEAT_/,/_END_MEAT_/p' src/bddb.sh | fgrep -v _MEAT_ >> beardropper
	sed -n '/_LOAD_MEAT_/,$$p' src/bearDropper.sh | fgrep -v _MEAT_ >> beardropper
	chmod 755 beardropper

clean:
	rm beardropper
