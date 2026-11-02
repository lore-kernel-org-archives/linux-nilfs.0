Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631440;
	b=URqDL0Tm0s4q2GDh9aKW0akyWMIGEYu/kAfogqPKLkL7p9jdW7+iJNGgd8rV0vaTeeSF
	 IlonZxA5NT0S5GhlO8OzV0CxIJPYl1h0de/6ei0Oo8ZauG6Z3P1HvyRqeC44Sey4uogqU
	 rgNtRQzqK/5bu75Ku2/jSm5C6AyS82CnjgiGnHWhNxsWVS9apbZ4eh9yOQYJySTdb5faM
	 gsh6IkrKdLh8FIHtoPwCkXp2Sz4CRJUDPCuaOBZUhvd+dq0zLM2uLHIOl5Q40PcVDZFJ8
	 Mdbaj4hxWpc/NIlZ6+zrT3GT0HyZSpoULHO6VwGem3c9Mu+UwTD0pKWpEmOmqzvv6Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631440;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=k+303IJCbVIsiYcHUPyH0auP1YHSdj6b+qMJSSoOTj8=;
	b=ngt8GMSIeJJeMsDpP7ozaOKHUtKUr8qOSD/zJ7dZRK8XSyb7okmCeJYZh22L95JM4JJY
	 9cGHdKibZvGsz/q5VtC8lQi+oHziZEArQXmgWUNKTwM+zv7RHwO4nRnOp2bth5JtrpzLF
	 6tD44aJMnqcbBeradkkmce2pZRu2UJCgCJgTsVfB8dxY8m0X7Qliz54FJVySJCxAsIWop
	 jAMQCbngMDLLezYW2F4oYIWPn/YUPa+UGC7MYWlxqZVWIseZ0diEMvPXYmk1gp2Qwt3oZ
	 GqGvwmV2gieCxRiHUzeFH4BXNmRtDwZBF077gOqJXE3DHQHREjtf/d6dvh7uJRqGmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=aKzxUBoW;
	arc=none smtp.remote-ip=162.62.57.210
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F38606A59B
	for <linux-nilfs@vger.kernel.org>; Mon,  2 Nov 2026 14:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6F38606A59B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=aKzxUBoW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1793631432;
	bh=k+303IJCbVIsiYcHUPyH0auP1YHSdj6b+qMJSSoOTj8=;
	h=From:To:Cc:Subject:Date;
	b=aKzxUBoW1MMz7e9zi/9vPP8RqKhqx6okIIBswbgNtJg2IMYtnhiw1beheZk00S9zw
	 YahuwwwpzbZYdws3KsBMjvHMztkoWh8HTJf5BVOh/yzZz2HIN9V+KbDMdYRdtIujcY
	 Ush+B1zaMGcbzF7Vsx6U3ZtPFYXCTMn+rNFVTK54=
Received: from mypc.. ([2409:8a00:2545:d0f4:3ade:2e95:26c5:7e2d])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E4A33C53; Mon, 02 Nov 2026 22:57:10 +0800
X-QQ-mid: xmsmtpt1793631430tbzpj7qil
Message-ID: <tencent_825910BE6531B413457C317DA7E19EB93D07@qq.com>
X-QQ-XMAILINFO: MeukCuWaRbQl7ONQJkr2FDl9PCx76lYErNmXmveG1y0sQCe+TJykqmGAwWB3pC
	 jepDdf4TdJx4F1jSI1F6FK5PcoV6PMhHdDWSy6D3tbu4tbadbDY0Hedn5jhCjeLH3U1S27zH51+5
	 IYhKxaRkhr5Gkwb1uyPkITrsYPQkt40vtJKWyLnVfRlFgHse0GMgaXEMGifhadvaQ1piZdx3ZV33
	 69RHX6sfsSoPy+abH4zi2NCLtd5FIGmZR3y94Nc1s1nmz0pDIAjkcwj6Hsu0wfI6iPV72GKKZ0K7
	 3Y3VFNrlhAKlURnKrCL6aIPgXc8daa/3NWNov6JIaowRG/8Uk3oqx7Q5hs81UYo58B2CepxTJbFF
	 73/+grbWJFd4o9w0uTHGj4D0AH+i378d+GnBwUha9IduH6pfZwRnQUNa1CbhWkw/oflaYgmjzfKG
	 oa5Qr5yRbZvZXqw8IglMKExP2TKpqZte5JzG8SMs9dTDvJKW3RgZxNELkL8SHZl34BNiYs6rt9dN
	 B3EfFrG4/1xXJHQPxEN7FehRIq0zXf4HOpL8WKdSfJtxBJczmv5NkQsc8XVGgIYIgiUey7xJhVQ9
	 opkcQ8q+ToQay9E4dcr4MD0A7MlVXkPAk4H1aDptf+1NFqwQ98k7FRoXXjFdyQ40bNOI5U3ZGnhs
	 uNdYqZFJhEIXNwyD/dbg1tnywAtTv+W+jNDnXoUYovaZn/J4Kw0gpFL3aTyhL1Eewoa9GjkR3ePl
	 IPURoHZ7sJZfoisssUn7p6Pc5KGKosH4PZgJ31r6/yIlNugWf7FeEshEnHvzH4C5Yt+SpoehJO1j
	 jHXGnVsgHyhcKNw6Oq3BMedRNa2zcmcVhmHVIxXftIyvrFIXyElodOObGeL61p++a/5o+krPHZlk
	 f+BjymNJjsOQ6w4SP5pJCENWpBgUlv1qB3vnoq/myUZNK8cx4bmDsC+9vdkUB94aaoEjgRYz2cvq
	 /2idvrc5AgoTk+gBonEPc0nvWvrVOFaYag1JXYUFe+fqIgJzNfeL3U36tYvgtzwlU0bfNSyKfUw4
	 APHMpJFhRN9RSihHX6htqgR0SMnte9hGpNPgMoQ3hEewZgdZTIN1UnKFTGTQHFbHCOF0rgVZBTMw
	 b/ngfMXk7nWg18F6k=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: wangjianjian0@foxmail.com
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH 1/2] nilfs2: add NILFS_FEATURE_COMPAT_RO_ATIME
Date: Mon,  2 Nov 2026 22:57:07 +0800
X-OQ-MSGID: <20261102145708.18588-1-wangjianjian0@foxmail.com>
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

From: Wang Jianjian <wangjianjian0@foxmail.com>

Add read-only compat feature NILFS_FEATURE_COMPAT_RO_ATIME, for
following atime support.

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 include/uapi/linux/nilfs2_ondisk.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index b3442b16ff6a..19587700c92c 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -253,9 +253,11 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_RO_ATIME		0x00000002ULL
 
 #define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
+#define NILFS_FEATURE_COMPAT_RO_SUPP	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT |\
+					 NILFS_FEATURE_COMPAT_RO_ATIME)
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*

base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
-- 
2.34.1

