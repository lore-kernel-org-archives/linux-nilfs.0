From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 0/2] nilfs2-utils: userland tools to tune nilfs
Date: Fri,  3 Sep 2010 23:10:41 +0900
Message-ID: <1283523043-7166-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi, this is a second patch series to introduce new user land tool named
"nilfs-tune" to nilfs2-utils.

nilfs-tune is a command that modify tunable nilfs parameters, like
volume label.  I intented "nilfs-tune" as the step toward to unified
"nilfs" command.  I'm hoping finaly it will be used as "nilfs tune".

First patch introduces a new library call nilfs_sb_write to write
back super blocks.

Second patch is the actual patch to add new command.

differences from first patch are following:
- fix styles
- fix typos and description of manpages
- fix a condition of assert at beginning of the nilfs_sb_write
- add condition to check sb pointer in the nilfs_sb_write

 configure.ac                 |    7 +-
 include/nilfs.h              |    7 +
 lib/nilfs.c                  |   16 ++
 lib/sb.c                     |  128 ++++++++---
 man/Makefile.am              |    2 +-
 man/chcp.8                   |    3 +-
 man/lscp.1                   |    3 +-
 man/mkcp.8                   |    3 +-
 man/nilfs-tune.8             |   56 +++++
 man/nilfs.8                  |    1 +
 man/rmcp.8                   |    3 +-
 sbin/Makefile.am             |    2 +-
 sbin/nilfs-tune/Makefile.am  |    9 +
 sbin/nilfs-tune/nilfs-tune.c |  500 ++++++++++++++++++++++++++++++++++++++++++
 14 files changed, 696 insertions(+), 44 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
