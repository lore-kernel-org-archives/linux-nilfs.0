Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F95695;
	Sat,  5 Apr 2025 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743847044; cv=none; b=V22IEBU4xWaTl035WBAuN38DOebzJMQIopgHPGHanm0wxE1hnzhACZgxDU3a4bvPVXG+rtexoodXlJRZfTCgvx24YtvjABU+Sfw4MsxT9w4vLhYigWteoO+0XL0IjPQzaJUO0m5yPvcapDw4VQ1410IpfscEnW6CUhNxzJvmx9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743847044; c=relaxed/simple;
	bh=gcqY1n1uy0b5quuVXJUS/njdTpe4/lxKq7CipKuDqLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G08G0VWiJGDR7LvoKwRciHOpXnG3jfPF3CUPdsdQKZHPyZqg6P4kUX6KGaUO6AGCmaMjY6rrxnuqx7mVcJZNIRq1Xmuhjl3I0rwGcVQsUCSOhBdVqHmP3U3RlQhDyeCjjzz1KO1l6h34p/o6NV2GHU/oyZ6XBX1tlQNIn4f3wWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [221.222.48.127])
	by APP-05 (Coremail) with SMTP id zQCowAAnYwtt_vBn7PY1Bg--.43264S2;
	Sat, 05 Apr 2025 17:57:07 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH v2] nilfs2: Add pointer check for nilfs_direct_propagate()
Date: Sat,  5 Apr 2025 17:56:40 +0800
Message-ID: <20250405095641.2009-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAnYwtt_vBn7PY1Bg--.43264S2
X-Coremail-Antispam: 1UD129KBjvJXoW7XF1DAr4kuw4kCw1xtr45Awb_yoW8JrWxpr
	W7KF17KFs5J3yIgrn29a15Zr13Cr17uwsrJr48Ca4xZrnxKF10qFyUta48Aa13Cr45XFya
	v3yjy3WYqFyUAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwsDA2fwn8GfzgAAsU

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer.

If the pointer value obtained by nilfs_direct_get_ptr() is
NILFS_BMAP_INVALID_PTR, means that the metadata (in this case,
i_bmap in the nilfs_inode_info struct) thatshould  point to the data
block at the buffer head of the argument is corrupted and the data
block is orphaned, meaning that the file system has lost consistency.

Add a value check and return -EINVAL when it is an invalid pointer.

Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/nilfs2/direct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 893ab36824cc..2d8dc6b35b54 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -EINVAL;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
-- 
2.42.0.windows.2

