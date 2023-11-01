Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8083C4332F
	for <linux-nilfs@archiver.kernel.org>; Wed,  1 Nov 2023 17:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjKAR2B (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 13:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjKAR2A (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Wed, 1 Nov 2023 13:28:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDB611D;
        Wed,  1 Nov 2023 10:27:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 54F8A21A40;
        Wed,  1 Nov 2023 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698859667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EeD6MyheOvOMKaTHDmPGr7/dKV5M5WhtYHJ6fivDVuE=;
        b=XcPIjDl83MPTFBFz5xer0np/Ys+j7Uzpsx8dHdLDTdZfzcAYTnjCpaJzWdP1Tu3iLbZBu6
        XA+N0db5B77Ewu4KmW6TZTXLOQbgzkfTJdwS2Prd/e+Yg13Q5tVfdNdc+7NDtzCZ0O3TGP
        hzxH9KtTAMNnA7u/7uZYBNnvLSQ518g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698859667;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EeD6MyheOvOMKaTHDmPGr7/dKV5M5WhtYHJ6fivDVuE=;
        b=2XoCXMBy3RneEMuj2CC88wjcNLXeZin32BB1uoWECZhSn5V1xQrIKWWa7jHw2gWfD7NBPg
        FjcIhbwcwsZhJ6AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D3281348D;
        Wed,  1 Nov 2023 17:27:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LPSFDZOKQmVmWgAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 01 Nov 2023 17:27:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id AE313A06E3; Wed,  1 Nov 2023 18:27:46 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        linux-nilfs@vger.kernel.org
Subject: [PATCH] nilfs2: simplify device handling
Date:   Wed,  1 Nov 2023 18:27:39 +0100
Message-Id: <20231101172739.8676-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1237; i=jack@suse.cz; h=from:subject; bh=7IopNN/k3gNX0K2pRjQVO3jTcQh+9ZPrhl91nV19/Rw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlQoqGNCqfSpTE27Yb7nYlcbMInQ2z0m4cVZQa+JSm /gY25jiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZUKKhgAKCRCcnaoHP2RA2ZPGCA Cg9yqthRkvlhMsH8966kdm/q/Gyoghg9+oA+qHq0g1uSNRmeH+XUuoovtQKBn6cWZfEz7AxoNhews9 yk6ykL2TGlHKkQZA5gr5pKlFmQGt8gOcJcetk+UNnvaBr3l2jI8MAultwwxJvUx/Kti1VHKdfiia4d 4g6Gfd+iqwyGo8ZhlmuIOyuNKZeQsSLc+TOz4Y62h2MQoBAJZqVM1N3Id32dF1UHT3mZmhYAUCrqbC QijRwNslQ2WQ2HG3tKQBU2PCWWs/8x1EogyaugnzkFBkWgFsProngEJHLP7TPjH0AE61P6JEB/oea+ 0bLrAL4phG3lj282ME7qHbvzmG8SH1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

We removed all codepaths where s_umount is taken beneath open_mutex and
bd_holder_lock so don't make things more complicated than they need to
be and hold s_umount over block device opening.

CC: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: linux-nilfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/nilfs2/super.c | 8 --------
 1 file changed, 8 deletions(-)

Hi Christian, I think you've missed this simplification in your cleanup
patches. Can you merge it please?

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a5d1fa4e7552..df8674173b22 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1314,15 +1314,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		return ERR_CAST(s);
 
 	if (!s->s_root) {
-		/*
-		 * We drop s_umount here because we need to open the bdev and
-		 * bdev->open_mutex ranks above s_umount (blkdev_put() ->
-		 * __invalidate_device()). It is safe because we have active sb
-		 * reference and SB_BORN is not set yet.
-		 */
-		up_write(&s->s_umount);
 		err = setup_bdev_super(s, flags, NULL);
-		down_write(&s->s_umount);
 		if (!err)
 			err = nilfs_fill_super(s, data,
 					       flags & SB_SILENT ? 1 : 0);
-- 
2.35.3

