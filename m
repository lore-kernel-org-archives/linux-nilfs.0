Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529C41BA98
	for <linux-nilfs@vger.kernel.org>; Fri, 16 Oct 2026 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792189657; cv=none; b=ruBEW+BmdMXf4GKyquXT19RqJwkkSPasv9iofGfZK5RoeMjeGB8R181HD2ms26ohJGDBvEVxBvpL17bMQz6ZxCuWI/FAnyMo3LG2w7Vyrp+Tz1Ji3sLm/hOkMJk42mfCNMG7BIdjZserH2D++Sn5S3pdi7mUEUY51I7y96kRBxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792189657; c=relaxed/simple;
	bh=Y4My8wDTy2jCY4xKi9+ACa1d/Vf7+Epb9j4faC47+Xw=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=oVdRYKaj291hTlUMEOyitXJzQfIKy77hVuDZ5HQKExiFpAFRRQuWp6rqMB6iNVQW7yOzrGAdYUO3m84jRbWrh1TKua5KSRhMDVOmO/NxINi2BA7pTCqJ+waJ135kq1FH7YYA2Ya1pdGHj8eSgEXTy3cZuTSZQt6ZxjExCVrZUbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=YCGYiitp; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="YCGYiitp"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-679a420b96eso495659d50.0
        for <linux-nilfs@vger.kernel.org>; Fri, 16 Oct 2026 15:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1792189653; x=1792794453; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uNoSMMSeqaMd1VXRbutnqV4pyptkpKpvrMV1nT0fWuw=;
        b=YCGYiitpGWx4fpbmHlYJn/peFscRhg5jRCsHDDIOayuYKiFL8n7LQ8tj+HzBEW/dQN
         kUVBrkW7iXK5XRXgnU+nWJXIQ22loyJzpH2v0QYxHNNLeV3pg7TSiJ4V8PzLBfrw75Sg
         d/1JEcFqc3HmcHR0p9CwH9hcbbF3qXfTjUbsppAVOjayAab8IsukJlyWJvtxaLEyk9mO
         +7QOR14YKs072DM267kWm9kTmMO9qBk3nLj1CgDGEe2SKIh494h8r4FL3j3n3HHLUpU6
         YTX1j+UwXoy2YPJxlgdTvsxmjjZrFzsiv4a0RLq20LLh5BU9GiNTMX4i5vr1Q2B6JnlW
         jAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792189653; x=1792794453;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNoSMMSeqaMd1VXRbutnqV4pyptkpKpvrMV1nT0fWuw=;
        b=ClPbnXWcP+sA4eC4yWN4/QAvVcLKS5OuvykiQdyxuiRyXVp9JVU94VoRBdcNhzxjnY
         /YS/e6WrnwIp+oaxRSzW0sbCoWK2AvUd/7+tYTPDsWuXKmWZshsmBm1ErnFvRpvTrcSk
         2i/9ojnYfRu+TDpvumg4W2uy2ks5R/28PI8eptF73yyK1zWCDS6kO1tjaB/upZgqebN3
         rsGFgW2MbSUwl1Z09wzGcF/8QcwYSMDnN9pKqu3svUwEv0MPhCX5NBn7ko9rK1NaQR6i
         mbJI9Z8tiv4BzCwIf8EGwZHh066AbIzzaE5ISqSVHyK5uh/0C+6YjHDPtWNhh7ZR69AI
         ho7Q==
X-Gm-Message-State: AFq9FYIa+p8zcyD1Xx/7ceGxtNO7TlyMDTQ6l3eWq5y4R8iqD5ZIm1/O
	5OLUqpNkj3LMY9aMco6T9OIYk971+0ZLEszE6MANkas2BZzf+IpNX7vDTpervj9mBG8=
X-Gm-Gg: AYBFou3ytzzOs2LyfxWH6zeO099VLaaUOwoN4DYiNvSNAyGhsAFj0Qg/YhsMDmi4VEu
	o/Vfo2RHXzdhKwzE4lHMbS3mbuvHSWbJOV769rjPnKbaoVtRXkJOPETweOeqBVYyYxV73aHDHnf
	02hy6PMZGvnnKLLKIbXCE+ofUvqEKVE/2H4Up0lWs14CAsJ2lybAVWks03A8KrjvaeFF2diR44S
	fnoJIf2hkASGPr0d7qjzmaoVyUyAQp2+XzKWQGFgJ9SLQS6NedXA40WYnHv9jNCl/WZ4cZlAvNR
	BA85WhnW5/eL5R+QIREjpfN8N30fvh3YVQoBIVoxAQSZ2BC2sJzgj+QHDfHU8UnyNnZZngE7Ktr
	xxN8p9KD/DqWarF5TrilyqccnRDrhRfrFFQBO+afQu0rOAPvLCXZIiMJ73YrCI9lbKMggy9HFw0
	fywr/ji3DF6S3Ma4/idVRF/SC4/uuUNpXExpaErasgG3DpmyMpKIL1L5XhfSWo2WqtD3QThEK7O
	WVvb7mZH9Hymy6bRKlGZ4V7WDxgnqoZvAMIxtW/DqLRJWuBQxcf0gOwCke9i1Uk7rE8KVhGXz1r
	BWrDqc83YnS1+UpNFGFVDK/6ZGU8i5xcN6DoG0H/N8I7Y0Bc4aJ4371bhNHzrfP1TYbXi7M8
