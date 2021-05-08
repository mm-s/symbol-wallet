STDFLAGS:=-std=c++20 -Wno-psabi
PREFIX:=/usr/local
DEBUGFLAGS:=-g -O0 ${STDFLAGS} -DDEBUG
RELEASEFLAGS:=-O3 ${STDFLAGS} -DNDEBUG
GOVUSER:=gov
GOVHOME:=/home/${GOVUSER}
DATADIR:=${GOVHOME}/.us
USGOV:=us-gov
USWALLET:=us-wallet
USBZ:=us-bz
LIBUSGOV:=libusgov
LIBUSWALLET:=libuswallet
LIBUSBZ:=libusbz
USHELP:=us-help
USSEEDS:=us-seeds
USPORTS:=us-ports
BCFG:=us
US:=us
CHANNEL:=1
DEFAULTDEBUG:=1
TORSERVER:=1
CXXFLAGS:=${DEBUGFLAGS}

ifeq (${DEFAULTDEBUG},1)
all: export CXXFLAGS:=${DEBUGFLAGS}
else
all: export CXXFLAGS:=${RELEASEFLAGS}
endif
all: targets

debug: export CXXFLAGS:=${DEBUGFLAGS}
debug: targets

release: export CXXFLAGS:=${RELEASEFLAGS}
release: targets

warndistr:
	if [ -f /var/us_nets ]; then grep "^${CHANNEL} ${US}" /var/us_nets > /dev/null || echo "V0FSTklORzogVGhpcyBicmFuZCBkb2VzIG5vdCBtYXRjaCB0aGUgaW5zdGFsbGVkIGJyYW5kIGF0IC92YXIvdXNfbmV0cy4K" | base64 -d; fi

targets: warndistr gov/${LIBUSGOV}.so wallet/${LIBUSWALLET}.so govx/${USGOV} walletx/${USWALLET} logtool/logtool bz/${LIBUSBZ}.so bzx/${USBZ}

wallet-debug: export CXXFLAGS:=${DEBUGFLAGS}
wallet-debug: wallet

wallet-release: export CXXFLAGS:=${RELEASEFLAGS}
wallet-release: wallet

gov: govx/${USGOV}
wallet: walletx/${USWALLET}

.ONESHELL:

ifeq (${DEFAULTDEBUG},1)
distr: debug
else
distr: release
endif
distr: export DISTRDIR:=distr
distr: distr-common

