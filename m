From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs-clean: do not change min_reclaimable_blocks_unit in erroneous case
Date: Tue, 19 Aug 2014 08:52:15 +0900
Message-ID: <1408405936-6130-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1408405936-6130-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=DH68mT0PLeYsdJTJX1e/a/M28jzioYcWyXUV1LhxhEQ=;
        b=MygJqOp8pNqnhBiNNmpk4KrFwJrlgXgwn8+OU4qv/GCYS01rqa4CNIkkQBOit0hmSN
         meaPTyVjE2PeKDnFoPPup53IjpXdVPG/EI1sc3gGIuKZbh1PokHD6tEpSQbRicS2QCEp
         xWtr4fRMabpZTiAGwdtUwh/+JpQ+VVgMxoH5U4ctPP89AIrVU/SBIG+LYrb3FZbKvgLL
         bGYFKDln9lqcigS4h4V31ZWCpHVtmcLwDHXoIe6Vpdjc+dJ/FhR1suvSrDnHWXzXSWaT
         fzUQIHc+YAhA9H4G2/HMIQuBlVpG+vYdCjqr/+MMcKOVSQot05TMoXm5blwitojhgpol
         9Etw==
In-Reply-To: <1408405936-6130-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_clean_parse_min_reclaimable() function changes value of
min_reclaimable_blocks_unit even if a given percentage value is
invalid.  Although it doesn't cause any actual problems since its only
caller, nilfs_clean_parse_options(), will immediately abort the
program when nilfs_clean_parse_min_reclaimable() returned an error
status code (-1), it is not sane for
nilfs_clean_parse_min_reclaimable() function itself.

Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/nilfs-clean/nilfs-clean.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 62130c4..ab2180a 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -407,12 +407,12 @@ static int nilfs_clean_parse_min_reclaimable(const char *arg)
 	}
 
 	if (endptr[0] == '%') {
-		min_reclaimable_blocks_unit = NILFS_CLEANER_ARG_UNIT_PERCENT;
 		if (blocks > 100) {
 			myprintf(_("Error: percent value can't be > 100: %s\n"),
 					arg);
 			return -1;
 		}
+		min_reclaimable_blocks_unit = NILFS_CLEANER_ARG_UNIT_PERCENT;
 	} else {
 		min_reclaimable_blocks_unit = NILFS_CLEANER_ARG_UNIT_NONE;
 	}
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
