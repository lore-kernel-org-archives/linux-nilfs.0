Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDCE490BF6
	for <linux-nilfs@vger.kernel.org>; Thu,  8 Oct 2026 11:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460401; cv=none; b=sffIE3oSx7Il7PMY7zihU1dUdKlXoOgScSbI5ez6UeY9X+aYR6qxlpQujm5hpW9xQBT585isybKBTS7aKrBh3F0mWOoxJxSRKAssHGreUzgqZUiJUXmkwMcllzb4kOHi0fOd7blU3a9CmIq8ui5Gjwc1L64NPdzZnBNGRGgmxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460401; c=relaxed/simple;
	bh=tQLCkYgOuueSsGInQsIpwaB/A1sqQztPCjF/nclrYQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGsygPdgyHR6wq0JPQYTOqNahIEtVQJgE5jBq2j0H5TYPMLb5zdWYgJhrOxZpPwwgQD9BVCuSZE4NAp7MXfUZH2lSXxOe9fKyxngd9M2tkHnobVlZNn6fbAHOZm4uUX4MG9+d0bvogmDYyT/w0RlpRdLJNUHaRzKqV62wIlybvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dlkujla7; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dlkujla7"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so3053794a91.0
        for <linux-nilfs@vger.kernel.org>; Thu, 08 Oct 2026 04:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460399; x=1792065199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F7V7dLUe1L3c+eHqw7mAqauOhaayuccNQ0JvgXKLVBY=;
        b=Dlkujla76WargE/NtJmu+O/R4BWp2K8h2+UyzHBC69YnMWTlu7RzJ9ECTyRBqMh113
         bAxzUj0OPb2VmjTRqOPraaCYBdEYkyskhOBHRUO0YxXaRrdZtox93iKIFV9SpIDvwvYW
         xqVGCUK6NTMUYWaFH9t1iMZwJkoTRyU8x/hkyY879M/UPT81Yk3eV6ANAPi/InTCKP8V
         6z5MR1vISpBHgkCB0UAO6PLNCti4Tek2UDVr6+qhlJEn1UCbpTx4d9Y3XfWHHP1FRMO3
         HXxz4/OkaX2OttLcr1th7Le1+YVeHountmOzmZ8m3NZ79D0uAungm+s2/mHgIFBQZsSw
         GVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460399; x=1792065199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F7V7dLUe1L3c+eHqw7mAqauOhaayuccNQ0JvgXKLVBY=;
        b=ZVWAPj1CWmxZbSGvxLjnTzucmHU06KnWmJFGY6rDyfSWdY6GlJ/+mA3gvwCsmrL6rd
         o2tVf9VM5+ZsZbGZGah3j2eROaU/7pku1gBKMk/LSJhlNuUOkRXiniSP4O7lUsnO4itu
         +5KRg3+Jn8EcO1LunmUGlkl60Uj7BMGU5Gs1tIo0b5aP+eFTHP1LKQnUOeHsw9WZP5EL
         +LIpD3rOtK5s1U533lZCHY6fiwGZPC5NQAThWO6uWZaD2oRHkW+WyDjWkc5qV5JhDbk8
         4NiXROsdvQdwk5kdEv66XfHLuJpFxwKl8w+9yOGjnyDlw4RTXpTe9H2DS3H/3iE/vR0H
         qFRw==
X-Gm-Message-State: AFq9FYLU+hRvmXsgYFNR/YbjpCIsG7NiDEar/EodvJ+855bcNBIFoqJJ
	WP2y0iqErAr30MJoMpNAQ4YSLDVlcCcmJtlxt/6UdFWg9JsJlduXHwj6
X-Gm-Gg: AYBFou34R8QJGTy6mBZimTWyxK6fyEBfaEsEk9Pri19OtNo3UL+EvKJ7wpPL5oS7Gz3
	+WcnIuZYrv6ZUukc8N7wyr06uo9bOFbW4l8ofIs+wQjGkbocAJ6r7qwVEK0Ht8pRGpJ1cL3n6lU
	Lgn0e4ypFkI4TCcIwBjfUy9aP9R2xIRaLyfQO/x8i2QcvXmD1KDX315wdpNtwWitg4xgopwFVnF
	uxvDveT0Mt5SMTkFW63E3ygcx2rdd+21mz/zOxC2Wy++efGSxadR0hhYeezTdeJNvpBVrmVqZXU
	QhhZ6x0Xsbrn0S/bJaHrwxLQ1XHlxH1rUJyTjq0Dha27EE0IKRQkyaT4Qb1teCTgYKDovqemg5W
	HL6waKLSnkiIX1tH+Ttm2RS3uO87oW2OwRBEVGJ0jTe42kMaxn9FgAv5gK6Ues/nxTarZPzUD2l
	VvLtP+hmftJigpwM6Wu+5hjK5GlGXU1GIdxYm6BvE0PHO+Ud6zwI8sThlZEfZNJ8GkvHR0SSm8H
	sUpLKM8YztXJCUtt3gKvw0wfHdt4dcNxl5bPu6Sg6Xr4GG3BJHY
X-Received: by 2002:a17:90b:3d81:b0:3ab:c6c:51b8 with SMTP id 98e67ed59e1d1-3ab0c6c63dbmr747232a91.57.1791460398841;
        Thu, 08 Oct 2026 04:53:18 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1c17b63sm4760164a91.12.2026.10.08.04.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:53:18 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jake Labelle <southampton.jake.labelle@gmail.com>
Subject: [PATCH 1/2] nilfs2: reject non-regular inodes in dsync recovery
Date: Thu,  8 Oct 2026 20:52:47 +0900
Message-ID: <20261008115312.18482-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008115312.18482-1-konishi.ryusuke@gmail.com>
References: <20261008115312.18482-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jake Labelle <southampton.jake.labelle@gmail.com>

During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
inode designated by fi_ino of a dsync log without checking its type.
If a corrupted image designates a special inode (e.g. a device node)
there, the inode's embedded bmap was never initialized:
__nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
directories and symlinks.  The subsequent nilfs_get_block() then
dereferences the uninitialized bmap->b_ops and jumps through it,
crashing the kernel or worse.

Regular files, directories, and symlinks are the only inode types
with data blocks to recover; reject anything else before touching
its block mapping.

[ryusuke: conformed AI tag to guidelines]

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Assisted-by: Claude:claude-mythos-5
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index abe4101f7550..c384325a57d0 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -545,6 +545,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}
 
+		/*
+		 * Regular files, directories, and symlinks are the only
+		 * inode types with data blocks and an initialized bmap;
+		 * a crafted image can reference some other inode type
+		 * here, whose i_bmap_data was never set up by
+		 * __nilfs_read_inode().
+		 */
+		if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+			    S_ISLNK(inode->i_mode))) {
+			nilfs_warn(sb,
+				   "%s: invalid inode type (ino=%lu, mode=0%o)",
+				   __func__, (unsigned long)rb->ino,
+				   inode->i_mode);
+			err = -EINVAL;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
-- 
2.53.0