distr-common: | targets
	mkdir -p ${DISTRDIR}/gov
	install gov/${LIBUSGOV}.so ${DISTRDIR}/gov/
	mkdir -p ${DISTRDIR}/govx
	install govx/${USGOV} ${DISTRDIR}/govx/
	mkdir -p ${DISTRDIR}/wallet
	install wallet/${LIBUSWALLET}.so ${DISTRDIR}/wallet/
	mkdir -p ${DISTRDIR}/walletx
	install walletx/${USWALLET} ${DISTRDIR}/walletx/
	mkdir -p ${DISTRDIR}/bz
	install bz/${LIBUSBZ}.so ${DISTRDIR}/bz/
	mkdir -p ${DISTRDIR}/bzx
	install bzx/${USBZ} ${DISTRDIR}/bzx/
	mkdir -p ${DISTRDIR}/lib
	install gov/${LIBUSGOV}.so ${DISTRDIR}/lib/
	install wallet/${LIBUSWALLET}.so ${DISTRDIR}/lib/
	install bz/${LIBUSBZ}.so ${DISTRDIR}/lib/
	mkdir -p ${DISTRDIR}/bin
	install bin/${USHELP} ${DISTRDIR}/bin/
	install bin/node_info ${DISTRDIR}/bin/
	install bin/log_trimdir ${DISTRDIR}/bin/
	install bin/ush ${DISTRDIR}/bin/
	install bin/override_env ${DISTRDIR}/bin/
	install bin/gen_pub ${DISTRDIR}/bin/
	install bin/proc_1.1 ${DISTRDIR}/bin/
	install bin/${US}-upload_blob ${DISTRDIR}/bin/
	install bin/install_blob ${DISTRDIR}/bin/
	install bin/apply_blob ${DISTRDIR}/bin/
	install bin/${USPORTS} ${DISTRDIR}/bin/
	install bin/${USSEEDS} ${DISTRDIR}/bin/
	install bin/${US}_distr_make ${DISTRDIR}/bin/
	install bin/blob_extract_apk ${DISTRDIR}/bin/
	mkdir -p ${DISTRDIR}/logtool
	install logtool/logtool ${DISTRDIR}/logtool/
	mkdir -p ${DISTRDIR}/etc/systemd/system
	install etc/systemd/system/${USGOV}.service ${DISTRDIR}/etc/systemd/system/
	install etc/systemd/system/${USWALLET}.service ${DISTRDIR}/etc/systemd/system/
	mkdir -p ${DISTRDIR}/etc
	install etc/rc.local ${DISTRDIR}/etc/
	mkdir -p ${DISTRDIR}/etc/rc.local.d
	install etc/rc.local.d/${CHANNEL}_${US}_rclocal ${DISTRDIR}/etc/rc.local.d/
	install etc/999999999_${US}_rclocal ${DISTRDIR}/etc/rc.local.d/
	install etc/bash_aliases ${DISTRDIR}/etc/
	install etc/bash_profile ${DISTRDIR}/etc/
	if [ -f etc/nodes.distr${CHANNEL} ]; then cp etc/nodes.distr${CHANNEL} ${DISTRDIR}/etc/nodes.distr${CHANNEL}; fi
	if [ -f etc/nodes.distr ]; then cp etc/nodes.distr ${DISTRDIR}/etc/nodes.distr${CHANNEL}; fi
	install etc/motd_hdr ${DISTRDIR}/etc/
	install etc/${US}_motd ${DISTRDIR}/etc/
	install etc/config ${DISTRDIR}/etc/config
	mkdir -p ${DISTRDIR}/etc/cron.daily
	install etc/cron.daily/${USPORTS} ${DISTRDIR}/etc/cron.daily/
	install etc/cron.daily/${USSEEDS} ${DISTRDIR}/etc/cron.daily/
	install etc/cron.daily/install_blobs ${DISTRDIR}/etc/cron.daily/
	mkdir -p ${DISTRDIR}/var/${US}/commands/broadcast
	mkdir -p ${DISTRDIR}/var/log/${US}
	install var/us/commands/broadcast/* ${DISTRDIR}/var/${US}/commands/broadcast/
	mkdir -p ${DISTRDIR}/var/www/${US}_html
	#install var/www/html/us-c.png ${DISTRDIR}/var/www/${US}_html/
	#install var/www/html/geonodes.jpg ${DISTRDIR}/var/www/${US}_html/
	#install var/www/html/motd.html ${DISTRDIR}/var/www/${US}_html/
	mkdir -p ${DISTRDIR}/etc/nginx/sites-available
	install etc/nginx/sites-available/${US}.conf ${DISTRDIR}/etc/nginx/sites-available/
	mkdir -p ${DISTRDIR}/etc/nginx/snippets
	install etc/nginx/snippets/snakeoil.conf ${DISTRDIR}/etc/nginx/snippets/
	mkdir -p ${DISTRDIR}/etc/nginx/conf.d
	[ ${TORSERVER} -eq 1 ] && install etc/nginx/conf.d/${US}-hidden.conf ${DISTRDIR}/etc/nginx/conf.d/ && mkdir -p ${DISTRDIR}/etc/tor/torrc.d && install etc/tor/torrc.d/${US}-hidden ${DISTRDIR}/etc/tor/torrc.d/
	mkdir -p ${DISTRDIR}/etc/ssl/certs
	install etc/ssl/certs/ssl-cert-snakeoil.pem ${DISTRDIR}/etc/ssl/certs/
	mkdir -p ${DISTRDIR}/etc/ssl/private
	install etc/ssl/private/ssl-cert-snakeoil.key ${DISTRDIR}/etc/ssl/private/
	mkdir -p ${DISTRDIR}/etc/sudoers.d
	install etc/sudoers.d/usgov ${DISTRDIR}/etc/sudoers.d/
	mkdir -p ${DISTRDIR}/root/.ssh
	install root/.ssh/authorized_keys ${DISTRDIR}/root/.ssh/
	install snippet/${US}_distr_makefile ${DISTRDIR}/makefile
	mkdir -p ${DISTRDIR}/include/us
	find gov -type f -name "*.h" -exec install -D {} ${DISTRDIR}/include/us/{} \;
	find wallet -type f -name "*.h" -exec install -D {} ${DISTRDIR}/include/us/{} \;
	for f in `ack -h -o --no-group "api/apitool_generated__c\+\+_[a-z_-]*" ${DISTRDIR}/include/us/gov`; do install -D $$f ${DISTRDIR}/include/us/$$f ; done
	for f in `ack -h -o --no-group "api/apitool_generated__c\+\+_[a-z_-]*" ${DISTRDIR}/include/us/wallet`; do install -D $$f ${DISTRDIR}/include/us/$$f ; done
	install vcs_git_cpp ${DISTRDIR}/include/us/

install: distr
	$(MAKE) -C distr install;
	#bin/${US}_distr_make distr install
install-nginx: distr
	$(MAKE) -C distr install-nginx;
	#bin/${US}_distr_make distr install-nginx

install-system-base: distr
	$(MAKE) -C distr install-system-base;
	#bin/${US}_distr_make distr install-system-base

install-dev: distr
	mkdir -p ${PREFIX}
	$(MAKE) PREFIX="$(shell realpath ${PREFIX})" -C distr install-dev;

gov/${LIBUSGOV}.so: api/apitool_generated__c++__*
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C gov;

govx/${USGOV}: gov/${LIBUSGOV}.so
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C govx;

genesis: genesis/${US}-genesis
	find genesis -type f

genesis/${US}-genesis: api/apitool_generated__c++__protocol_gov_id
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C genesis;

wallet/${LIBUSWALLET}.so: gov/${LIBUSGOV}.so
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C wallet;

walletx/${USWALLET}: wallet/${LIBUSWALLET}.so
ifeq ($(NOFCGI),1)
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C walletx ;
else
	$(MAKE) CXXFLAGS="${CXXFLAGS}" FCGI=1 -C walletx ;
endif

bz/${LIBUSBZ}.so: wallet/${LIBUSWALLET}.so
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C bz;

bzx/${USBZ}: bz/${LIBUSBZ}.so
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C bzx;

api/apitool: doc/support
	$(MAKE) CXXFLAGS="${CXXFLAGS}" -C api ;

logtool/logtool: logtool/main.cpp
	$(MAKE) -C logtool ;

sdk-spongy:
	$(MAKE) spongy -C sdk/wallet/java

android: sdk-spongy
	$(MAKE) -C android

android-install: android
	bin/sign_apk --install

.PHONY: all wallet gov debug release sdk image res clean distr-common genesis warndistr android sdk-spongy

clean:
	$(MAKE) clean -C gov; \
	$(MAKE) clean -C govx; \
	$(MAKE) clean -C wallet; \
	$(MAKE) clean -C walletx; \
	$(MAKE) clean -C bz;
	$(MAKE) clean -C bzx;
	$(MAKE) clean -C sdk/wallet/java; \
	$(MAKE) clean -C android; \
	$(MAKE) clean -C logtool;
	rm -rf distr
