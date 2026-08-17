Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF43B71AD
	for <linux-nilfs@vger.kernel.org>; Mon, 17 Aug 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787002225; cv=none; b=iVCI0TgxAWfzb+iBYc9APjY0FUx3ozQdiBToDSVEDR8Mv1l59lVtqPKgYTALky7LnvRMz2zvzpeoCK0UMdadD+ZINq9OCKEHidyb+6SdtAbiQfFNUrKQKejgXC5uJLYRA03bQJliQiiyDgoEo3pb3X+ucHYxGJD8JoPATNN6USo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787002225; c=relaxed/simple;
	bh=1fYCMngdys2zZs7qRc6knPxYZbV0ayu5Jy+tYPhYK/g=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=LHBMoISYIneyALCVvYywrUHrYv1dKnJIaG8rod7/mv5RycuiDg0OotCaFy5huWQlrdxDwXQuxfKgB3leYXkWtBJqBrTJ2MvXZmHj38oDPD0aHp62EEt4iFiy77+12PD6AKPWqiD7OlAK6r6wrgDNqukTbXdQ1M3aBe+yX+I7jns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=MbrRvS8j; arc=none smtp.client-ip=74.125.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="MbrRvS8j"
Received: by mail-yx2-f4.google.com with SMTP id 956f58d0204a3-66c70bc1c26so1305843d50.0
        for <linux-nilfs@vger.kernel.org>; Mon, 17 Aug 2026 14:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1787002223; x=1787607023; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FVhJ2ewd4HxwfZgJS6na6LE7vcXViGw9s9brMAMq2rs=;
        b=MbrRvS8jv1DLRyZKwhFbP6zZFteLEDbwbRK5AKqGbOiuRFYmI0VHt+yacuVCfCN02U
         5um1ErqdETsrBKgMjzzRndhrDiwsC/K978sqJekbgTrfhoNvXEaWhadMwqgrBECYZ4/7
         CcZfmmARDuIRykslDw8Owvt9XvBO7+0h3zR5AI5wghP0SQBGDL7mf+UyIaQm7A4bHmpc
         CKD7BUEbEncnKwKusaLXdEYb6HlMvneo5FE+LHOGMh33L2KTOJaho7RS388QBfKDTtWs
         05ecgdQGx5w9Aq+QdiQUl6fNQmgaLiB7jy/CXfzwqrEb2QMKgpPeTfQwxAwG7ncmMwPg
         lElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787002223; x=1787607023;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FVhJ2ewd4HxwfZgJS6na6LE7vcXViGw9s9brMAMq2rs=;
        b=cOJTx8Ov0f1tbCTuQMhIQPIHdOGGMDbuI+LLMEW1dbD/Cvu4ueJ3Dr0bPxENK8VMZF
         M7H7BA1IubOFSEqHuZKeOItetzhferFJTWiFVSGAnuWDFzpFkOZnK1iYpAtV0SxmsRAq
         m07owHQ2fRWfPX89dKrie/NYkHCJtpra2Ysmh59JFYYUDs1JZucmoYv/YgEsPEs02a6c
         AlQZDAUq8RTDssdrEx/NlXrObG8Fm4dynZuoc/11FXHQnuqwPLo3wZqLBw2DYkhRXV9N
         xlyci80R/eGO3FGQEn7+2q//J6pXvGkGO+EeIFV9IOVkEo5kk/oeE+RldqHsNf2zSTJg
         /guA==
X-Gm-Message-State: AOJu0YwxfVZqWY740QKTgC7arXQF88vsPR0/ZnzTLioFo4a38h5Qiue5
	ac7qLeh7QLeJwI0gDGv3JGfCllxrm5RwCEFoaeYwnkKUqBX/iuTyMlx9+EAh7FJUKIw=
X-Gm-Gg: AR+sD10mzc8W0W5/Ce30zD0dLHSehrWRjCd+40ZDl+2K5VySqiFf/hQ4f1Em/YS4sRF
	KnnOnjvPipwOzrXPVgTuOiynSCvW9ZimQbxt6t67px7PDvW6K8G00lJDFDSOhR/p8R//mrB3Hjj
	Xr1OZGKlqmfWzUfivYeuHdGdzTuNuLsWFjk6dEyBhx5OUR6AdPD/7bCNC8KTg+87oW/lsiNpu2/
	laapdwvC59X3BcwwzScBqKg5BkLoiFHaQYZva2kD/CViOIaEfqTh7rgVUaK/2RCwaaZAMOgv/Co
	GOquU9xk7Dn8eWDvC7U/Ba9w+6AdMWdcCxplCBcSUPV7uaYqI4wM2djOKcOCOCu7kfcquDNrYRc
	yQmloSiEmB8EDJWgenKGcJKBtCYkDE9VrE/Dw74iwxSc0iuYUDjpz+OZA4CbhbsA16PUXfEV1Ez
	hQT+FShdDO9q9Rc5HfdKiWNOSP4AMQDM8HmGPf2L01UvtU0hoQFM2bRsBswfL6HHGoRzRElpGVx
	CFrCmEsOYJ9B/jNr1Qf47YhP44VW9MuHKBeWqEJo2Lxdu6pa9jD+ucuS0Wyu+kXgKdQ7oGfUi/q
	5EqxC02615bqKR3pEQmpWvXQRvie/LzwOb7NZxRfn6NxH95jt1mjEQ==
