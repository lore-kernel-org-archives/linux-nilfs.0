Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C054652;
	Wed, 29 Oct 2025 05:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761715766; cv=none; b=rpr1ZkaKmi/7VS2cNR7gBesNqz6FSR3PM1Mxm8L+0sUAP/RKTjj7ybpB6RrsI1FMsnLzGg1YnO5Yq8I4crWDrrKuss2BaP+/pw86Svc9CEQZifBQ4quCdyh42Z69voSMvV41mneVPYfwsqJIBQEJDhDDL1sHiuvWRP/AZw8AAYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761715766; c=relaxed/simple;
	bh=iRuX74GgjNLnLHSyDYfI9YOEboHzqkhZUvwQbsumsyE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=sYu7iJmonB4Baob4JQ7jfYz6CHFVcXHIFHcY9gjpkyBRseL7KZXxFc/lLyRDdNPiM+fyTA0c1rcdnCysoKpD6ApifD+b5m2oUG8A9e9l68PThWdo7L3R9YYCWHDTk2I165Vg2QxLtLTPD6rVEYinF1U0EvBI1vKBOGG0GmFFABc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Zv9p2w9G; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Zv9p2w9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1761715753; bh=DIh+8csSGjJQ2zoSLu9gHv9q3FGHiu9zAKN/fONJMak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zv9p2w9GpGy+bJSOx2IhFt0rGXbxbolyxptf+fKU8Rmbv65L7+bMtDWIo/627f7Ht
	 o2xEfcy9LUHTBLhWITioF/NpQ2LGGyBtDscWbzBXVg9GNjnCeIRrq0R6xA6SuWYmbZ
	 WNxm3DMw7vOhFibiy0XrQMEMtGwoyDVXh0ThDjDc=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.201.7.117])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 5C1882C1; Wed, 29 Oct 2025 13:23:01 +0800
X-QQ-mid: xmsmtpt1761715381tgspgkq2o
Message-ID: <tencent_B12C968C36824B2C74BD76FD66763DB13709@qq.com>
X-QQ-XMAILINFO: MzNwb/pqyJTkC03Q5VGJQF0pHFXLJPHmWwJKM5fK7XEto/rqA8Xjcl2yppJj8J
	 TJShFABbQYcHHKJWfIDECGnRQdjuA4Dduzgmlh4oUvQOo8KzNemiH02VVEq7/YWTzko3ODTgEwcE
	 ik+N9W6RBdcEidMkMY9StSwb+ktGJa9hvviQDuwOA9x+BWgrCT3O+k21m68GBmRcTbLvH3qKdcyr
	 7X2cS7Xk6Z48ua0T3y3lEVmkkNMgenQ42VsFceWgzof06ke51uH3NOptaDlkkKdE1vp8ggezocCp
	 M/U3JKd04lHVYZ/PuQ+sQUJDmxOuBRfKzm7nLfmej9aOSiLPOZE6ACo2JVQLrhow/DHRXNiXzVLS
	 ygIbywUsvnJCHPgM5xSqB1wzA/sUh6+3S3qG4DAA0osUCrdJ3NpPPMTfVD/TVyiruIXGnE2IVklr
	 a3PhfDG972ZAd4GLm9ceKfCQ4duvK9kyAiW9ka+FkhkI8glWcjmWjawA4jqqKgnBwvflX5jNPS/5
	 dzuXTtG4Xu6+XC5r4d2v0XarVaIZEFAByh/iCgcux9Dhb2h02q9uKZm4y4PAINWiM4GiMFAO4aBG
	 mpDF5oqFlXAFGg5e1S6xLwhxT26FhEeTXLK1uaU7wEYg7ct/6c5/kd8bGrvWK7yg49f74uG0BW6N
	 Es2A+VVOzyiKlUdapmcVZ4wSEqEy6UiTOcj8kvEYB//20pq8mTNPMGRm6soCJTeY+9TtKKF02cb0
	 WWmArqI3Nmg1+upAcWt4DicFMFPnY9r9WobeJEgEZSfRe19D1EYbAV3mIAGTLgRksMz0mDPQd56z
	 RcBOtmttJSHNIkzlehrsYL11pG5W/cayaUrr2ve/gnNl33PaQYraYNTYG4x0sMAvNEPjxMpH3QRJ
	 arOiCHsRPhcFiqpgvPJaKoIg/KlE8D5PsfKmukVmtQ0iKwKcVlGp6WI6kmLLNQJ5DruBwZq8P+0w
	 t1HSYgMpxcPf8Okxjab2bTz9wIT8RHkYHQL26yzL2MEEiadC4JSCQjW33LOX+U
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: Avoid having an active sc_timer before freeing sci
Date: Wed, 29 Oct 2025 13:23:02 +0800
X-OQ-MSGID: <20251029052301.3325543-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
References: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because kthread_stop did not stop sc_task properly and returned -EINTR,
the sc_timer was not properly closed, ultimately causing the problem [1]
reported by syzbot when freeing sci due to the sc_timer not being closed.

Because the thread sc_task main function nilfs_segctor_thread() returns 0
when it succeeds, when the return value of kthread_stop() is not 0 in
nilfs_segctor_destroy(), we believe that it has not properly closed sc_timer.
We use timer_shutdown_sync() to sync wait for sc_timer to shutdown, and set
the value of sc_task to NULL under the protection of lock sc_state_lock,
so as to avoid the issue caused by sc_timer not being properly shutdowned.

[1]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: nilfs_construction_timeout
Call trace:
 nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
 nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
 nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509

Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24d8b70f039151f65590
Tested-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/nilfs2/segment.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index f15ca6fc400d..deee16bc9d4e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2768,7 +2768,12 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	if (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
-		kthread_stop(sci->sc_task);
+		if (kthread_stop(sci->sc_task)) {
+			spin_lock(&sci->sc_state_lock);
+			sci->sc_task = NULL;
+			timer_shutdown_sync(&sci->sc_timer);
+			spin_unlock(&sci->sc_state_lock);
+		}
 	}
 
 	spin_lock(&sci->sc_state_lock);
-- 
2.43.0

