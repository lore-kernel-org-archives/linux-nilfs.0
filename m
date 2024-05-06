Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8162E8488
	for <linux-nilfs@vger.kernel.org>; Mon,  6 May 2024 23:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715037890; cv=none; b=c0+RHYxmxBDMqcid1raVNLeongTsIDmtbT644NjCtcRBx7weDOZUQpfIT8mkunDu6a3qw4Lhin/5h4gPMpz4aiEtkuAKME/eHOTw8aS8qYHYGvFISbPCwRjnBO/OtA7a2zQse2H86O4ZarEhzMCP55xKeqkgT6YBXq3BnjZMsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715037890; c=relaxed/simple;
	bh=QhGDhMWXWEtrmjTBKxBKcmQQWmPDgP3L8g3cYvBvcI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iwZDxFJBhwF7lGBkxcyFPKzMx5BywHpzUi3aLjILh8E8ZyHD6AUi9C/d06XLXqJ3brpEJzizprVhLOH5DkKhoYbB+vAQubfDhhA+jTrw/jsrLwm4efdEUyQTRtmTGEKwOKw/wYFPkDZOY3vhsiOrRXhEtlTO9FyDkCEH3akJitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Gh/UZVJA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Gh/UZVJA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VYHYq5P1xz6Cnk97;
	Mon,  6 May 2024 23:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1715037885; x=1717629886; bh=fTgzzscU3+ufOn2XdFXt8PMkeBidwOwoFHx
	wv4TLm0Q=; b=Gh/UZVJA4zpL/AZbAVoEXw/Lml4QV+Vx9JPSg1KVjDjQ8HSjucq
	pCv/WghYgFnAak1ORTrmJPcVNWaqpTGqNzmHMbnfJqcR6HqkBv0XEaK2UiAfR+PA
	v/otecT1KwUaWqKHekeN5EIVrZPMw8x/9yqjl4E7BYUukV2Kd6pv2FhINe2Vrz7D
	ER/paCheE7bMH7p2xdUnhEa7H7S5a3zRbFVhmY1MUTPvhV8wlpSynJSYCa1Jvvsr
	YDTXU756idz46BkIh0qLKu4Bp8bTdvVrFZ0SrXrayvi65ZYDum6nwphAakY1WvXJ
	yLUQAHeMWkUmOo4cRjiNpuglAyzwyM3ecyg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oahrdoHPsgwO; Mon,  6 May 2024 23:24:45 +0000 (UTC)
Received: from asus.hsd1.ca.comcast.net (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VYHYm3BWbz6Cnk95;
	Mon,  6 May 2024 23:24:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] nilfs2: Use __field_struct() for a bitwise field
Date: Mon,  6 May 2024 16:24:37 -0700
Message-ID: <20240506232437.21264-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

As one can see in include/trace/stages/stage4_event_fields.h, the
implementation of __field() uses the is_signed_type() macro. As one can s=
ee
in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro once"=
),
there has been an attempt to not make is_signed_type() trigger sparse
warnings for bitwise types. Despite that change, sparse complains when
passing a bitwise type to is_signed_type(). It is not clear to me why.

Follow the example of <trace/events/initcall.h> and suppress the followin=
g
sparse warnings by changing __field() into __field_struct():

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/all/20240430080019.4242-2-konishi.ryusuke=
@gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/nilfs2.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.=
h
index 8efc6236f57c..8880c11733dd 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 		    __field(struct inode *, inode)
 		    __field(unsigned long, ino)
 		    __field(unsigned long, blkoff)
-		    __field(enum req_op, mode)
+		    /*
+		     * Use field_struct() to avoid is_signed_type() on the
+		     * bitwise type enum req_op.
+		     */
+		    __field_struct(enum req_op, mode)
 	    ),
=20
 	    TP_fast_assign(
