#!/bin/sh
# This is a testsuite.
PBUILDER_UML=/usr/bin/pbuilder-user-mode-linux

pbuilder-user-mode-linux test --configfile non-existing-configfile

if [ -x "${PBUILDER_UML}" ]; then
    for distribution in sid sarge; do
	pbuilder-user-mode-linux create --mirror  http://ring.asahi-net.or.jp/archives/linux/debian/debian --distribution "${distribution}" --uml-image $(pwd)/testimage --logfile pbuilder-user-mode-linux-create-${distribution}.log

	for PKG in dsh; do 
	    ( 
		mkdir testbuild
		cd testbuild
		apt-get source -d ${PKG}
	    )
	    pbuilder-user-mode-linux build --uml-image $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile pbuilder-user-mode-linux-build-${PKG}-${distribution}.log testbuild/${PKG}*.dsc
	done
	pbuilder-user-mode-linux execute --uml-image $(pwd)/testimage --logfile pbuilder-user-mode-linux-execute-${distribution}.log ../examples/execute_paramtest.sh test1 test2 test3
	rm -rf testbuild testimage
    done
fi



