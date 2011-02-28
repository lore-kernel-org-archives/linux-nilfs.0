From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: regression in 2.6.37?
Date: Mon, 28 Feb 2011 13:52:56 +0900 (JST)
Message-ID: <20110228.135256.149497634.ryusuke@osrg.net>
References: <87aahhuemz.wl%jir@sekiba.com>
	<8739n8vs1f.wl%jir@sekiba.com>
	<20110228.112146.55852337.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110228.112146.55852337.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 28 Feb 2011 11:21:46 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 28 Feb 2011 10:58:36 +0900, Jiro SEKIBA wrote:
> > 
> > At Mon, 28 Feb 2011 10:33:24 +0900,
> > Jiro SEKIBA wrote:
> > > 
> > > Hi,
> > > 
> > > I found that none of the checpoints are flagged 'i'.
> > > It looks like it happens after 2.6.37.
> > > 
> > > So whenever I only execute "chcp ss <cp>" without any filesystem change,
> > > nilfs volume create new cp without 'i'.
> > > Before 2.6.37, it creates new cp with 'i'.
> > 
> > This, by the way, causes that nilfs2_ss_manager creates
> > snapshots forever and useless as a result.
> > 
> > So I would really like to turn it back to the normal behavior.
> > It is really critical for the application.
> > 
> > thanks
> > 
> > regards,
> 
> Arrh, that sounds so bad.  Ok, I'll look into the problem ASAP.
> 
> Ryusuke Konishi

Actually, this tourned out to be a regression on 2.6.37.
The following patch will fix this.

Could you confirm that it corrects your problem?

Thanks,
Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2: fix regression that i-flag is not set on changeless checkpoints

According to the report from Jiro SEKIBA titled "regression in
2.6.37?"  (Message-Id: <8739n8vs1f.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>), on 2.6.37 and
later kernels, lscp command no longer displays "i" flag on checkpoints
that snapshot operations or garbage collection created.

This is a regression of nilfs2 checkpointing function, and it's
critical since it broke behavior of a part of nilfs2 applications.
For instance, snapshot manager of TimeBrowse gets to create
meaningless snapshots continuously; snapshot creation triggers another
checkpoint, but applications cannot distinguish whether the new
checkpoint contains meaningful changes or not without the i-flag.

This patch fixes the regression and brings that application behavior
back to normal.

Reported-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  [2.6.37]
---
 fs/nilfs2/segment.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 55ebae5..2de9f63 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -430,7 +430,8 @@ static void nilfs_segctor_begin_finfo(struct nilfs_sc_info *sci,
 	nilfs_segctor_map_segsum_entry(
 		sci, &sci->sc_binfo_ptr, sizeof(struct nilfs_finfo));
 
-	if (inode->i_sb && !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+	if (NILFS_I(inode)->i_root &&
+	    !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
 		set_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 	/* skip finfo */
 }
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
