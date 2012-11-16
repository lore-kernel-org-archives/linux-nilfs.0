From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Fri, 16 Nov 2012 17:52:49 +0400
Message-ID: <1353073969.9135.7.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	 <1351604965.2069.13.camel@slavad-ubuntu>
	 <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	 <1351608774.2026.6.camel@slavad-ubuntu>
	 <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	 <AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	 <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	 <1351664002.2105.3.camel@slavad-ubuntu>
	 <CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
	 <CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw@mail.gmail.com>
	 <CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ@mail.gmail.com>
	 <1352961172.2076.10.camel@slavad-ubuntu>
	 <CAFPMYnH4npNU8dJKAHwjatxAA=WoT10EWho5xyYjZJjz4uOYBA@mail.gmail.com>
	 <CAFPMYnG6zjT6-=x7XcVuuCp1__H0FhCBfNmyrfQi8dNpWC_m2w@mail.gmail.com>
	 <1353047197.2029.5.camel@slavad-ubuntu>
	 <CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA@mail.gmail.com>
	 <1353048835.2029.17.camel@slavad-ubuntu>
	 <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xriY1QK/RBpFufAfM1jq"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=BP702LWC5sSayJiWng8aHhKkYyk/2nV9HT6BYzXzHdY=;
	b=BUt8SmvN4GMIptcRjWJ6E95RfaE5xfmfMxSridCe1gaoZXksUbgIm8W2fyZDx028ZbacLciKbEMo+A3OME5JIQGRKxGFVsfsjBA9efAnSrid3J5Eaiy4kbfXhweRNC62;
In-Reply-To: <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--=-xriY1QK/RBpFufAfM1jq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 10:11 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=
=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wrote:
> dmesg:
> [53994.254432] NILFS warning: mounting unchecked fs
> [56686.968229] NILFS: recovery complete.
> [56686.969316] segctord starting. Construction interval =3D 5 seconds,
> CP frequency < 30 seconds
>=20
> messages:
> Nov 15 10:57:06 router kernel: [53994.254432] NILFS warning: mounting
> unchecked fs
> Nov 15 11:42:02 router kernel: [56686.968229] NILFS: recovery complete.
> Nov 15 11:42:02 router kernel: [56686.969316] segctord starting.
> Construction interval =3D 5 seconds, CP frequency < 30 seconds
>=20
> May be there is some kernel config option to get more debug output?
>=20

I prepared small patch (please, find in attachment). This patch simply
adds several debug messages into recovery module. I suggest to apply the
patch on your NILFS2 driver and try to mount again in the issue
environment. I hope that these debug messages can give more information
about issue on your side.

The patch uses pr_debug() call. Please, see
Documentation/dynamic-debug-howto.txt for more details.

To be honest, I don't test the patch yet. So, if you will have any
troubles, please, e-mail to me.

With the best regards,
Vyacheslav Dubeyko.

> As for fsck, I have not found it in git public repo, so where can I
> get the latest version?
> --------------------------------------------------


--=-xriY1QK/RBpFufAfM1jq
Content-Disposition: attachment;
	filename="0001-nilfs-add-debug-messages-for-recovery-module.patch"
Content-Type: text/x-patch;
	name="0001-nilfs-add-debug-messages-for-recovery-module.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs: add debug messages for recovery module

This patch simply adds several pr_debug() messages for debugging recovery code functioning.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/recovery.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f1626f5..cb5c0c7 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -435,6 +435,12 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	int err;
 	int i;
 
+	pr_debug("NILFS: nilfs_prepare_segment_for_recovery\n");
+	pr_debug("NILFS: ns_segnum %lld, ns_nextnum %lld\n",
+			nilfs->ns_segnum, nilfs->ns_nextnum);
+	pr_debug("NILFS: ri_segnum %lld, ri_nextnum %lld\n",
+			ri->ri_segnum, ri->ri_nextnum);
+
 	segnum[0] = nilfs->ns_segnum;
 	segnum[1] = nilfs->ns_nextnum;
 	segnum[2] = ri->ri_segnum;
@@ -602,6 +608,11 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
 	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
 
+	pr_debug("NILFS: nilfs_do_roll_forward\n");
+	pr_debug("NILFS: pseg_start %lld, seg_seq %lld\n", pseg_start, seg_seq);
+	pr_debug("NILFS: segnum %lld\n", segnum);
+	pr_debug("NILFS: seg_start %lld, seg_end %lld\n", seg_start, seg_end);
+
 	while (segnum != ri->ri_segnum || pseg_start <= ri->ri_pseg_start) {
 		brelse(bh_sum);
 		bh_sum = nilfs_read_log_header(nilfs, pseg_start, &sum);
@@ -705,6 +716,8 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 	struct buffer_head *bh;
 	int err;
 
+	pr_debug("NILFS: nilfs_finish_roll_forward\n");
+
 	if (nilfs_get_segnum_of_block(nilfs, ri->ri_lsegs_start) !=
 	    nilfs_get_segnum_of_block(nilfs, ri->ri_super_root))
 		return;
@@ -750,6 +763,8 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
 		return 0;
 
+	pr_debug("NILFS: nilfs_salvage_orphan_logs\n");
+
 	err = nilfs_attach_checkpoint(sb, ri->ri_cno, true, &root);
 	if (unlikely(err)) {
 		printk(KERN_ERR
@@ -831,6 +846,10 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 	cno = nilfs->ns_last_cno;
 	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
 
+	pr_debug("NILFS: nilfs_search_super_root\n");
+	pr_debug("NILFS: pseg_start %lld, seg_seq %lld\n", pseg_start, seg_seq);
+	pr_debug("NILFS: cno %lld, segnum %lld\n", cno, segnum);
+
 	/* Calculate range of segment */
 	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
 
-- 
1.7.9.5


--=-xriY1QK/RBpFufAfM1jq--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
