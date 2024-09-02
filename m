Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CD1311AC;
	Mon,  2 Sep 2024 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725268722; cv=none; b=XaGu1ZFFV6PTR56E6fkM9WJhvEcaUR2pz6w4QKU1OFgOphI6X207Omyw7n1+yEhrJsk3xEKNKWGChPbVwE6NghyxFo8t8lIMTHG9IJ2ZyldySwVxYXCH7932GcXR0aIAKCEeDeLtjRxRZPHovmhGGvEz0pywtionliXUOWjC/1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725268722; c=relaxed/simple;
	bh=mYnaA3W7BnHNcW32FHjhvnG/23Om+iW8rhoDnTRFG54=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GI6I+zjknmed1xr8QaCRa6LQZRSF1QyzYqzy4VVsNdAZ0x7f24go0Roo1XUHDy5NIB6W1rijswbv7mC8J4XnYmiYESsPeyp92d/i8OncxRnUSm9C5aAoNaVKtm5TtvQBnpWDk681iN8mrTCHHcR/SYbjRPtwtb4lOixLxyJfIEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4825A2Nd013860;
	Mon, 2 Sep 2024 08:41:12 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 41brd19sb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 02 Sep 2024 08:41:11 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 01:41:10 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 01:41:09 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>
CC: <konishi.ryusuke@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-nilfs@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] [nilfs?] general protection fault in nilfs_btree_insert (2)
Date: Mon, 2 Sep 2024 16:41:01 +0800
Message-ID: <20240902084101.138971-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000b4cf9a062114d132@google.com>
References: <000000000000b4cf9a062114d132@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: TLeBWkCKMHm2HmlA-6bx02Lq4ZpbSbHI
X-Authority-Analysis: v=2.4 cv=Qdk0vdbv c=1 sm=1 tr=0 ts=66d57a27 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=EaEq8P2WXUwA:10 a=MgNYAwz_8sOnGxLQ4WoA:9
X-Proofpoint-ORIG-GUID: TLeBWkCKMHm2HmlA-6bx02Lq4ZpbSbHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-09-02_01,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxlogscore=934 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2409020070

In nilfs_btree_do_lookup, if the number of children in the btree root node is 0,
path[x].bp_bh will not be initialized by __nilfs_btree_get_block,
which will result in uaf when executing nilfs-btree_get_nonroot_node
in nilfs_btree_prepare_insert.

In nilfs_bmap_do_insert will run bop_check_insert, so implement
bop_check_insert and determine the number of children in the btree root
node within it. If it is 0, return a negative value to avoid calling
bop_intsert.

#syz test

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 862bdf23120e..d7fa4d914638 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1231,6 +1231,17 @@ static void nilfs_btree_commit_insert(struct nilfs_bmap *btree,
 		nilfs_bmap_set_dirty(btree);
 }
 
+static int nilfs_btree_check_insert(const struct nilfs_bmap *btree, __u64 key)
+{
+	struct nilfs_btree_node *node;
+	int level;
+
+	node = nilfs_btree_get_root(btree);
+	level = nilfs_btree_node_get_level(node);
+	return (level < NILFS_BTREE_LEVEL_NODE_MIN ||
+		nilfs_btree_node_get_nchildren(node) <= 0) ? -ENOENT : 0;
+}
+
 static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
 {
 	struct nilfs_btree_path *path;
@@ -2385,7 +2396,7 @@ static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_seek_key		=	nilfs_btree_seek_key,
 	.bop_last_key		=	nilfs_btree_last_key,
 
-	.bop_check_insert	=	NULL,
+	.bop_check_insert	=	nilfs_btree_check_insert,
 	.bop_check_delete	=	nilfs_btree_check_delete,
 	.bop_gather_data	=	nilfs_btree_gather_data,
 };
