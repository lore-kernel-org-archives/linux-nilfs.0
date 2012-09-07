From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH 1/1] nilfs-utils: mkfs: improve reserved segments
 percentage calculation
Date: Fri, 07 Sep 2012 13:54:02 +0400
Message-ID: <1347011642.2017.6.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:To:From:Subject; bh=QJWw6kvmcek1TwLJG6JBktkvzm6YVbklMspusL7AxSo=;
	b=fgz/e0rG6F6D6vreIXXZFc6AT/MpZQIjhmmHyj+ElkdAK7+zXZFHokVE+UJDV2UR23BN14fbLwJ5rVNBBTxvqFQCxDGXtPtPp0MpEOIE1T3uq916ivOjTnqd7Y/HLkGB;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

It is used 5% as default value of reserved segments percentage during
volume creation. But it exists NILFS_MIN_NRSVSEGS (equals by 8)
declaration that defines minimum number of reserved segments. Thereby,
in the case of small volumes (for example, 1 GB) default value of
reserved segment percentage doesn't reserve required 8 segments. This
patch corrects calculation of reserved segment percentage for the case
of small volumes.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>From
74623a59a4b6513f9bdc606abdf0e483aa5db646 Mon Sep 17 00:00:00 2001
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Date: Fri, 7 Sep 2012 13:27:38 +0400
Subject: [PATCH 1/1] nilfs-utils: mkfs: improve reserved segments
percentage calculation

It is used 5% as default value of reserved segments percentage during
volume creation. But it exists NILFS_MIN_NRSVSEGS (equals by 8)
declaration that defines minimum number of reserved segments. Thereby,
in the case of small volumes (for example, 1 GB) default value of
reserved segment percentage doesn't reserve required 8 segments. This
patch corrects calculation of reserved segment percentage for the case
of small volumes.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/mkfs/mkfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index fde1c76..eb1aa9b 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -1632,6 +1632,13 @@ static void prepare_super_block(struct
nilfs_disk_info *di)
 	raw_sb->s_dev_size = cpu_to_le64(di->dev_size);
 	raw_sb->s_first_data_block = cpu_to_le64(di->first_segment_block);
 	raw_sb->s_blocks_per_segment = cpu_to_le32(di->blocks_per_segment);
+
+	if (((di->nsegments * r_segments_percentage + 99) / 100) <
+			NILFS_MIN_NRSVSEGS) {
+		r_segments_percentage =
+			(NILFS_MIN_NRSVSEGS * 100 + 99) / di->nsegments;
+		check_reserved_segments_percentage(r_segments_percentage);
+	}
 	raw_sb->s_r_segments_percentage = cpu_to_le32(r_segments_percentage);
 
 	raw_sb->s_ctime = cpu_to_le64(di->ctime);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
