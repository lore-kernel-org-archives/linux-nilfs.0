From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Nilfs (kernel 3.2.52) frozen mountpoint after USB disconnect
Date: Tue, 19 Nov 2013 12:53:51 -0500
Message-ID: <528BA5AF.2080007@intellitree.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020809040704050903020108"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------020809040704050903020108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, its me again.

I've upgraded my systems to 3.2.52 (direct from kernel.org, no gentoo 
patches any more), and haven't had a reboot since.  However, I just ran 
into a new problem where a power glitch caused an external USB drive to 
reset, and the nilfs kernel module didn't handle it well.  The mount 
point is frozen, and any process that accesses it freezes and can't be 
killed even with kill -9.  It was mounted with default mount options.

I've attached the complete kernel log from the time the USB device 
disconnected.  It ends with "Kernel Bug,  invalid opcode 0000" in 
nilfs_btnode_prepare_change_key.

The system is still running and doing fine other than this, and "umount 
-l" worked to remove it from the filesystem so that more processes don't 
get stuck.  However, this project I'm working on has used up a lot more 
time than I expected, and I'll have to try a different filesystem if I 
can't get it working reliably, soon :-( Would you like any additional 
debugging info?

-Mike

--------------020809040704050903020108
Content-Type: text/plain; charset=windows-1252;
 name="nilfs_usb_disconnect_bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nilfs_usb_disconnect_bug.txt"

