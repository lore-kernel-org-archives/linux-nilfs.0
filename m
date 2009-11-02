From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: Deadlock with nilfs on 2.6.31.4
Date: Tue, 03 Nov 2009 02:05:02 +0900 (JST)
Message-ID: <20091103.020502.126745214.ryusuke@osrg.net>
References: <20091021203847.26acab0a@neptune.home>
	<20091023.025129.71910838.ryusuke@osrg.net>
	<20091022221939.61c832c2@neptune.home>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091022221939.61c832c2@neptune.home>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: bonbons@linux-vserver.org
Cc: konishi.ryusuke@lab.ntt.co.jp, users@nilfs.org, linux-fsdevel@vger.kernel.org, ryusuke@osrg.net

Hi Bruno,
On Thu, 22 Oct 2009 22:19:39 +0200, Bruno Pr=E9mont <bonbons@linux-vser=
ver.org> wrote:
> On Fri, 23 October 2009 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.j=
p> wrote:
> > Thank you for reporting the issue.
> >=20
> > According to the log, the log-writer of nilfs looks to be idle even
> > though it has some requests waiting.
> >=20
> > Could you try the following patch to narrow down the issue ?
> >=20
> > I'll dig into this issue next week since I'm now away from my offic=
e
> > to attend the Linux symposium in Tokyo.
> >=20
> > Thank you,
> > Ryusuke Konishi
> >=20
> >=20
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 51ff3d0..0932571 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
>=20
> I tried the patch, below is full dmesg output from system start-up to
> frozen syslog-ng (and collectd thread). (with echo t > /proc/sysrq-tr=
igger)
>=20
> Hard to tell at what time syslog-ng did freeze, but chances are big i=
t's
> somewhere between 435.x and 591.x when nilfs stops sending/getting ev=
ents.
>=20
> The collectd instance in D-state is most probably the one that wants =
to
> write data to RRD file.
>=20
> At least it looks very easy to reproduce! Just restarting collectd a =
few
> times and enabling its rrdtool plugin. (syslog-ng writing to one nilf=
s
> partition, collectd to another one, both on the same SD card)
>=20
> Bruno
>=20
<snip>

I found the cause of the hang issue reported on ARM targets.
The following patch would fix the issue.

It resolved hang problem on my Feroceon based Linux box.

Could you try if the patch fixes the hang of yours ?

Thanks,
Ryusuke Konishi

--
=46rom: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

nilfs2: fix dirty page accounting leak causing hang at write

Some users experienced a consistent hang while using NILFS on
ARM-based targets.

I found this was caused by an underflow of dirty pages counter.  A
b-tree cache routine was marking page dirty without adjusting page
account information.

This fixes the dirty page accounting leak and resolves the hang on
arm-based targets.

Reported-by: Bruno Premont <bonbons@linux-vserver.org>
Reported-by: Dunphy, Bill <WDunphy@tandbergdata.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/btnode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 5941958..435864c 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -276,8 +276,7 @@ void nilfs_btnode_commit_change_key(struct address_=
space *btnc,
 				       "invalid oldkey %lld (newkey=3D%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
-		if (!test_set_buffer_dirty(obh) && TestSetPageDirty(opage))
-			BUG();
+		nilfs_btnode_mark_dirty(obh);
=20
 		spin_lock_irq(&btnc->tree_lock);
 		radix_tree_delete(&btnc->page_tree, oldkey);
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
