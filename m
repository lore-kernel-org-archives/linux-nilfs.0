From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 00/21 v5] drop vmtruncate
Date: Sat, 15 Dec 2012 11:43:25 +0100
Message-ID: <50CC544D.8050505@gmail.com>
References: <508295AF.60606@gmail.com> <5094E219.5020009@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=tteNH7JpcaphDtt1esojQhwt3Zu0+sSeG2ng3q19S2A=;
        b=PHrOZoK9adDyy1WZb/5uSX+s9nEvlRZ+o7oPCClcCLd5CM+6aDL/Qa4K1Xu0J9p+0n
         a9ST+uEjwAy3Z+w1pWgN1EyLmCgiqGiKG4xqsyfUmUd7/xiORRsjOXegP5ZCD1nCaAgf
         /4SbqQe9bu7lACChS1xzKUZWNNRkAgjdmVn5UOjLyvtvf2R5kTYCaugvz7OBAinczQLc
         RVZzlS/AZIStagytOY6HA0VvUlfdHz/mW7okvS0UPhnVqRJQ55ZsOE5FhVZXt1ZzU0/+
         kprWoLpvuJ9ohvgSHqBGgoEf15HexGJ0jQW+9RpDBCIrFnHuqDOj+Y2o7g8hg77hyneM
         w2Aw==
In-Reply-To: <5094E219.5020009@gmail.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Evgeniy Dushistov <dushistov@mail.ru>, reiserfs-devel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>, ocfs2-devel@oss.oracle.com, "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, jfs-discussion@lists.sourceforge.net, logfs@logfs.org, Petr Vandrovec <petr@vandrovec.name>, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-doc@vger.kernel.org

Hi all,

I send again the vmtruncate patch series. No change from the latest version, only rebased on the latest
Linus's tree. I hope we can merge it for 3.8.

Marco

Changes:
v5: rebased after 3.7 release
v4: fix an error for ocfs2, silently ignore truncate for procfs as suggested by Al
v3: reworked after Al and Christoph comments
v2: add documentation cleaning
v1: first draft

Marco Stornelli (21):
  ufs: drop vmtruncate
  sysv: drop vmtruncate
  reiserfs: drop vmtruncate
  procfs: drop vmtruncate
  omfs: drop vmtruncate
  ocfs2: drop vmtruncate
  adfs: drop vmtruncate
  affs: drop vmtruncate
  bfs: drop vmtruncate
  hfs: drop vmtruncate
  hpfs: drop vmtruncate
  jfs: drop vmtruncate
  hfsplus: drop vmtruncate
  logfs: drop vmtruncate
  minix: drop vmtruncate
  ncpfs: drop vmtruncate
  nilfs2: drop vmtruncate
  ntfs: drop vmtruncate
  vfs: drop vmtruncate
  mm: drop vmtruncate
  documentation: drop vmtruncate

 Documentation/filesystems/Locking |    6 ------
 Documentation/filesystems/porting |    2 +-
 Documentation/filesystems/vfs.txt |   11 -----------
 fs/adfs/inode.c                   |   15 ++++++++++-----
 fs/affs/file.c                    |   18 ++++++++++++------
 fs/affs/inode.c                   |    5 ++++-
 fs/bfs/file.c                     |   15 ++++++++++-----
 fs/hfs/inode.c                    |   26 ++++++++++++++++++--------
 fs/hfsplus/inode.c                |   27 ++++++++++++++++-----------
 fs/hpfs/file.c                    |   18 ++++++++++++------
 fs/hpfs/inode.c                   |    5 ++++-
 fs/jfs/file.c                     |    6 ++++--
 fs/jfs/inode.c                    |   20 ++++++++++++++------
 fs/libfs.c                        |    2 --
 fs/logfs/readwrite.c              |   10 ++++++++--
 fs/minix/file.c                   |    6 ++++--
 fs/minix/inode.c                  |   17 ++++++++++++-----
 fs/ncpfs/inode.c                  |    4 +---
 fs/nilfs2/file.c                  |    1 -
 fs/nilfs2/inode.c                 |   24 +++++++++++++++---------
 fs/nilfs2/nilfs.h                 |    1 +
 fs/nilfs2/recovery.c              |    3 ++-
 fs/ntfs/file.c                    |   16 +++++++++++++---
 fs/ntfs/inode.c                   |    8 ++++++--
 fs/ntfs/inode.h                   |    4 ++++
 fs/ocfs2/file.c                   |   18 ------------------
 fs/omfs/file.c                    |   22 +++++++++++++++-------
 fs/proc/base.c                    |    7 -------
 fs/proc/generic.c                 |    9 +--------
 fs/proc/proc_sysctl.c             |    7 -------
 fs/reiserfs/file.c                |    3 +--
 fs/reiserfs/inode.c               |   15 +++++++++++----
 fs/reiserfs/reiserfs.h            |    1 +
 fs/sysv/file.c                    |    5 +++--
 fs/sysv/itree.c                   |   17 ++++++++++++-----
 fs/ufs/inode.c                    |   15 ++++++++++-----
 include/linux/fs.h                |    1 -
 include/linux/mm.h                |    1 -
 mm/truncate.c                     |   23 -----------------------
 39 files changed, 225 insertions(+), 189 deletions(-)

-- 
1.7.3.4

