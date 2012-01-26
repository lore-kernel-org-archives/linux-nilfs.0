From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Odd problem starting nilfs_cleanerd due to an eMMC misbehaviour
Date: Thu, 26 Jan 2012 17:52:03 +0400
Message-ID: <20120126135203.GM2267@home.lan>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=x1rCKS3sEvVSRjb/nSr9B8Uh6V8Vx6tSnsxzl9c6sTw=;
        b=PsW0GGnOWLi1LOKBudS7nNbQg72HfeXV8w4VRVHLjHP/IKEGOJeQ+/W+LLMj4PzGl2
         PMCFB26nRx5Xka6UGZYu6c9aiDuvmZPFU2fkdboCpq/q57YwqO2pJrsECnISypd1GWQf
         fvEUM+T4LiyE4E/wNcOanUW3Wl9ewnwEhkrOs=
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I'm using nilfs2 for the root filesystem on an ARM-based netbook
(Toshiba ac100) with Debian hardfloat. Custom kernel is based on 3.0.8
and nilfs-tools is 2.1.0-1 from the Debian repository.

I wanted to try the threaded i/o test from the Phoronix test suite and
somehow it happened that during the test the garbage collecting daemon
failed and never came back. So i got the filesystem 100% full and
after i noticed it i tried running the daemon manually. It didn't
start even after reboot. Suprisingly, the eMMC error went away on its
own after fully powering off the whole device, and after that the
daemon started to work properly.

I'm not sure what conclusion might be made from this but i'd still
appreciate any comments, especially the suggestions on what to do if
the error didn't "recover".

The relevant dmesg excerpts (full might be available from
http://paulfertser.info/files/failing_emmc.txt ):

[    2.837036] mmc0: new high speed MMC card at address 0001
[    2.847637] mmcblk0: mmc0:0001 MMC32G 29.8 GiB 
...
[ 5668.706475] mmcblk0: retrying using single block read
[ 5671.580366] mmcblk0: error -110 transferring data, sector 15563278, nr 122, card status 0x200900
[ 5671.603701] end_request: I/O error, dev mmcblk0, sector 15563278
[ 5674.421016] mmcblk0: error -110 transferring data, sector 15563279, nr 121, card status 0x200900
[ 5674.445322] end_request: I/O error, dev mmcblk0, sector 15563279
[ 5674.466988] NILFS: GC failed during preparation: cannot read source blocks: err=-5
...
[ 7121.711242] WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_clean_segments.clone.7+0x4f4/0x634 [nilfs2]()
...
[ 7121.834580] [<bf01d578>] (nilfs_ioctl_clean_segments.clone.7+0x4f4/0x634 [nilfs2]) from [<bf01de10>] (nilfs_ioctl+0x584/0x85c [nilfs2])
[ 7121.852173] [<bf01de10>] (nilfs_ioctl+0x584/0x85c [nilfs2]) from [<c014b518>] (do_vfs_ioctl+0x51c/0x590)
[ 7121.866961] [<c014b518>] (do_vfs_ioctl+0x51c/0x590) from [<c014b5ec>] (sys_ioctl+0x60/0x84)
[ 7121.880665] [<c014b5ec>] (sys_ioctl+0x60/0x84) from [<c0055020>] (ret_fast_syscall+0x0/0x30)
[ 7121.894273] ---[ end trace 7f37788dc3302b00 ]---
[ 7121.904330] NILFS: GC failed during preparation: cannot read source blocks: err=-17
[ 7124.499469] mmcblk0: retrying using single block read
[ 7127.319607] mmcblk0: error -110 transferring data, sector 15563278, nr 2, card status 0x200900
[ 7127.342323] end_request: I/O error, dev mmcblk0, sector 15563278
...

Then any attempt to manually start GC lead to:

[39133.541126] NILFS: GC failed during preparation: cannot read source blocks: err=-17
[39136.196519] mmcblk0: retrying using single block read
[39139.003276] mmcblk0: error -110 transferring data, sector 15563278, nr 2, card status 0x200900
[39139.012406] end_request: I/O error, dev mmcblk0, sector 15563278
[39141.815571] mmcblk0: error -110 transferring data, sector 15563279, nr 1, card status 0x200900
[39141.824837] end_request: I/O error, dev mmcblk0, sector 15563279
...

TIA and best of luck!
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