X-Received: by 2002:a05:690e:b44:b0:667:bc49:3730 with SMTP id 956f58d0204a3-66c72b2263bmr11705758d50.7.1787002222844;
        Mon, 17 Aug 2026 14:30:22 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:4c8c:67e1:45cf:b20d? ([2600:1700:6476:1430:4c8c:67e1:45cf:b20d])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cb41e5d05sm1384304d50.7.2026.08.17.14.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 14:30:22 -0700 (PDT)
Message-ID: <08b17180a30dfba73925ad1232efc92eeab6e2de.camel@dubeyko.com>
Subject: [GIT PULL] nilfs2 changes for 7.3-rc1
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: torvalds@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com,
 vdubeyko@coreweave.com, 	joshua.crofts1@gmail.com, manojkm24dev@gmail.com,
 david.lee@trailofbits.com, 	igorpetindev@gmail.com, wangjianjian3@huawei.com
Date: Mon, 17 Aug 2026 14:30:20 -0700
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello Linus,

This pull request contains fixes of syzbot reported issue and
various fixes in NILFS2 functionality.

David Lee implemented rejection of super-root inode sizes
whose computed on-disk footprint exceeds the filesystem
block size.

Igor Putko exchanged WARN_ON() in nilfs_cpfile_delete_checkpoints()
on returning -EIO and reporting a filesystem error via nilfs_error()
in the case of corrupted checkpoint count on the storage medium
because it is suboptimal of interrupting execution with a kernel
warning.

Joshua Crofts has fixed an infinite loop issue in
nilfs_clean_segments() reported by syzbot. In nilfs_clean_segments(),
if err is non-zero, logic logs the error and sleeps but doesn't
abort when it encounters a terminal error like -EROFS. This causes
the thread to loop forever. Fix this by breaking out of the loop
if nilfs_segctor_construct() returns -EROFS.

Manoj K M fixed small grammar mistake in the description
for nilfs2 recovery code.

Ryusuke Konishi has made multiple fixes: (1) fix the list corruption
issue recently detected by syzbot, that can occur when out-of-range
values are intentionally passed to certain GC ioctl parameters;
(2) fix a flaw in the original B-tree implementation related to
truncation and resolves the reported out-of-bounds memory access
issue; (3) fix an issue reported by syzbot where a kernel BUG
could be triggered depending on timing after filesystem
corruption is detected; (4) fix an issue where a WARN_ON
check is triggered by sufile functions within the log writer after
the filesystem degrades to read-only mode.

Wang Jianjian introduced a check for sorted keys when reading
btree node blocks into the cache, preventing unexpected errors
during the block number assignment phase in log writing caused
by key order inconsistencies, as well as the kernel warnings
reported by syzbot.

The following changes since commit
dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
tags/nilfs2-v7.3-tag1

for you to fetch changes up to
24a098541a765ed017274f8094004404a83b0daf:

  nilfs2: standardize the inode number type to u64 (2026-08-10 16:06:23
-0700)

----------------------------------------------------------------
nilfs2 updates for v7.3

- nilfs2: standardize the inode number type to u64
- nilfs2: enhance btree node keys check
- nilfs2: suppress false positive WARN_ONs for sufile after an FS error
- nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch
- nilfs2: prevent out-of-bounds read in super root block parsing
- nilfs2: fix infinite loop in nilfs_clean_segments()
- nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate after
truncation
- Documentation: fix grammar in description of nilfs2 recovery code
- nilfs2: handle corrupted checkpoint count gracefully during deletion
- nilfs2: reject invalid block index in GC ioctl

----------------------------------------------------------------
David Lee (1):
      nilfs2: prevent out-of-bounds read in super root block parsing

Igor Putko (1):
      nilfs2: handle corrupted checkpoint count gracefully during
deletion

Joshua Crofts (1):
      nilfs2: fix infinite loop in nilfs_clean_segments()

Manoj K M (1):
      Documentation: fix grammar in description of nilfs2 recovery code

Ryusuke Konishi (5):
      nilfs2: reject invalid block index in GC ioctl
      nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate after
truncation
      nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state
mismatch
      nilfs2: suppress false positive WARN_ONs for sufile after an FS
error
      nilfs2: standardize the inode number type to u64

Wang Jianjian (1):
      nilfs2: enhance btree node keys check

 Documentation/filesystems/nilfs2.rst |  2 +-
 fs/nilfs2/bmap.c                     |  2 +-
 fs/nilfs2/bmap.h                     |  2 +-
 fs/nilfs2/btree.c                    | 58
+++++++++++++++++++++++++++++-------
 fs/nilfs2/cpfile.c                   | 20 ++++++++++---
 fs/nilfs2/dir.c                      | 11 ++++---
 fs/nilfs2/direct.c                   |  4 +--
 fs/nilfs2/ifile.c                    | 13 ++++----
 fs/nilfs2/ifile.h                    | 10 ++++---
 fs/nilfs2/inode.c                    | 24 +++++++--------
 fs/nilfs2/ioctl.c                    | 22 ++++++++++++--
 fs/nilfs2/namei.c                    |  6 ++--
 fs/nilfs2/nilfs.h                    | 15 +++++-----
 fs/nilfs2/page.c                     | 26 +++++++++++-----
 fs/nilfs2/recovery.c                 |  4 +--
 fs/nilfs2/segment.c                  | 42 +++++++++++++++-----------
 fs/nilfs2/sufile.h                   | 28 +++++++++++++++++
 fs/nilfs2/the_nilfs.c                |  6 ++++
 18 files changed, 206 insertions(+), 89 deletions(-)
