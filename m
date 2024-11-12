Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D121F77A7;
	Tue, 12 Nov 2024 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731409267; cv=none; b=LX1E30uA/CnbjdJD/O9l1C9c6bj5R6Oip4Db2QG9PPemCNYaS11PihZHUZbv3Wriz3UPITmgKxdaB0qaLTXHXq7b5ppRRRMqDtC5OBjsYl+YDYMKGIxAC3/prCk48BNZgj24qtBp3MLsHX7JCid+JvlBwNHwZ1MGCSfsTjDEvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731409267; c=relaxed/simple;
	bh=HD8whapfYmvcrd+Tc4Wd0RY3N9kWe8uq7YUypxnRdms=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=A9aWPhpGng8IdU1BEH1LWDux1boauHL9e8TJXytH7IDzGJHNOIGnAxZlPddPGp8t1Cjyu/e2X8Znw7keptYuIQIQZTOpKrmUmSvc510T4QWKqm23ra3zSwzrkTGHTPirGcEKmUbUVnXaOAoep42rjDvFRpnZqYXRhUw2djOkRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lasDZ6YS; arc=none smtp.client-ip=203.205.221.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lasDZ6YS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1731408960; bh=+iVYn7cc4Y6tKTf487xZKVqWUWZ+Myao9FCG5NP3SnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lasDZ6YSFePT81npXe5G42TbgfppoDdRCZAHLGJaMXPcK0tPbgejUaAe4PyahzaVY
	 gNuTOFOl9zhFsxlnWx9YTXBQQ+nmC6w+/VdeVzXGBNfMl5JO6pUc/Rxf6H3z/6Cptp
	 z4SMt8UecDF4cKOBC3U5BJYmEK1sujLdoZnsMnco=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id DF9B0A22; Tue, 12 Nov 2024 18:55:57 +0800
X-QQ-mid: xmsmtpt1731408957tybknkk7v
Message-ID: <tencent_4A46BB45335A9E721B634B011B242548BA08@qq.com>
X-QQ-XMAILINFO: Mm/8i8/T4yneg6U2Wcsf3c0uojxQ+XdWGVj7jiquTd91Y06lx8DKpnTuygm/UX
	 4fI4WkRLA/O5CtDySh8fPxzBVp1VpI90ZsWl+k4jOen54P3egk8eqNCFFMhStiaz50ZmKpyvrjhN
	 xdXIJYjx3qUteJiwi8t1LLdostsFPIGtKEjnoIdVg0ORjzZiGhz/2z3lDRpbMsiZ8zHlM3o0Gv7Q
	 yL+CmGJ/AvJciOrknBwm0A+F7madsUDMBNEChBsR9x3VN/XJLyNllnvSuWfX3byTb8GsPeYUO9HT
	 J+LLayX17Xn77kGLCAIcoaqvkhSJOcauKAkFypH1Xq3QhTbKAxXRjIw7oH81RGnFdYIgsbbJsmPo
	 NrBZMZhUlkZP4BQbxk9mbTli8kk7my6gqL9cDCQbvXntSsL2eUlUNu0osF9wm72kg9fG39fovvGO
	 TnvTNppkUvvCzvox5iIhL+HoTUtT2XXjHV0uV+DxCciZuZkYXu5PlxulH8pP/YrrzAcMD/gkfHFj
	 1HlT62zxiy59paNbkIRILkBpHScCu0+qK0gcncVk+V0NoAMYvvZc7j6+xzbZnb8wYLI0qO5mvar3
	 MVNwh3ezHu8JcuCfY6soThE0bur+JcW/t2Xp+Q/yn97zbys+sPliYxg6PDaClxolB9/kUrOMAzhQ
	 DaoK9Xtc2O/Ol57GZBIwM2LdtbPn09w6itUf1NYScOiD1L5d3Gur0qcaiM82QmmcXv1VvOfzpb92
	 lOMSJofmUiRQKcendc6Swe130lC5Jav0g/M4S1BX37aMU+vSFcaudF62fqQbiXfp9L7NQlpRvLB9
	 ATyF4sjZ8vEGenXjl+j1K3fuHzOW7liWvw/CcKYYZxsLMXrjys6gsD8h7PkrMMn+Fl/xdIK5zKQg
	 dyr/jKWMeQPaljLFrfKnEqOFe7YqxHhIkQNynx/5/HYDJ8NyHuQGunwRMzGcycikYtA0+XdJeH
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
Date: Tue, 12 Nov 2024 18:55:58 +0800
X-OQ-MSGID: <20241112105557.1541067-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
References: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The i_size value of the directory "cgroup.controllers" opened by openat is 0,
which causes 0 to be returned when calculating the last valid byte in
nilfs_last_byte(), which ultimately causes kaddr to move forward by reclen
(its value is 32 in this case), which ultimately triggers the uaf when
accessing de->rec_len in nilfs_find_entry().

To avoid this issue, add a check for i_size in nilfs_lookup().

Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/nilfs2/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9b108052d9f7..0b57bcd9c2c5 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -60,6 +60,9 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	if (dentry->d_name.len > NILFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
+	if (!dir->i_size)
+		return ERR_PTR(-EINVAL);
+
 	res = nilfs_inode_by_name(dir, &dentry->d_name, &ino);
 	if (res) {
 		if (res != -ENOENT)
-- 
2.43.0

