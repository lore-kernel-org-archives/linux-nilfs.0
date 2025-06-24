Received: from logand.com (logand.com [37.48.87.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F324C9F;
	Tue, 24 Jun 2025 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.48.87.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797200; cv=none; b=kWVZWEMDrXM25ntGwTlQ47hPiHvPZNVSkabk/yhCcON+krdKkW5a5+usIXtKcDn35T00FdpMGvDMzt91AjymlRqPRfLoL9U9tUyrBiNIbNEq6cjcuDgV7fPbE/LEC5i/8Oo4TaXjh97wh/lUsmGScmGOrbgSHC3WO9f/s94oU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797200; c=relaxed/simple;
	bh=awUJ59KCPPuvPJZePiwtYh8/HLcDmmaXXLX8J+3uhuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=guR5o57YfNTtiAIU3aEs3diYPV5P8L7e1vVsEl8CQ6hiAnOQjWt986tb/j8iRLyESZlf44xHUGftlMIhBjc1riKrxSvErx4zXP8cwhgKJDpYYZrQY4T75S85iHzf1IrBVnypv0rXg81xcwaJxkuhS0OOuWVZOHGwYbNe3Q5GdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=logand.com; spf=pass smtp.mailfrom=logand.com; arc=none smtp.client-ip=37.48.87.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=logand.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logand.com
Received: by logand.com (Postfix, from userid 1001)
	id CE7491A0C05; Tue, 24 Jun 2025 22:27:20 +0200 (CEST)
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Tomas Hlavaty <tom@logand.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken
 bmap (inode number=4023271)
Date: Tue, 24 Jun 2025 22:27:18 +0200
Message-ID: <87tt44lwbd.fsf@logand.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Ryusuke,

I get the following error:

   NILFS error (device dm-0): nilfs_bmap_lookup_contig:
   broken bmap (inode number=4023271)

and the filesystem gets mounted read-only.

I can remount the filesystem read-write again manually, but after an
operation which touches the broken part of the filesystem, it gets
remounted read-only again.

I have identified the file of the inode:
sudo find / -inum 4023271
as
/root/.cache/mesa_shader_cache_db/index
but remounting rw and trying to
rm -r /root/.cache
puts the filesystem to ro mode again.
(not sure why there is .cache dir and mesa_shader_cache_db dir in the
/root dir, I never use root account for GUI)

I am in the process of upgrading the system from nixos24.11 to
nixos25.05 but this issue is preventing me from doing so.  Is there a
way to fix the filesystem so that it stays read-write?  Or do I have to
discard the whole filesystem?

Also I have noticed since long time ago, that reboot or shutdown says
something about nilfs discarding stuff, which seems strange and those
messages were not there a year or more ago.  Not sure if this is
related, but it should not be discarding anything I guess.  I see these
messages on many machines so it is not related to a particular hardware.

Log and stacktrace are bellow.
Please let me know if I can provide more info about the problem.

Any help would be appreciated.

Thank you,

Tomas

$ uname -a
Linux buta 6.6.87 #1-NixOS SMP PREEMPT_DYNAMIC Thu Apr 10 12:37:44 UTC 2025 x86_64 GNU/Linux

$ sudo dmesg | grep nilfs
[    1.087780] stage-1-init: [Tue Jun 24 19:32:16 UTC 2025] loading module nilfs2...
[   35.318251] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=4023271)
[   35.319235] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=4023271)
[...]
[   35.347872] NILFS error (device dm-0): nilfs_bmap_lookup_contig:
broken bmap (inode number=4023271)
[ 1733.401421]  nilfs_segctor_do_construct+0xdd/0x2630 [nilfs2]
[ 1733.401747]  ? nilfs_mdt_fetch_dirty+0x19/0x50 [nilfs2]
[ 1733.401899]  ? nilfs_test_metadata_dirty.isra.0+0x50/0xb0 [nilfs2]
[ 1733.402059]  nilfs_segctor_construct+0x170/0x2b0 [nilfs2]
[ 1733.402220]  nilfs_segctor_thread+0x155/0x3f0 [nilfs2]
[ 1733.402385]  ? __pfx_nilfs_segctor_thread+0x10/0x10 [nilfs2]
[ 1738.068626] NILFS error (device dm-0): nilfs_bmap_last_key: broken
bmap (inode number=4023271)
