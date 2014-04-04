From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/9] nilfs2: introduce functionality of creation of sysfs
 groups and attributes
Date: Fri, 04 Apr 2014 19:11:46 +0400
Message-ID: <1396624306.2215.33.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=lgZ1N40BYuBAVAHCp3YJeNP6LhyJ3+l2J7L3zRXvdU0=;
	b=cRiExttOjihxvirl/SmD6p1w9JH8MipneOzoee4fUUSvI28Ly2+C6XC+/I/nI4Q4Mnb/VNk7QdBukSAXBu27xA8Kc6+tDpEK8Ol6+Elq+xDheNTfTIdF68Dm+YY556zo;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org

Hi,

This patchset implements creation of sysfs groups and attributes with
the purpose to show NILFS2 volume details and internal state of
the driver.

Implemented functionality creates such groups:
(1) /sys/fs/nilfs - root group
(2) /sys/fs/nilfs/features - group contains attributes that describe NILFS
file system driver features
(3) /sys/fs/nilfs/<device> - group contains attributes that describe file
system partition's details
(4) /sys/fs/nilfs/<device>/superblock - group contains attributes that describe
superblock's details
(5) /sys/fs/nilfs/<device>/segctor - group contains attributes that describe
segctor thread activity details
(6) /sys/fs/nilfs/<device>/segments - group contains attributes that describe
details about volume's segments
(7) /sys/fs/nilfs/<device>/checkpoints - group contains attributes that describe
details about volume's checkpoints
(8) /sys/fs/nilfs/<device>/mounted_snapshots - group contains group for every
mounted snapshot
(9) /sys/fs/nilfs/<device>/mounted_snapshots/<snapshot> - group contains
details about mounted snapshot

With the best regards,
Vyacheslav Dubeyko.
---
 fs/nilfs2/Makefile    |    2 +-
 fs/nilfs2/nilfs.h     |    8 +
 fs/nilfs2/super.c     |    9 +-
 fs/nilfs2/sysfs.c     | 1134 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sysfs.h     |  174 ++++++++
 fs/nilfs2/the_nilfs.c |   16 +-
 fs/nilfs2/the_nilfs.h |   20 +-
 7 files changed, 1359 insertions(+), 4 deletions(-)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
