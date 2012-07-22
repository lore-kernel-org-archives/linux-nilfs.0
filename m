From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] nilfs-utils: add skeleton of fsck.nilfs2
Date: Sun, 22 Jul 2012 19:13:01 +0400
Message-ID: <9DBF030C-DB82-4D29-884C-4C036FEC996D@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=X8AApMgrEEe7Bc629D7ByEhkN3OAM7NCHzZWrmdJysQ=;
	b=rsly6ufeUpUlTyQAhC0s3VRWZuWD1PVlAcvckFwr+cjSENp2825ke73cg5smjLqZq3rVPuomOOKXcCXeXZWArvhQv2A4vxMX5hm17uxlLtRCs1vtBWC3YkDTvam/TnPC;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This patch set adds skeleton of fsck.nilfs2 utility into nilfs-utils package. Currently, fsck.nilfs2 only try to check presence of primary and secondary superblocks. It checks magic signature in superblock.

With the best regards,
Vyacheslav Dubeyko.
--
 configure.ac     |    3 ++-
 sbin/Makefile.am |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

 sbin/fsck/Makefile.am        |   13 ++
 sbin/fsck/fsck_messages.c    |  254 ++++++++++++++++++++++++
 sbin/fsck/fsck_messages.def  |   62 ++++++
 sbin/fsck/fsck_messages.h    |  110 +++++++++++
 sbin/fsck/fsck_nilfs2.c      |  379 +++++++++++++++++++++++++++++++++++
 sbin/fsck/fsck_nilfs2.h      |   37 ++++
 sbin/fsck/fsck_raw_ops.c     |  413 +++++++++++++++++++++++++++++++++++++++
 sbin/fsck/fsck_raw_ops.h     |   46 +++++
 sbin/fsck/nilfs_superblock.c |  445 ++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_superblock.h |   48 +++++
 10 files changed, 1807 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
