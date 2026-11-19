Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795077675;
	b=H36rgm9c+2dQ5unN5UBpzUIc17hPHf9SYgJrIyk6awrVgk6jjSE6QMXosuCuhi50BCX0
	 N5zvJEVI7Txzuje9vCUwFEYSe5oTdfn0nAPJTM5dkwuJwrj6VzYAWKFqE55Q6HI9q1DZa
	 0Uk22n4lCVlQDfMurX6zCp7G2uMT2bSU5wNL0snWRTg67eCEnl+cKq3B+R9KO3mxMW+7g
	 TNLKbvcVJkJDyr/Al4dDWbV622sjUP+HDxHjyD2wenhurTTB/TBOJloglMcOAhw016fYv
	 2ifnn4nv7KjGRUsYwTvCBlVi768W6mCzY/rnvCROBHq9D56AtN1SZqXW6ecQH0I5kgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077675;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=vHSPJ3UOC3UBrVaVpZjQUwe8JbOw7urTENhGmj9xj/4=;
	b=oolWTNzvuBO8Bj0WF3GgNSz1vIVJskYYYGaHttnEmIG+/+UtO/Dr5pzWJb0wLuAL1yFt
	 RS8yGe/2TPe0ubGyalIYaT3yGWwUxvA32fnyaI9brB+oGzThHym1RGdl956/0UC0wjmB5
	 Oj8AVsMh9KNnau5dLCSkFsAunJnD9E0NuRQPCPuOs/ImBM1YIis9LbJihl8qpglD/sLAa
	 +t5vYQfuvK+GqxGyOTBYH3YA8PsivRIA2iww4ltFPBSyT0tcnU33D5eCK4jy0WL1Uj4WU
	 FVL3VTktdJSsPF9V9f8l2aqafCnl03AbbvFOy8VZEN43rmEGgfVF3ZyORrPix52J+MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oGI+bbse;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B904606A338
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 08:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B904606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oGI+bbse
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vHSPJ3UOC3UBrVaVpZjQUwe8JbOw7urTENhGmj9xj/4=;
	b=oGI+bbseNhy2LcWpcrP21z/H/zLX/E/p7rGGhVc04ghACZW/9GWRNedreGd7cHlE5NLHS651a
	UKWm8HbYnzRp3xcqSy99XwASXPh6aFQ5l0S88Xny4qZ+nqZToYtSjh7wxyWPhHiSUyfZvSOQhLE
	uTjGIl19BbDgpZNp37Kf9hU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jVX3M5vmmznTZb;
	Thu, 19 Nov 2026 16:40:15 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 6048E4057A;
	Thu, 19 Nov 2026 16:41:08 +0800 (CST)
Received: from huawei.com (10.113.213.244) by kwepemf200016.china.huawei.com
 (7.202.181.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 19 Nov
 2026 16:41:07 +0800
From: Wang Jianjian <wangjianjian3@huawei.com>
To: <konishi.ryusuke@gmail.com>, <slava@dubeyko.com>
CC: <linux-nilfs@vger.kernel.org>, <fengaojigui88@gmail.com>, Wang Jianjian
	<wangjianjian3@huawei.com>
Subject: [PATCH] nilfs2: fix leak of gc inodes on error
Date: Thu, 19 Nov 2026 16:38:09 +0800
Message-ID: <20261119083809.3918948-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200016.china.huawei.com (7.202.181.9)

Zhengzheng reported below syz problems:

NILFS (loop5): disposed unprocessed dirty file(s) when stopping log writer
VFS: Busy inodes after unmount of loop5 (nilfs2)

The reproducer called ioctl clean_segments on a corrupted image. It's
first argument is { ino = 8, cno = 0xffffffffffffffff, vd_vblocknr = 34,
vd_period = [0x30000000000000, 0x10), vd_blocknr = 6, vd_offset =
7,...}.

nilfs_ioctl_clean_segments
  nilfs_ioctl_move_blocks // gc iget 8, get one inode reference
  nilfs_clean_segments
    nilfs->ns_gc_inodes move to sci->sc_gc_inodes
    nilfs_segctor_construct
      nilfs_segctor_do_construct
        nilfs_segctor_assign
	  nilfs_segctor_update_payload_blocknr
	    nilfs_bmap_assign
	      nilfs_btree_assign_gc
	        nilfs_dat_move
		  // since there is no dat entry for vblknr 34
		  // (entry->de_blocknr == 0), return -EINVAL
		  // fs will be remounted to readonly
   // clean segments loop will be break because readonly fs
   nilfs_remove_all_gcinodes
	// since nilfs->ns_gc_inodes empty, it
        // clean nothing

ioctl_clean_segment will get one extra reference of inode 8 and when
segments construct do GC move vblock 34 and do bmap assign, it lookup
DAT table and get de_blocknr = 0, so it return -EINVAL. And since
nilfs->ns_gc_inodes is empty, nilfs_remove_all_gcinodes will do nothing
and the extra inode reference won't be released.

To fix this, splice sci->sc_gc_inodes back to nilfs->ns_gc_inodes when
got error.

Note that, when normal files add to nilfs dirty list by
nilfs_set_file_dirty, it will got one reference and when
nilfs_bmap_assign got error, nilfs_segctor_do_construct() also doesn't
put the inode, but as a last resort, nilfs_segctor_destroy will do
it(however, it doesn't clean sci->sc_gc_inodes).

Fixes: 7942b919f7321 ("nilfs2: ioctl operations")
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
Reported-by: fengaojigui88@gmail.com
Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2=4okHYZ-xCkpV-ekj-aSqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com/T/#u
---
 fs/nilfs2/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index af0c3560444f..ea56a26041e8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2588,6 +2588,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
  out_unlock:
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
+	list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes);
 	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
  bail_unlock:
 	nilfs_transaction_unlock(sb);
-- 
2.34.1