X-Received: by 2002:a53:ac86:0:b0:679:b274:8998 with SMTP id 956f58d0204a3-679b2749018mr1400777d50.47.1792189652972;
        Fri, 16 Oct 2026 15:27:32 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:a87:49c7:b10d:ebbd? ([2600:1700:6476:1430:a87:49c7:b10d:ebbd])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-679b1c94c25sm1622165d50.3.2026.10.16.15.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 15:27:31 -0700 (PDT)
Message-ID: <76ad2d292f0446eeaa22850bbf4a63335b5eff19.camel@dubeyko.com>
Subject: [GIT PULL] nilfs2 changes for 7.4-rc1
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: torvalds@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com,
 vdubeyko@coreweave.com, 	qwe.aldo@gmail.com, hemanth.selam@gmail.com,
 southampton.jake.labelle@gmail.com, 	r772577952@gmail.com,
 joshua.crofts1@gmail.com
Date: Fri, 16 Oct 2026 15:27:29 -0700
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

Aldo Ariel Panzardo has fixed the issues in nilfs_sufile_get_suinfo(),
nilfs_scan_dsync_log(), and nilfs_find_or_create_root():
- If the requested segment number is greater than the total
  number of segments, the function may process segment numbers
  outside the filesystem.
- nilfs_scan_dsync_log() trusts the block counts in each on-disk file
  information entry. If fi_ndatablk is greater than fi_nblocks,
  the data block loop can consume excessive summary entries and
  the later subtraction used to derive the number of node blocks
  underflows.
- nilfs_find_or_create_root() links a new checkpoint root into the
  checkpoint tree and drops ns_cptree_lock before creating the root's
  sysfs group. If nilfs_sysfs_create_snapshot_group() then fails, the
  root is freed while it is still reachable from ns_cptree, so a
  concurrent nilfs_lookup_root() can dereference freed memory.

Hemanth Selam has fixed typos in comments, reported by
scripts/checkpatch.pl using the misspelling list in
scripts/spelling.txt.

Jake Labelle has fixed issues in nilfs_recover_dsync_blocks() and
nilfs_readdir():
- During roll-forward recovery, nilfs_recover_dsync_blocks() obtains
  the inode designated by fi_ino of a dsync log without checking its
  type. Regular files, directories, and symlinks are the only inode
  types with data blocks to recover; reject anything else before
  touching its block mapping.
- nilfs_readdir() uses ctx->pos, which userspace can set to
  an arbitrary value via llseek, as an offset into the directory
  folio and parses whatever bytes sit there as a directory entry.
  Snap unaligned positions onto a valid entry boundary by walking
  the rec_len chain from the chunk start before parsing.

Jiaming Zhang has fixed the issue in logic of clearing the dirty
folios. When garbage collection fails, nilfs2 rolls the DAT metadata
file's page cache back to a shadow copy taken before GC started.
nilfs_clear_dirty_pages() drops the dirty state of the folios
in the DAT cache, then nilfs_copy_back_pages() overwrites them with
the saved contents and warns if one is still dirty. Add a force flag
to nilfs_clear_dirty_pages() and nilfs_clear_folio_dirty() that
skips the busy buffer check, and set it in the two calls from
nilfs_mdt_restore_from_shadow_map().

Joshua Crofts has removed dead code and commented code sections in
nilfs_new_inode(), nilfs_read_inode_common(), and nilfs_setup_super().

Ryusuke Konishi has fixed multiple issues:
- While the recent out-of-bounds memory access issue in
  nilfs_direct_propagate() has already been fixed, adds extra checks
  to catch and gracefully handle similar potential bugs.
- Fix syzbot reported deadlock between nilfs_evict_inode() and
  find_inode() by removing the synchronous log writer trigger from
  nilfs_evict_inode().
- Fix an omitted clear of the dirty flag on backing device buffers,
  which could cause an abnormal buffer state and potential block
  overwriting data corruption.
