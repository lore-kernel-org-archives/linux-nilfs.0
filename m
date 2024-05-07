Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADCE71B3B;
	Tue,  7 May 2024 22:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715120460; cv=none; b=rTTgKRu9G4wAjFGvGooZ6pvhWMe43uAcMsn29K4RS/mstnusQ1GK9Il+NAe9/p0MfoXR2FQAX/nxnxXFItiMzgyux+/Kwad0VAhU3GnFrkqfGyNle87Yd9F/hO+qffEoSNCFUVSmemTzzD3rDSALGLuroi44hEn6yQGj+rDnwjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715120460; c=relaxed/simple;
	bh=HF/6ZRvBDsf27X3eJOND8Urh1pLKofHMissu9BvMcWw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pTr5pt878MYa2gSUYInTVA1ahNhTNGCM6gu2D4xT/ymobgdWQfl3+pc8pAmTaveP4pqWL4bTM9e+MI55UlHWM10zPNTpQYkZOSg7m0cjPYnxtvCZ7j6t1fJlomQrNlVewzsidNLyUe3GSPQkobdWybGwmt+QnBBOpO2BcALAQfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knpRnSRQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knpRnSRQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1ecd9a81966so1909505ad.0;
        Tue, 07 May 2024 15:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715120458; x=1715725258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sEVwJv44zaVqMvBXpLTR8+D9zvixnfOEIX/GYYRWRRA=;
        b=knpRnSRQtmX6L999Pirikw4Fsfr6rmAkyl/bY3SBEnqLPGdM579nS69GixDMml+g32
         mvyLM3VlTY4vMqNyzbl4Z63ICXLIqe42QPDYdNp0hAZIRps15OGcb3YuXpOFTGwBupF8
         GhWbDxOtPgHzmPSH1Gnay+aXAmDiWTaCIToZHSEEQ9bMaVzcir9MUi+++OW68FSvvGEM
         4oUbyuUtOHU57Ich7ZVs+7JeNPIyQJPQYG2Q6Nhw4LO/E6ZUGfYIxXorLPq6C8PwyZp9
         irMIXWM+M8HfuX0dzPO4fHr7fh64Ub8Y9syvQc0KhIe4GUErB+MODcnhJBKWpG8OjkVI
         Tpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715120458; x=1715725258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEVwJv44zaVqMvBXpLTR8+D9zvixnfOEIX/GYYRWRRA=;
        b=O3ODsIQBg538DHT5sENpeIRzxEWTkVo3spcimOAUh3vRnlA3ee0YPeJAtmfpu9kfPl
         s23g6cMt97P6os1ZIYZb296/HQRT/xdM8QQJppXyLJZFc6jcy9G6ogx+yKQNmarvCJiS
         nxgBDQA/FxaexHuKfMUbI9m7JVr91Mk4neqkFXf1ymULFt0OwChs28z0uE4ttgSKZMz2
         RZ6zZjnOM/VHgqJIOpi3uMEA/m3sUe5PzM+rxYfQZ79n6Dh/mbz5AaJgVMEJB4BnxOgw
         G0UfOmcIKmylQ9tOaNxDoyjH0LEpsociuQdCd3OkGqbyN/vdQbnnwwc2R5Fw3vqU8W4h
         CN5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFV5ZOg+KqBXgzwwL0jDEdENKKWLKziHX8JnAan/irSf8QOOxejLAh4S/vURxQ2OHJBpAiSmsuqIjdLpG4cFLtBM6KUjy5x9cCCKK8
X-Gm-Message-State: AOJu0YxF86s6R30lO3Twlc1x1sfnltELQMZHWUm75YMuzjK7S9jV55mq
	rRaxX+Q7erss/5J6vevw5BuJAdazYYQgUf/GSWmn0AE9rX+aTA1n4+rljA==
X-Google-Smtp-Source: AGHT+IGBOak3Io8zzYPbf5kuvE5Ud0zN1yRHO6LH8LXSlmJHssF0uuEwQOKxjp4sO+84bDEW2tYTUg==
X-Received: by 2002:a17:902:d2d1:b0:1e2:a1a8:5f49 with SMTP id d9443c01a7336-1eeabea21bcmr16203835ad.24.1715120458539;
        Tue, 07 May 2024 15:20:58 -0700 (PDT)
Received: from carrot.. (i222-151-5-6.s42.a014.ap.plala.or.jp. [222.151.5.6])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b001e512537a5fsm10545132plx.9.2024.05.07.15.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 15:20:57 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH -mm v2] nilfs2: Use __field_struct() for a bitwise field
Date: Wed,  8 May 2024 07:20:41 +0900
Message-Id: <20240507222041.4876-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

As one can see in include/trace/stages/stage4_event_fields.h, the
implementation of __field() uses the is_signed_type() macro. As one can see
in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro once"),
there has been an attempt to not make is_signed_type() trigger sparse
warnings for bitwise types.

Despite that change, sparse complains when passing a bitwise type to
is_signed_type(). The reason is that in its definition below, an inequality
comparison will be made against bitwise types, which are random collections
of bits (the casts to bitwise types themselves are semantically valid and
not problematic):

 #define is_signed_type(type) (((type)(-1)) < (__force type)1)

So, as a workaround, follow the example of <trace/events/initcall.h> and
suppress the following sparse warnings by changing __field() into
__field_struct() that doesn't use is_signed_type():

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

[konishi.ryusuke: described the reason for the warnings based on Linus'
 explanation]
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401092241.I4mm9OWl-lkp@intel.com/
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/all/20240430080019.4242-2-konishi.ryusuke@gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 include/trace/events/nilfs2.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
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
 
 	    TP_fast_assign(
-- 
2.34.1