[226872.031613] usb 1-4: USB disconnect, device number 3
[226872.031874] end_request: I/O error, dev sdf, sector 5860532216
[226872.031877] Buffer I/O error on device sdf1, logical block 732566271
[226872.031879] lost page write due to I/O error on sdf1
[226872.031882] NILFS: unable to write superblock (err=-5)
[226872.031886] end_request: I/O error, dev sdf, sector 2048
[226872.031887] Buffer I/O error on device sdf1, logical block 0
[226872.031889] lost page write due to I/O error on sdf1
[226872.031892] NILFS: unable to write superblock (err=-5)
[226872.047369] sd 3:0:0:0: [sdf] Unhandled error code
[226872.047373] sd 3:0:0:0: [sdf]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[226872.047376] sd 3:0:0:0: [sdf] CDB: Write(10): 2a 00 26 aa 77 8f 00 00 1e 00
[226872.047394] end_request: I/O error, dev sdf, sector 5189647480
[226872.047512] NILFS: IO error writing segment
[226872.047516] NILFS: IO error writing segment
[226872.047518] NILFS: IO error writing segment
[226872.052281] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226877.054976] NILFS: IO error writing segment
[226877.055032] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226877.104661] sd 3:0:0:0: [sdf] Synchronizing SCSI cache
[226877.104694] sd 3:0:0:0: [sdf]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[226877.334011] usb 1-4: new high-speed USB device number 5 using ehci_hcd
[226877.462224] scsi4 : usb-storage 1-4:1.0   
[226882.054932] NILFS: IO error writing segment
[226882.054977] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226883.468013] scsi 4:0:0:0: Direct-Access     WDC WD30 EFRX-68AX9N0     80.0 PQ: 0 ANSI: 4
[226883.468219] sd 4:0:0:0: Attached scsi generic sg7 type 0
[226883.468747] sd 4:0:0:0: [sdg] 732566646 4096-byte logical blocks: (3.00 TB/2.72 TiB)
[226883.469118] sd 4:0:0:0: [sdg] Write Protect is off
[226883.469122] sd 4:0:0:0: [sdg] Mode Sense: 10 00 00 00
[226883.469486] sd 4:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[226883.470118] sd 4:0:0:0: [sdg] 732566646 4096-byte logical blocks: (3.00 TB/2.72 TiB)
[226883.543278]  sdg: sdg1
[226883.544239] sd 4:0:0:0: [sdg] 732566646 4096-byte logical blocks: (3.00 TB/2.72 TiB)
[226883.544993] sd 4:0:0:0: [sdg] Attached SCSI disk
[226887.058281] NILFS: IO error writing segment
[226887.058326] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226892.058309] NILFS: IO error writing segment
[226892.058353] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226897.058234] NILFS: IO error writing segment
[226897.058279] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226902.058265] NILFS: IO error writing segment
[226902.058310] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226907.058243] NILFS: IO error writing segment
[226907.058287] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226912.058228] NILFS: IO error writing segment
[226912.058271] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226917.061600] NILFS: IO error writing segment
[226917.061644] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226922.061570] NILFS: IO error writing segment
[226922.061614] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226927.061559] NILFS: IO error writing segment
[226927.061602] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226932.064925] NILFS: IO error writing segment
[226932.064969] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226937.068226] NILFS: IO error writing segment
[226937.068269] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226942.068248] NILFS: IO error writing segment
[226942.068292] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226947.071510] NILFS: IO error writing segment
[226947.071555] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226952.071499] NILFS: IO error writing segment
[226952.071544] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226957.071498] NILFS: IO error writing segment
[226957.071543] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226962.071490] NILFS: IO error writing segment
[226962.071535] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226967.071515] NILFS: IO error writing segment
[226967.071560] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226972.071526] NILFS: IO error writing segment
[226972.071570] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226977.071491] NILFS: IO error writing segment
[226977.071536] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226982.071484] NILFS: IO error writing segment
[226982.071529] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226987.074839] NILFS: IO error writing segment
[226987.074888] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226992.074906] NILFS: IO error writing segment
[226992.074991] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[226997.078256] NILFS: IO error writing segment
[226997.078301] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227002.081561] NILFS: IO error writing segment
[227002.081605] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227007.081558] NILFS: IO error writing segment
[227007.081602] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227012.081542] NILFS: IO error writing segment
[227012.081588] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227017.081587] NILFS: IO error writing segment
[227017.081633] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227022.081586] NILFS: IO error writing segment
[227022.081631] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227027.081568] NILFS: IO error writing segment
[227027.081612] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227032.081553] NILFS: IO error writing segment
[227032.081597] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227037.081547] NILFS: IO error writing segment
[227037.081605] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227042.084924] NILFS: IO error writing segment
[227042.084969] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227047.084914] NILFS: IO error writing segment
[227047.084959] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227052.084883] NILFS: IO error writing segment
[227052.084928] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227057.084921] NILFS: IO error writing segment
[227057.084966] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227062.088221] NILFS: IO error writing segment
[227062.088264] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227067.088241] NILFS: IO error writing segment
[227067.088285] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227072.088280] NILFS: IO error writing segment
[227072.088325] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227077.088276] NILFS: IO error writing segment
[227077.088319] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227082.091744] NILFS: IO error writing segment
[227082.091817] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227087.094915] NILFS: IO error writing segment
[227087.094960] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227092.094882] NILFS: IO error writing segment
[227092.094926] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227097.098202] NILFS: IO error writing segment
[227097.098244] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227102.101578] NILFS: IO error writing segment
[227102.101622] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227107.101542] NILFS: IO error writing segment
[227107.101585] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227112.104915] NILFS: IO error writing segment
[227112.104959] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227117.104878] NILFS: IO error writing segment
[227117.104921] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227122.104871] NILFS: IO error writing segment
[227122.104916] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227127.104798] NILFS: IO error writing segment
[227127.104843] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227132.104907] NILFS: IO error writing segment
[227132.104952] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227137.104913] NILFS: IO error writing segment
[227137.104957] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227142.104932] NILFS: IO error writing segment
[227142.104977] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227147.104924] NILFS: IO error writing segment
[227147.104968] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227152.104903] NILFS: IO error writing segment
[227152.104947] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227157.104874] NILFS: IO error writing segment
[227157.104918] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227162.104890] NILFS: IO error writing segment
[227162.104933] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227167.104908] NILFS: IO error writing segment
[227167.104953] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227172.104875] NILFS: IO error writing segment
[227172.104920] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227177.104944] NILFS: IO error writing segment
[227177.104989] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227182.104876] NILFS: IO error writing segment
[227182.104921] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227187.104867] NILFS: IO error writing segment
[227187.104912] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227192.104887] NILFS: IO error writing segment
[227192.104931] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227197.104852] NILFS: IO error writing segment
[227197.104896] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227202.104905] NILFS: IO error writing segment
[227202.104950] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227207.104916] NILFS: IO error writing segment
[227207.104961] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227212.104864] NILFS: IO error writing segment
[227212.104908] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227217.104883] NILFS: IO error writing segment
[227217.104927] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227222.104855] NILFS: IO error writing segment
[227222.104898] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227227.104894] NILFS: IO error writing segment
[227227.104938] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227232.104853] NILFS: IO error writing segment
[227232.104897] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227237.104897] NILFS: IO error writing segment
[227237.104941] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227242.108232] NILFS: IO error writing segment
[227242.108277] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227247.108194] NILFS: IO error writing segment
[227247.108238] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227252.108171] NILFS: IO error writing segment
[227252.108214] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227257.108152] NILFS: IO error writing segment
[227257.108194] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227262.111558] NILFS: IO error writing segment
[227262.111602] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227267.111566] NILFS: IO error writing segment
[227267.111611] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227272.111562] NILFS: IO error writing segment
[227272.111607] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227277.111557] NILFS: IO error writing segment
[227277.111601] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227282.111556] NILFS: IO error writing segment
[227282.111601] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227287.114891] NILFS: IO error writing segment
[227287.114936] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227292.114857] NILFS: IO error writing segment
[227292.114901] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227297.114907] NILFS: IO error writing segment
[227297.114951] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227302.114894] NILFS: IO error writing segment
[227302.114939] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227307.114872] NILFS: IO error writing segment
[227307.114915] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227312.114889] NILFS: IO error writing segment
[227312.114934] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227317.114858] NILFS: IO error writing segment
[227317.114902] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227322.114857] NILFS: IO error writing segment
[227322.114901] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227327.114859] NILFS: IO error writing segment
[227327.114903] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227332.114893] NILFS: IO error writing segment
[227332.114938] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227337.114884] NILFS: IO error writing segment
[227337.114928] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227342.114889] NILFS: IO error writing segment
[227342.114934] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227347.118259] NILFS: IO error writing segment
[227347.118303] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227352.118198] NILFS: IO error writing segment
[227352.118242] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227357.118173] NILFS: IO error writing segment
[227357.118216] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227362.118214] NILFS: IO error writing segment
[227362.118257] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227367.118221] NILFS: IO error writing segment
[227367.118268] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227372.118133] NILFS: IO error writing segment
[227372.118178] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227377.118208] NILFS: IO error writing segment
[227377.118252] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227382.118214] NILFS: IO error writing segment
[227382.118259] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227387.118187] NILFS: IO error writing segment
[227387.118230] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227392.118219] NILFS: IO error writing segment
[227392.118263] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227397.118215] NILFS: IO error writing segment
[227397.118258] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227402.121532] NILFS: IO error writing segment
[227402.121575] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227407.124855] NILFS: IO error writing segment
[227407.124898] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227412.124880] NILFS: IO error writing segment
[227412.124924] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227417.124854] NILFS: IO error writing segment
[227417.124897] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227422.124838] NILFS: IO error writing segment
[227422.124882] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227427.124847] NILFS: IO error writing segment
[227427.124890] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227432.124886] NILFS: IO error writing segment
[227432.124931] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227437.124847] NILFS: IO error writing segment
[227437.124891] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227442.128204] NILFS: IO error writing segment
[227442.128248] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227447.128225] NILFS: IO error writing segment
[227447.128268] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227452.128214] NILFS: IO error writing segment
[227452.128258] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227457.131549] NILFS: IO error writing segment
[227457.131594] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227462.131554] NILFS: IO error writing segment
[227462.131619] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227467.131502] NILFS: IO error writing segment
[227467.131547] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227472.131552] NILFS: IO error writing segment
[227472.131597] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227477.134877] NILFS: IO error writing segment
[227477.134922] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227482.134880] NILFS: IO error writing segment
[227482.134925] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227487.134876] NILFS: IO error writing segment
[227487.134921] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227492.134869] NILFS: IO error writing segment
[227492.134914] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227497.138164] NILFS: IO error writing segment
[227497.138208] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227502.141497] NILFS: IO error writing segment
[227502.141541] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227507.144836] NILFS: IO error writing segment
[227507.144878] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227512.144825] NILFS: IO error writing segment
[227512.144868] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227517.144805] NILFS: IO error writing segment
[227517.144847] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227522.148210] NILFS: IO error writing segment
[227522.148255] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227527.148175] NILFS: IO error writing segment
[227527.148220] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227532.148199] NILFS: IO error writing segment
[227532.148243] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227537.151548] NILFS: IO error writing segment
[227537.151593] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227542.151525] NILFS: IO error writing segment
[227542.151570] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227547.151548] NILFS: IO error writing segment
[227547.151592] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227552.151532] NILFS: IO error writing segment
[227552.151577] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227557.151491] NILFS: IO error writing segment
[227557.151533] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227562.151533] NILFS: IO error writing segment
[227562.151578] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227567.154832] NILFS: IO error writing segment
[227567.154876] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227572.154824] NILFS: IO error writing segment
[227572.154867] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227577.154877] NILFS: IO error writing segment
[227577.154920] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227582.154874] NILFS: IO error writing segment
[227582.154919] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227587.158172] NILFS: IO error writing segment
[227587.158217] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227592.158179] NILFS: IO error writing segment
[227592.158223] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227597.161498] NILFS: IO error writing segment
[227597.161542] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227602.161490] NILFS: IO error writing segment
[227602.161533] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227607.161497] NILFS: IO error writing segment
[227607.161542] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227612.164872] NILFS: IO error writing segment
[227612.164916] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227617.168235] NILFS: IO error writing segment
[227617.168280] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227622.168163] NILFS: IO error writing segment
[227622.168206] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227627.168147] NILFS: IO error writing segment
[227627.168190] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227632.168179] NILFS: IO error writing segment
[227632.168223] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227637.168156] NILFS: IO error writing segment
[227637.168200] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227642.168150] NILFS: IO error writing segment
[227642.168194] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227647.168202] NILFS: IO error writing segment
[227647.168246] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227652.171560] NILFS: IO error writing segment
[227652.171604] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227657.171546] NILFS: IO error writing segment
[227657.171590] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227662.171493] NILFS: IO error writing segment
[227662.171536] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227667.174811] NILFS: IO error writing segment
[227667.174854] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227672.178118] NILFS: IO error writing segment
[227672.178164] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227677.181437] NILFS: IO error writing segment
[227677.181482] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227682.181528] NILFS: IO error writing segment
[227682.181573] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227687.184860] NILFS: IO error writing segment
[227687.184903] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227692.184860] NILFS: IO error writing segment
[227692.184903] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227697.184812] NILFS: IO error writing segment
[227697.184855] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227702.188217] NILFS: IO error writing segment
[227702.188261] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227707.191599] NILFS: IO error writing segment
[227707.191642] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227712.191565] NILFS: IO error writing segment
[227712.191608] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227717.191514] NILFS: IO error writing segment
[227717.191557] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227722.191512] NILFS: IO error writing segment
[227722.191555] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227727.191408] NILFS: IO error writing segment
[227727.191451] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227732.191534] NILFS: IO error writing segment
[227732.191577] NILFS warning (device sdf1): nilfs_clean_segments: segment construction failed. (err=-5)
[227737.190998] ------------[ cut here ]------------
[227737.193916] Kernel BUG at c02be3ea [verbose debug info unavailable]
[227737.193916] invalid opcode: 0000 [#1] SMP
[227737.193916] Modules linked in: twofish_i586 twofish_generic twofish_common camellia serpent blowfish_generic blowfish_common xcbc sha512_generic crypto_null aes_i586 coretemp i5k_amb asix r8169 8139too natsemi tg3 bnx2 3c59x tulip e100 e1000 e1000e vmxnet3
[227737.193916]
[227737.193916] Pid: 9297, comm: nilfs_cleanerd Not tainted 3.2.52 #3 Dell Inc. PowerEdge 2950/0CU542
[227737.193916] EIP: 0060:[<c02be3ea>] EFLAGS: 00010202 CPU: 2
[227737.193916] EIP is at nilfs_btnode_create_block+0x44/0x9a
[227737.193916] EAX: 00000002 EBX: cc764ac8 ECX: 00000000 EDX: cc764ac8
[227737.193916] ESI: e9295d1c EDI: 00008000 EBP: e9295ca4 ESP: f0df7c60
[227737.193916]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[227737.193916] Process nilfs_cleanerd (pid: 9297, ti=f0df6000 task=f1b1d130 task.ti=f0df6000)
[227737.193916] Stack:
[227737.193916]  26aa7852 00000000 fffffff4 26aa7852 00000000 c02be551 d4f7e51c c7b97d30
[227737.193916]  26aa7850 00000000 f0df7d9c d4f7e4e8 d4f7e51c e9295ca4 c02c1c66 f0df7d9c
[227737.193916]  d4f7e498 00000001 e9295d1c e9295764 d4f7e588 d9eb6000 d4f7e538 0dc61edc
[227737.193916] Call Trace:
[227737.193916]  [<c02be551>] ? nilfs_btnode_prepare_change_key+0xf8/0x126
[227737.193916]  [<c02c1c66>] ? nilfs_btree_assign+0x1b5/0x220
[227737.193916]  [<c02bea9f>] ? nilfs_bmap_assign+0x2d/0x4b
[227737.193916]  [<c02c728b>] ? nilfs_segctor_do_construct+0x9e0/0x12f3
[227737.193916]  [<c0149e1c>] ? sched_clock_local+0xe/0xf9
[227737.193916]  [<c02c7d5c>] ? nilfs_segctor_construct+0x5d/0x1ba
[227737.193916]  [<c02c8966>] ? nilfs_clean_segments+0xb6/0x1e2
[227737.193916]  [<c02cd1ba>] ? nilfs_ioctl+0xa27/0xcf8
[227737.193916]  [<c0188c04>] ? unmap_region+0xc0/0xc8
[227737.193916]  [<c02cc793>] ? nilfs_ioctl_do_get_bdescs+0x82/0x82
[227737.193916]  [<c01a274a>] ? vfs_ioctl+0x16/0x2f
[227737.193916]  [<c01a2c40>] ? do_vfs_ioctl+0x421/0x479
[227737.193916]  [<c0188a6c>] ? remove_vma+0x3e/0x43
[227737.193916]  [<c01a2cd9>] ? sys_ioctl+0x41/0x58
[227737.193916]  [<c08d4f18>] ? sysenter_do_call+0x12/0x28
[227737.193916]  [<c08d007b>] ? generic_processor_info+0xd9/0x168
[227737.193916] Code: 89 f0 e8 98 f5 ff ff 5f 85 c0 89 c3 74 6b 8b 00 a8 20 75 0c 8b 03 a8 01 75 06 8b 03 a8 02 74 0f 85 db 74 07 89 d8 e8 f9 51 ef ff <0f> 0b eb fe 8b 86 b4 00 00 00 ba 01 00 00 00 8b 7b 18 fc 88 c1
[227737.193916] EIP: [<c02be3ea>] nilfs_btnode_create_block+0x44/0x9a SS:ESP 0068:f0df7c60
[227737.534812] ---[ end trace b23aeede8b4beeeb ]---

--------------020809040704050903020108--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
