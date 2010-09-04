From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2 0/2] nilfs2-utils: userland tools to tune nilfs
Date: Sat, 04 Sep 2010 14:05:43 +0900 (JST)
Message-ID: <20100904.140543.81009448.ryusuke@osrg.net>
References: <1283523043-7166-1-git-send-email-jir@unicus.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283523043-7166-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

On Fri,  3 Sep 2010 23:10:41 +0900, Jiro SEKIBA wrote:
> Hi, this is a second patch series to introduce new user land tool named
> "nilfs-tune" to nilfs2-utils.
> 
> nilfs-tune is a command that modify tunable nilfs parameters, like
> volume label.  I intented "nilfs-tune" as the step toward to unified
> "nilfs" command.  I'm hoping finaly it will be used as "nilfs tune".
> 
> First patch introduces a new library call nilfs_sb_write to write
> back super blocks.
> 
> Second patch is the actual patch to add new command.

I got the following error when I first tried nilfs-tune:

 $ nilfs-tune -l /dev/sdb1
 nilfs-tune 2.0.19
 /dev/sdb1: cannot open NILFS

It took some time to understand what happened.

The message looks confusing.  I think it should be as below to let
users know it's a sort of privilege error.

 "cannot open device: /dev/sdb1"

Anyway I applied the patches to the git repo.

Please test it and send me fixes.

Thanks!

Ryusuke Konishi
 
> differences from first patch are following:
> - fix styles
> - fix typos and description of manpages
> - fix a condition of assert at beginning of the nilfs_sb_write
> - add condition to check sb pointer in the nilfs_sb_write
> 
>  configure.ac                 |    7 +-
>  include/nilfs.h              |    7 +
>  lib/nilfs.c                  |   16 ++
>  lib/sb.c                     |  128 ++++++++---
>  man/Makefile.am              |    2 +-
>  man/chcp.8                   |    3 +-
>  man/lscp.1                   |    3 +-
>  man/mkcp.8                   |    3 +-
>  man/nilfs-tune.8             |   56 +++++
>  man/nilfs.8                  |    1 +
>  man/rmcp.8                   |    3 +-
>  sbin/Makefile.am             |    2 +-
>  sbin/nilfs-tune/Makefile.am  |    9 +
>  sbin/nilfs-tune/nilfs-tune.c |  500 ++++++++++++++++++++++++++++++++++++++++++
>  14 files changed, 696 insertions(+), 44 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
