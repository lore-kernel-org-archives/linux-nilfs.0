From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs2-utils: userland tools to tune nilfs
Date: Sat, 28 Aug 2010 12:52:55 +0900 (JST)
Message-ID: <20100828.125255.212698668.ryusuke@osrg.net>
References: <1282904230-29618-1-git-send-email-jir@unicus.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282904230-29618-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 27 Aug 2010 19:17:08 +0900, Jiro SEKIBA wrote:
> Hi, this is a patch series to introduce new user land tool named
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
> 
> 
>  configure.ac                 |    7 +-
>  include/nilfs.h              |    7 +
>  lib/nilfs.c                  |   16 ++
>  lib/sb.c                     |  125 ++++++++---
>  man/Makefile.am              |    2 +-
>  man/chcp.8                   |    3 +-
>  man/lscp.1                   |    3 +-
>  man/mkcp.8                   |    3 +-
>  man/nilfs-tune.8             |   54 +++++
>  man/nilfs.8                  |    1 +
>  man/rmcp.8                   |    3 +-
>  sbin/Makefile.am             |    2 +-
>  sbin/nilfs-tune/Makefile.am  |    9 +
>  sbin/nilfs-tune/nilfs-tune.c |  500 ++++++++++++++++++++++++++++++++++++++++++
>  14 files changed, 691 insertions(+), 44 deletions(-)

Thanks for posting the tune tool!

Organization of their functions looks fine to me.

But they will bring several checkpatch errors to the utils:

ERROR: trailing whitespace
#214: FILE: lib/sb.c:170:
+^I$

ERROR: spaces required around that '=' (ctx:VxV)
#232: FILE: lib/sb.c:188:
+       for (i=0;i<2;i++) {
              ^

ERROR: space required after that ';' (ctx:VxV)
#232: FILE: lib/sb.c:188:
+       for (i=0;i<2;i++) {
                ^

ERROR: spaces required around that '<' (ctx:VxV)
#232: FILE: lib/sb.c:188:
+       for (i=0;i<2;i++) {
                  ^

ERROR: space required after that ';' (ctx:VxV)
#232: FILE: lib/sb.c:188:
+       for (i=0;i<2;i++) {
                    ^

ERROR: code indent should use tabs where possible
#233: FILE: lib/sb.c:189:
+^I        if (!sbps[i])$

<snip>

ERROR: space required before the open parenthesis '('
#408: FILE: sbin/nilfs-tune/nilfs-tune.c:185:
+} while(0)

ERROR: space required before the open parenthesis '('
#500: FILE: sbin/nilfs-tune/nilfs-tune.c:277:
+     switch(creator) {

ERROR: space required before the open parenthesis '('
#571: FILE: sbin/nilfs-tune/nilfs-tune.c:348:
+     	    if(interval)

<snip>

To keep the code clean, I think these errors should be gone though
this is not a kernel code.

Could you try to clean them up ?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
