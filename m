From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 30 May 2013 22:50:12 +0200
Message-ID: <51A7BB84.3010505@antoneliasson.se>
References: <519D2B96.9000106@antoneliasson.se>  <1369291449.2673.15.camel@slavad-ubuntu>  <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se> <1369809573.2253.31.camel@slavad-ubuntu> <51A70971.40602@antoneliasson.se> <51A770A8.9070105@antoneliasson.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A770A8.9070105-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry for my frequent posting today. It looks like my system is falling 
apart. Earlier today /home died again. This is the volume "newhome" on 
the sketch I sent two e-mails ago. Just like the last time it involved a 
file related to VMware and just like last time the ro remount was 
triggered by my backup program bup as it tried to read the corrupted 
file. VMware itself was not running at the time.

I create a new logical volume riven-proto/homesweethome, format it to 
ext4, change the fstab entry for /home to 
/dev/riven-proto/homesweethome, reboot and check the logs. kernel.log said:

May 30 19:41:24 riven kernel: [88324.864707] NILFS: bad btree node 
(blocknr=16521285): level = 100, flags = 0x3c, nchildren = 29793
May 30 19:41:24 riven kernel: [88324.864716] NILFS error (device dm-4): 
nilfs_bmap_lookup_contig: broken bmap (inode number=117612)
May 30 19:41:24 riven kernel: [88324.864716]
May 30 19:41:24 riven kernel: [88324.875626] Remounting filesystem read-only
May 30 19:41:24 riven kernel: [88324.875803] NILFS: bad btree node 
(blocknr=16521285): level = 100, flags = 0x3c, nchildren = 29793
May 30 19:41:24 riven kernel: [88324.875809] NILFS error (device dm-4): 
nilfs_bmap_lookup_contig: broken bmap (inode number=117612)
May 30 19:41:24 riven kernel: [88324.875809]

This output makes me believe that only one file is corrupted:

$ sudo mount -o ro,norecovery /dev/riven-proto/newhome /mnt
$ cd /mnt/anton/
$ LANG=C find . -type f -exec cat {} >/dev/null \;
cat: ./vmware/WXP/WXP-15dc29db.vmem: Input/output error




Next issue: after said reboot I got these errors:

May 30 20:09:35 riven kernel: [    7.298727] 
nilfs_ioctl_move_inode_block: conflicting data buffer: ino=8079, 
cno=726783, offset=911, blocknr=4812804, vblocknr=565882
May 30 20:09:35 riven kernel: [    7.299406] NILFS: GC failed during 
preparation: cannot read source blocks: err=-17

nilfs_cleanerd won't start on the root fs. Same errors if I try to start 
it manually (`nilfs_cleanerd /dev/riven/arch` as root).

I'd really like to have my SSD back now. Can I dd /home ("old" home on 
volume group "riven" that we've been debugging these last few days) to 
an image file and then reformat? I could keep riven-proto/newhome around 
if you want to debug that as well. As far as I know, riven-proto/newhome 
died very cleanly, with no rw mounts after the corruption was first 
discovered.

-- 
Best Regards,
Anton Eliasson
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
