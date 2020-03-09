From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: null pointer dereferenced with Ubuntu kernel 4.15
Date: Mon, 9 Mar 2020 14:15:21 +0000
Message-ID: <24166.20345.583274.370928@base.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
         boundary="F9n5GriY/Y"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kdp2Ar2NXNrqwncwEKaDT9ks6esRAkpmu7fRtdLSOOg=; b=bpo/ZC2HyV1uH7X3mg+pY4Xpa
        eLcs/H8LxAuqwS7ejUBvqxBss9GwR33V8mzENI8QTurfnYD4AlHKC7yaVu69W8hnxfOKGiyb1iPbP
        cTu4U23nRUvkPSfxmJHWHqt+NHPRWbVR2DGXPZHDno2ZiFyM2nEcmuxIuvM+D6EsvfXBMM2ZSd4EA
        DVB2ddwyKF/VburV5B/q4SxWfVE6EH9IuZ13MwXyFFC3+umHUVbpie4xIseBW4XVonzKOuaWi9XZH
        yhvE+LEB24OU+xbqH3rPp3B+tbYe1xQIvHrp/a9GDNMCMNXxAkuCTFGEAHHPE5UkRYOZ4C9Ry1KG2
        H 
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--F9n5GriY/Y
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

Dear NILFSers I am perplexed because on upgrading my standard
Ubuntu LTS kernel "4.15.0-88-generic" I keep getting null
pointer dereferences as per attached kernel messages, and this
did not happen with the previous version "4.15.0-72-generic".

This seems to be happening with a specific filetree (I have 5
NILFS filetrees), but then I use mostly that one (the others are
in large part archives). If it is that some corruption or
uninitialized field has happened with that specific one I can
easily recreate it.


--F9n5GriY/Y
Content-Type: text/plain;
	 name="20200309-nilfsNull.txt"
Content-Description: trace of null pointer dereference ULTS kernel 4.15.0-88-generic
Content-Disposition: inline;
	 filename="20200309-nilfsNull.txt"
Content-Transfer-Encoding: 7bit

[74917.285978] NILFS (dm-2): mounting unchecked fs
[74917.523911] NILFS (dm-2): recovery complete
[74917.525792] NILFS (dm-2): segctord starting. Construction interval = 10 seconds, CP frequency < 30 seconds
[74919.917507] DROP_I last: IN=eth0 OUT= MAC=01:00:5e:00:00:01:10:13:31:a3:0d:ae:08:00 SRC=192.168.1.1 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0xC0 TTL=
[75004.175846] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[75004.175864] IP: percpu_counter_add_batch+0xf/0x70
[75004.175868] PGD 0 P4D 0
[75004.175874] Oops: 0000 [#1] SMP NOPTI
[75004.175878] Modules linked in: rfcomm dm_crypt nf_log_ipv6 xt_multiport nf_log_ipv4 nf_log_common xt_limit eeprom jc42 it87 hwmon_vid nf_nat_tft
[75004.175923]  xt_LOG ipt_ECN xt_DSCP ipt_CLUSTERIP iptable_raw iptable_nat nf_nat_ipv4 iptable_mangle arptable_filter arpt_mangle arp_tables sit
[75004.175973]  twofish_generic snd_seq_device snd_timer twofish_avx_x86_64 twofish_x86_64_3way snd twofish_x86_64 twofish_common soundcore i2c_pii
[75004.176022]  uas usb_storage amdkfd amd_iommu_v2 amdgpu chash i2c_algo_bit ttm drm_kms_helper syscopyarea hid_generic sysfillrect mxm_wmi sysimg
[75004.176042] CPU: 6 PID: 15910 Comm: segctord Not tainted 4.15.0-88-generic #88~16.04.1-Ubuntu
[75004.176046] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE R2.0, BIOS 2501 04/09/2014
[75004.176063] RIP: 0010:percpu_counter_add_batch+0xf/0x70
[75004.176066] RSP: 0018:ffffb4d10e087cc0 EFLAGS: 00010006
[75004.176071] RAX: 0000000000000003 RBX: ffffed848f302f80 RCX: 000000000000001b
[75004.176074] RDX: 0000000000000020 RSI: 0000000000000001 RDI: 0000000000000088
[75004.176078] RBP: ffffb4d10e087cd8 R08: 0000000000000000 R09: ffff9d0450dd0d90
[75004.176081] R10: 0000000000000000 R11: 0000000000000228 R12: 0000000000000088
[75004.176084] R13: 0000000000000001 R14: ffff9d0450cd5558 R15: ffff9d0450cd56d0
[75004.176088] FS:  0000000000000000(0000) GS:ffff9d047ed80000(0000) knlGS:0000000000000000
[75004.176092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[75004.176095] CR2: 00000000000000a8 CR3: 0000000756614000 CR4: 00000000000406e0
[75004.176098] Call Trace:
[75004.176109]  __test_set_page_writeback+0x2f0/0x310
[75004.176133]  nilfs_segctor_do_construct+0x152e/0x2070 [nilfs2]
[75004.176151]  nilfs_segctor_construct+0x1b0/0x310 [nilfs2]
[75004.176167]  ? nilfs_segctor_construct+0x1b0/0x310 [nilfs2]
[75004.176183]  nilfs_segctor_thread+0x108/0x380 [nilfs2]
[75004.176189]  kthread+0x105/0x140
[75004.176204]  ? nilfs_segctor_construct+0x310/0x310 [nilfs2]
[75004.176209]  ? kthread_bind+0x40/0x40
[75004.176215]  ret_from_fork+0x22/0x40
[75004.176219] Code: 38 e1 4e 00 48 89 d8 5b 41 5c 41 5d 5d c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 49 89 f5 41 54 49 89 fc
[75004.176263] RIP: percpu_counter_add_batch+0xf/0x70 RSP: ffffb4d10e087cc0
[75004.176265] CR2: 00000000000000a8
[75004.176270] ---[ end trace 33744c64725742d2 ]---

--F9n5GriY/Y--
