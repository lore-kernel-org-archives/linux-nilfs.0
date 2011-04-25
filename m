From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding =?utf-8?b?YGBwcm9ibGVt?= with =?utf-8?b?bmlsZnNfY2xlYW5lcmQ=?= - part 2'' and =?utf-8?b?YGBOaWxmc19jbGVhbmVyZA==?= err=-17''
Date: Mon, 25 Apr 2011 05:28:10 +0000 (UTC)
Message-ID: <loom.20110425T072626-629@post.gmane.org>
References: <201103192004.14947.dexen.devries@gmail.com> <loom.20110422T201841-92@post.gmane.org> <20110425.103542.66626035.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> If you are still keeping the partition, could you test if the
> following patch makes a difference ?

No observable difference, patched cleanerd still dies the same way.

There are more messages in the log if I start nilfs_cleanerd by hand:

  Apr 26 02:54:21 nilfs_cleanerd[4734]: start
  Apr 26 02:54:21 nilfs_cleanerd[4734]: pause (clean check)
  Apr 26 02:54:21 nilfs_cleanerd[4734]: resume (clean check)
  Apr 26 02:54:21 nilfs_cleanerd[4734]: ncleansegs = 244
  Apr 26 02:54:21 nilfs_cleanerd[4734]: 4 segments selected to be cleaned
  Apr 26 02:54:21 nilfs_cleanerd[4734]: protected checkpoints = [69325,69425]
    (protection period >= 1303760661)
  Apr 26 02:54:22 kernel: nilfs_ioctl_move_inode_block: conflicting data buffer:
    ino=97606, cno=281, offset=14, blocknr=3526535, vblocknr=1555981
  Apr 26 02:54:22 kernel: NILFS: GC failed during preparation: cannot read
    source blocks: err=-17
  Apr 26 02:54:23 nilfs_cleanerd[4734]: cannot clean segments: File exists
  Apr 26 02:54:23 nilfs_cleanerd[4734]: shutdown

---

Regards,
  Ivan Telichko

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
