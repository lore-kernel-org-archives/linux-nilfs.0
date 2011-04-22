From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding =?utf-8?b?YGBwcm9ibGVt?= with =?utf-8?b?bmlsZnNfY2xlYW5lcmQ=?= - part 2'' and =?utf-8?b?YGBOaWxmc19jbGVhbmVyZA==?= err=-17''
Date: Fri, 22 Apr 2011 18:27:30 +0000 (UTC)
Message-ID: <loom.20110422T201841-92@post.gmane.org>
References: <201103192004.14947.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Same problem here, nilfs_cleanerd dies with these messages in system log:

  Apr 23 15:24:11 : nilfs_ioctl_move_inode_block: conflicting data buffer:
    ino=97606, cno=281, offset=14, blocknr=3526535, vblocknr=1555981
  Apr 23 15:24:11 : NILFS: GC failed during preparation: cannot read source
    blocks: err=-17

It happened after I had to reboot with Alt+SysRq (system suddenly locked up).
Then I booted SysRescueCD, mounted nilfs partition and found it filled up, but
nilfs_cleanerd was working. I left it working for some time, it managed to free
about 1.3Gb, but then died with error above. After that it does not start at
all. Removing all checkpoints changed nothing. Partition works fine, but space
is not freed anymore.

There were unusual messages in the system log just before forced reboot:

  Apr 22 09:26:39 : nilfs_palloc_freev: entry number 5381610 already freed
  Apr 22 09:26:39 : nilfs_palloc_freev: entry number 5381611 already freed
  Apr 22 09:26:39 : nilfs_palloc_freev: entry number 5381612 already freed
  Apr 22 09:26:41 : nilfs_sufile_do_free: segment 2342 is already clean
  Apr 22 09:26:41 : nilfs_sufile_do_free: segment 2343 is already clean
  Apr 22 09:26:41 : nilfs_sufile_do_free: segment 2344 is already clean
  Apr 22 09:26:41 : nilfs_sufile_do_free: segment 2345 is already clean
  ...same thing goes on for about 7 minutes, then system dies.

I am using nilfs-utils 2.0.21 on linux-2.6.32-gentoo-r7 with nilfs2 compiled in
the kernel, nilfs on root partition, with initramfs. Also, there were two
instances of nilfs_cleanerd started on system boot. I thought it was strange,
but harmless, so I ignored it.

---

Regards,
  Ivan Telichko


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
