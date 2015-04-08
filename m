From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: fix issues with nilfs_set_inode_flags()
Date: Wed,  8 Apr 2015 23:49:43 +0900
Message-ID: <1428504585-1111-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=eqQ1BkC16DV9PGJt5reGsujvpiBXHw5co+3lMc0wzJk=;
        b=kN01WgAmohLBfLAVZxBwp6jcf38YqXCnLamecIrGBaVctzTzLmCLPNCAe3kJoRRuU4
         Pz8JpTgHfQo21FVVUX0yL/5LBXnyuEg/J1fO5X8vCUmoaCB8/nrv1VJ2J8WNd//ihbxn
         5JwUi5xxi9AgfuiyTqPYlRg91mnr5teo1uxr9Qlh4KzgJgdJqFwq216xgz1mbkelT5yW
         TbAZ7Mn3zR0TlmcF0295gajshSFeWVSKcHSrd9ckefefRmXcthU8zQGBZE3Bi7hEOL0E
         6MsL8ngNFEL3fM31MMn91/ecfqlckS0Lx0PkS9V1MT8xKpXWSPH+oFSMB9h8qAtZxNfr
         3MYQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

Please queue the following changes for the next merge window:

Ryusuke Konishi (2):
      nilfs2: put out gfp mask manipulation from nilfs_set_inode_flags()
      nilfs2: use inode_set_flags() in nilfs_set_inode_flags()

These fix issues related to nilfs_set_inode_flags() function.

Thanks,
Ryusuke Konishi
--

 fs/nilfs2/inode.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
