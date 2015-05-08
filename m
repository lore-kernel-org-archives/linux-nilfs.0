From: NeilBrown <neilb@suse.de>
Subject: [PATCH 0/3] make BTRFS, UDF, NILFS2 work with NFSv2.
Date: Fri, 08 May 2015 10:16:23 +1000
Message-ID: <20150508001142.31129.7604.stgit@notabene.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi filesystem folks,
 I just had a report that BTRFS doesn't work reliably with NFSv2.

 The problem is that NFSv2 doesn't encode filehandle size so it may
 report to the filesystem a longer handle that is being expected.

 Filesystems should not require a specific length, only at least that
 length.

 A code audit shows that NILFS2 and UDF suffer the same problem.

 Following patches should fix it... well, they compile and look good.

 Please consider for inclusion is respective trees.


 Admittedly NFSv2 is a bit "last century", but while it is easy to
 support, we may as well.

Thanks,
NeilBrown


---

NeilBrown (3):
      BTRFS: support NFSv2 export
      NILFS2: support NFSv2 export
      UDF: support NFSv2 export


 fs/btrfs/export.c |   10 +++++-----
 fs/nilfs2/namei.c |    6 +++---
 fs/udf/namei.c    |   16 ++++++++++++----
 3 files changed, 20 insertions(+), 12 deletions(-)

--
Signature

