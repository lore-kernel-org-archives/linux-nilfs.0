From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Regarding ``problem with nilfs_cleanerd - part 2'' and
 ``Nilfs_cleanerd err=-17''
Date: Mon, 25 Apr 2011 10:35:42 +0900 (JST)
Message-ID: <20110425.103542.66626035.ryusuke@osrg.net>
References: <201103192004.14947.dexen.devries@gmail.com>
	<loom.20110422T201841-92@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110422T201841-92-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Fri, 22 Apr 2011 18:27:30 +0000 (UTC), Ivan Telichko wrote:
> Hi,
> 
> Same problem here, nilfs_cleanerd dies with these messages in system log:
> 
>   Apr 23 15:24:11 : nilfs_ioctl_move_inode_block: conflicting data buffer:
>     ino=97606, cno=281, offset=14, blocknr=3526535, vblocknr=1555981
>   Apr 23 15:24:11 : NILFS: GC failed during preparation: cannot read source
>     blocks: err=-17
> 
> It happened after I had to reboot with Alt+SysRq (system suddenly locked up).
> Then I booted SysRescueCD, mounted nilfs partition and found it filled up, but
> nilfs_cleanerd was working. I left it working for some time, it managed to free
> about 1.3Gb, but then died with error above. After that it does not start at
> all. Removing all checkpoints changed nothing. Partition works fine, but space
> is not freed anymore.

If you are still keeping the partition, could you test if the
following patch makes a difference ?

Thanks,
Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_cleanerd: judge instantly deleted blocks as dead

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index b0a77fe..703b43c 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -732,6 +732,9 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 	long low, high, index;
 	int s;
 
+	if (vdesc->vd_period.p_end == vdesc->vd_period.p_start)
+		return 0;
+
 	if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
 	    vdesc->vd_period.p_end > protect)
 		return 1;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
