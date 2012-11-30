From: ARAI Shun-ichi <hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Fri, 30 Nov 2012 16:46:16 +0900 (JST)
Message-ID: <20121130.164616.1703426007244850753.hermes@ceres.dti.ne.jp>
References: <20121129210650.GA4028@wloczykij>
	<1354255744.2090.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354255744.2090.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org

In <1354255744.2090.3.camel@slavad-ubuntu>;
   Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote
   as Subject "Re: A lot of NILFS: bad btree node messages (readonly fs)":

>> dmesg shows a lot (1812 in the log) of:
>> [ 8288.319012] NILFS: bad btree node (blocknr=26229286): level = 178,
>> flags = 0x0, nchildren = 0
>> [ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_contig:
>> broken bmap (inode number=102230)

> Can you reproduce this issue (I mean that the issue reproducible or
> not)? Have you any side effects of the issue such as data loss or any
> other bad things?

I met similar error.
Errors reported by my PC is like (/var/log/messages):

Aug 11 20:58:23 celio kernel: [365058.267458] scsi_verify_blk_ioctl: 6 callbacks suppressed
Aug 11 20:58:23 celio kernel: [365058.267460] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267489] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267504] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267519] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267534] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267548] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267563] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.267578] VBoxSVC: sending ioctl 5393 to a partition!
Aug 11 20:58:23 celio kernel: [365058.285133] NILFS: bad btree node (blocknr=17620479): level = 146, flags = 0x9a, nchildren = 49895
Aug 11 20:58:23 celio kernel: [365058.285137] NILFS error (device dm-9): nilfs_bmap_lookup_contig: broken bmap (inode number=571846)
Aug 11 20:58:23 celio kernel: [365058.285138] 
Aug 11 20:58:23 celio kernel: [365058.286426] Remounting filesystem read-only
Aug 11 20:58:23 celio kernel: [365058.286631] NILFS: bad btree node (blocknr=17620479): level = 146, flags = 0x9a, nchildren = 49895
Aug 11 20:58:23 celio kernel: [365058.286635] NILFS error (device dm-9): nilfs_bmap_lookup_contig: broken bmap (inode number=571846)
Aug 11 20:58:23 celio kernel: [365058.286636] 
Aug 11 20:58:23 celio kernel: [365058.286855] NILFS: bad btree node (blocknr=17620479): level = 146, flags = 0x9a, nchildren = 49895
Aug 11 20:58:23 celio kernel: [365058.286857] NILFS error (device dm-9): nilfs_bmap_lookup_contig: broken bmap (inode number=571846)
Aug 11 20:58:23 celio kernel: [365058.286858] 
(snip)

These errors ware reported at VirtualBox VM (Win7) startup (not
VirtualBox process startup). VirtualBox configuration directory
(~/.VirtualBox) was in NILFS.

Currently, my .VirtualBox directory is in other FS and symlinked from
home directory. After the workaround, my PC reports no error.

But I can say nothing about dependency with VirtualBox...

Kernel version was 3.4.5, VirtualBox was 4.1.18.

-- 
ARAI, Shun-ichi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