- Improve stability by preventing errors caused by user interrupts
  while waiting for log writes, which are triggered by synchronous
  write flags following operations such as rename().
- Refactor the metadata file writeback callback function,
  restructuring an inefficient legacy function organization rooted in
  the era of aops->writepage() to align with aops->writepages().
- Fix a link count underflow during rmdir on a directory with a
  corrupted link count (an issue recently reported by syzbot).

Viacheslav Dubeyko implemented the elimination of blockdev_direct_IO()
from nilfs2 entirely. It adds iomap.h with declaration of iomaps
operations and iomap.c with implementation of nilfs_iomap_begin().
The nilfs_direct_IO() and the .direct_IO callback on nilfs_aops are
removed. The nilfs_file_read_iter() dispatches O_DIRECT reads to
iomap_dio_rw() using nilfs_iomap_ops. Everything else still goes
through generic_file_read_iter().

The following changes since commit
cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
tags/nilfs2-v7.4-tag1

for you to fetch changes up to
de7f49c12566cc5c7437a2f26c6c754b9d4d5648:

  nilfs2: validate directory position after llseek in readdir (2026-10-
08 09:39:43 -0700)

----------------------------------------------------------------
nilfs2 updates for v7.4

- nilfs2: validate directory position after llseek in readdir
- nilfs2: reject non-regular inodes in dsync recovery
- nilfs2: fix link count underflow when removing corrupted directory
- nilfs2: simplify nilfs_mdt_writeback()
- nilfs2: ignore non-fatal signals during synchronous log write wait
- nilfs2: clear dirty flag on bdev buffers on log write failure
- nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
- nilfs2: fix checkpoint root lifetime on sysfs errors
- nilfs2: switch O_DIRECT to iomap based operations
- nilfs2: add iomap operations for direct I/O
- nilfs2: validate file block counts during recovery
- nilfs2: force clear dirty state when restoring from the shadow map
- nilfs2: validate segment number in nilfs_sufile_get_suinfo()
- nilfs2: fix typos in comments
- nilfs2: remove '#if 0' code blocks
- nilfs2: strengthen consistency checks in nilfs_direct_propagate()

----------------------------------------------------------------
Aldo Ariel Panzardo (3):
      nilfs2: validate segment number in nilfs_sufile_get_suinfo()
      nilfs2: validate file block counts during recovery
      nilfs2: fix checkpoint root lifetime on sysfs errors

Hemanth Selam (1):
      nilfs2: fix typos in comments

Jake Labelle (2):
      nilfs2: reject non-regular inodes in dsync recovery
      nilfs2: validate directory position after llseek in readdir

Jiaming Zhang (1):
      nilfs2: force clear dirty state when restoring from the shadow
map

Joshua Crofts (1):
      nilfs2: remove '#if 0' code blocks

Ryusuke Konishi (6):
      nilfs2: strengthen consistency checks in nilfs_direct_propagate()
      nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
      nilfs2: clear dirty flag on bdev buffers on log write failure
      nilfs2: ignore non-fatal signals during synchronous log write
wait
      nilfs2: simplify nilfs_mdt_writeback()
      nilfs2: fix link count underflow when removing corrupted
directory

Viacheslav Dubeyko (2):
      nilfs2: add iomap operations for direct I/O
      nilfs2: switch O_DIRECT to iomap based operations

 fs/nilfs2/Kconfig     |  2 +-
 fs/nilfs2/Makefile    |  2 +-
 fs/nilfs2/dir.c       | 34 ++++++++++++++++++++++++
 fs/nilfs2/direct.c    |  6 +++++
 fs/nilfs2/file.c      | 42 +++++++++++++++++++++++++++---
 fs/nilfs2/inode.c     | 28 +-------------------
 fs/nilfs2/ioctl.c     |  2 +-
 fs/nilfs2/iomap.c     | 72
+++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/iomap.h     | 13 ++++++++++
 fs/nilfs2/mdt.c       | 44 ++++++++++---------------------
 fs/nilfs2/namei.c     |  8 +++++-
 fs/nilfs2/page.c      | 50 ++++++++++++++++++++---------------
 fs/nilfs2/page.h      |  4 +--
 fs/nilfs2/recovery.c  | 24 ++++++++++++++++-
 fs/nilfs2/segment.c   | 12 +++++----
 fs/nilfs2/sufile.c    | 12 ++++++---
 fs/nilfs2/super.c     | 10 +++----
 fs/nilfs2/sysfs.c     |  5 +++-
 fs/nilfs2/the_nilfs.c | 34 ++++++++++++++----------
 19 files changed, 285 insertions(+), 119 deletions(-)
 create mode 100644 fs/nilfs2/iomap.c
 create mode 100644 fs/nilfs2/iomap.h
