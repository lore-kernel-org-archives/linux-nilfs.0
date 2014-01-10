From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 0/4] nilfs-utils: introduce xattrs support by
 utilities
Date: Fri, 10 Jan 2014 16:10:53 +0400
Message-ID: <1389355853.3938.141.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uWfqNZZYgEytXS1pSkCtSO8dydOL8Tx7wfYaUjmn0KE=;
	b=NtlexHq48Y3BDXq2s2NuQSbJmvg/h/4rOPDXx+DXSzIF3wbq/pyYjncqNPFfa92yvzwJbdx1Z8xQOji1OGsLintk8gLNxVropJW/6EPgpD5Y5LlLX5rjJzAVQbEDGAXK;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,

This patchset implements modification of mkfs.nilfs2 and nilfs-tune
utilities with the purpose to support xafile creation (on mkfs phase) or
request of xafile initialization by file system driver for existed
NILFS2 volume (on nilfs-tune phase).

The patchset is suggested for review, testing and discussion only but
*NOT* for inclusion in nilfs-utils repository.

With the best regards,
Vyacheslav Dubeyko.
---

 include/nilfs2_fs.h          |   16 +++++++++---
 lib/feature.c                |    7 ++++++
 man/mkfs.nilfs2.8            |    9 +++++++
 man/nilfs-tune.8             |    9 +++++++
 sbin/mkfs/mkfs.c             |   55 ++++++++++++++++++++++++++++++++++++++----
 sbin/nilfs-tune/nilfs-tune.c |   20 +++++++++++++--
 6 files changed, 106 insertions(+), 10 deletions(-)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
