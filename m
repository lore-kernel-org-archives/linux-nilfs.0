Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F2536EABE
	for <linux-nilfs@vger.kernel.org>; Tue,  6 Oct 2026 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272792; cv=none; b=Xi2D0cDIL9RnVrgRmEV19f8AYUUCS8zLfRNul3iWzOhqFPOmB0XHrsWr0JngRXXZQHQJenpzWNYtSkCsCIz9LLSfSN3AP4vjTrwl2ANXK3TgIsFl1OJz8A9q5IOYVmogPb42sirUMyD/iz/Nb3uFDHkRKoy3UHXI0aHITopYR9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272792; c=relaxed/simple;
	bh=UdG9F2lIHer1xG4Zoqrwu6VKdFz+R7tVZFYTs71Yh38=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ujVhvvaUByOhbj3EIlHI7q7MNalTVIxms4ZQGFfhvB4I/4aYtIW88G+Nrq0NOdVz5omLtdJWKNaCkJgyurq1hdym/OhEzzc/RQgH/1hoHcHOTFJK3mz/xK8Az3lDa8HVcP2/wN1X7DucdsKXPwdnjpTEFg61mAvG8YwtkQkaR/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKsYcXYf; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKsYcXYf"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1c9879395so124749a12.1
        for <linux-nilfs@vger.kernel.org>; Tue, 06 Oct 2026 00:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791272790; x=1791877590; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:from:subject:cc:to:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ahYM4NlVkXWvh95ZjInYaFIKIIi23AFsDJ4bgdm9aQo=;
        b=YKsYcXYfn5X/Jrs3PPzhv6MUsuRWzdijsU+AqPwXztwPG96gafPz+yHvJO0oCSFGcx
         cqWeD08ZnUPBUAYGenJwels3lvDg7bHBzZkX9ZQhw9BdANMmCCU4rAL0GedOE1mmTGR5
         uke61gOGyDU6O3JL0VskWJgRREJxW6je60yFJAMFHx4dXgnLEws+dIrzE2ON4JTP10E0
         Wpx1r0qNt5jt0uHcmqyF0uHtHFeuAKCc7Fty2Jlec9/CPNpo1wL4gDWQUQSlPNH2AxGV
         tP0egOK/A//mLIU435osENlRbGwsiK7wTNlzNkxXFxpHeRBXyoH1m5HEIgRY+AIofZj4
         5nUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791272790; x=1791877590;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:from:subject:cc:to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ahYM4NlVkXWvh95ZjInYaFIKIIi23AFsDJ4bgdm9aQo=;
        b=ZVBhqYbOETsG8IVn8IYOHGgiEfz9WqQaYxIdQxqzGtjGP/KURCfRhI5qW9E9H/4k+9
         lCBmad0+rWxrcB/fZ0IAG1eSqxLri/0KQQGj2CzERCFgsESdDs3rLbj7c7zZnhedAZaK
         1BUw2CIqfe0WQTL+ro/wcLZMsWmmvHRjpwsRIn38qqazn/N7AQUB5AJATWmdrnxt91KE
         /9W9Tyb9w5dHxdB8s2StPA0K2W3n3ge5/gs+hNEqA1n8t9hmjk8chiC+R93HIuQ0jt8u
         qAoKJczYySPPt7MKGpvMuuAuVdDPzkgRENVpOukXyyPS5dNCkhd5jPELNIUyjNLLV02S
         2Xsg==
X-Forwarded-Encrypted: i=1; AKwUvBzQQ7e+lOp0sVk3XfYvwhWBHPbUwJr2+lDHvolba67g8e9JMbhaCxMtczCVetViHiG0hpHr9R/ObDnNJQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lFfhZOZIjr23Dox6DyS+cDBsQQR5g5mu4STuCtpmx4rbMxuOkg
	hGa8vj25XyD+ss9Eh3M4li7SJcClEN2QxM3tgd1K6cjwCPpyV4SQFumr
X-Gm-Gg: AYBFou3TwZ3dAFzZIynmpZSb9gWKAW9Bo6NFq8CZL6euntRwD2n+KQNulv5T96gsQv+
	oyiimx1F1mxU8Mm9KuPuEgXpvXbeSawKC/JJ/nfYBRK+iXTpMDDmdGzInp7DN/OsD+nz4k1xON1
	8ZbfTzth1C7Z3fwaA3f02HD1TonRlt8dZiepQRRh9kcqis7PZhaJNX9A5a4h4ejNS5SuNwpKkkj
	VWcAPZHacYD6M3rz9VXWjY68n0zthHnt8VCjHuWzWQgjNTuBiEfDI42u0CibyLLv8jz6ErLVu2t
	64juDOkqtoGVHTq5lia9GXX9CevGWyIOWIy1l8OQFOaW4O9OCJbIaLHLb7p7U391NQgMqiHV32v
	bH0a6Oqx+tBreNURJe6n2nQoX0trjA5RW7r0Vc3udX0Np/NkoWeqGKDFm8UkHIUwoztxMc/B1Wf
	pudeBCFAAUZP27moHkKQfiaTEf4CZjVVut13FoaFQaS/BQoTrykL+Rxpy+qYaKA7EYclIDsTlea
	6+zJA8bZp6BexNLcgtm9nNUCw9g6I22
X-Received: by 2002:a05:6a21:b90:b0:3d3:aee4:66f3 with SMTP id adf61e73a8af0-3e1247c1c61mr592829637.25.1791272790301;
        Tue, 06 Oct 2026 00:46:30 -0700 (PDT)
Received: from localhost (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6d901981sm2029776a12.14.2026.10.06.00.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:46:29 -0700 (PDT)
Date: Tue, 06 Oct 2026 16:46:26 +0900 (JST)
Message-Id: <20261006.164626.1711564426255042769.konishi.ryusuke@gmail.com>
To: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-nilfs@vger.kernel.org
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_rmdir (3)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
In-Reply-To: <6ac3ffc9.34119e79.2f92f3.0037.GAE@google.com>
References: <6abadfc1.69bd487b.a6f8c.0008.GAE@google.com>
	<6ac3ffc9.34119e79.2f92f3.0037.GAE@google.com>
X-Mailer: Mew version 6.8 on Emacs 30.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git a90ee4305c4a

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e037e0c6e31a..dcfa70f9e5d4 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -341,10 +341,15 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
+		if (unlikely(inode->i_nlink != 2)) {
+			nilfs_warn(dir->i_sb,
+				"inconsistent empty directory link count %u (ino=%llu)",
+				inode->i_nlink, inode->i_ino);
+		}
 		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			drop_nlink(inode);
+			clear_nlink(inode);
 			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
 			nilfs_mark_inode_dirty(dir);
-- 
2.53.0

