From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/1] nilfs2: fix data loss with mmap()
Date: Thu, 18 Sep 2014 23:56:24 +0900
Message-ID: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=7JnqFWO9AcU7EnZ2Srivs32absYuc7pwA85M589v3jA=;
        b=Y53j2bhcl65VJHljdMxxTyDk90QNqxyg3LLtMrQUQcZIdE9RZcVKHmWTUuu2Hm8/Bi
         +WlJF3GplJ0ipMOj6F4L451MQ5RoGbqUsgkEghZ89S03c3cuue8y6TdWylrKdioT6lU1
         Qh3FnfPtY64YMxslKFuEqcGUTmhuslp0m19iUFIeFI0nT4azcGHJqv02Dc5GKzcX6nHy
         EqDuah8j1JdPUdoyTvQ+244bfbVyEhp+R3iaPYooPMy0XylUsLg4D8dmCI6ynNOAgFSi
         HwMQaNnFsgKu2LAn5K25T1Kg06yVOPGFWR8oj1v/eqrsgNrStEtZ2QnxBX++/bsUdmcP
         kSzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Andreas Rohner <andreas.rohner@gmx.net>

Andrew,

Please apply the following bugfix and send it to upstream.

It fixes a regression of nilfs2's mmap which was brought by the commit
136e8770cd5d1fe3 "nilfs2: fix issue of nilfs_set_page_dirty() for page
at EOF boundary".  Andreas Rohner recently found that the commit was
not perfect and causing reproducible silent data loss issue.

Thanks in advance,

Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

 fs/nilfs2/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
