From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: remove chown from makefiles too?
Date: Thu, 30 Jul 2009 12:48:04 -0500
Message-ID: <4A71DCD4.5010502@redhat.com>
References: <4A71B53D.7070205@redhat.com>	<20090731.005317.12928769.ryusuke@osrg.net>	<4A71C990.3060804@redhat.com>
	<20090731.014518.56564034.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090731.014518.56564034.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:
> On Thu, 30 Jul 2009 11:25:52 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Ryusuke Konishi wrote:
>>> Hi,
>>> On Thu, 30 Jul 2009 09:59:09 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> ...
>>
>>>> I don't think there's any reason for the chown; can this just be removed?
>>> Well, I see.
>>>
>>> I will once remove the chown and normalize it unless the removal makes
>>> inconvenience to someone.
>>>
>>> Thank you for the comment.
>>>
>>> Ryusuke Konishi
>> thanks - on a similar topic, the Makefile in lib/ wants to run ldconfig,
>> I think it's a similar problem for non-root builds.
>>
>> For now I've just worked around these problems in the Fedora build.
> 
> Yes, It's been in my mind.
> 
> Here I attach the patch to remove these install-exec-hooks.
> 
> After some tests, I will push it to the git tree in two separate
> patches.
> 
> Thanks,
> Ryusuke Konishi

Looks good to me.

Reviewed-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

if you like.  :)

Thanks,
-Eric

> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index 131702b..1dbe74f 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -23,6 +23,3 @@ libnilfs_la_CFLAGS = -Wall
>  libnilfs_la_CPPFLAGS = -I$(top_srcdir)/include
>  libnilfs_la_LDFLAGS = -version-info $(VERSIONINFO)
>  libnilfs_la_LIBADD = libnilfsmisc.la
> -
> -install-exec-hook:
> -	$(LDCONFIG) $(DESTDIR)$(libdir)
> diff --git a/sbin/cleanerd/Makefile.am b/sbin/cleanerd/Makefile.am
> index edde74e..6fac7ff 100644
> --- a/sbin/cleanerd/Makefile.am
> +++ b/sbin/cleanerd/Makefile.am
> @@ -14,9 +14,3 @@ nilfs_cleanerd_CPPFLAGS = -I$(top_srcdir)/include \
>  nilfs_cleanerd_LDADD = $(top_builddir)/lib/libnilfs.la
>  
>  dist_sysconf_DATA = nilfs_cleanerd.conf
> -
> -install-exec-hook:
> -	list='$(sbin_PROGRAMS)'; \
> -	for p in $$list; do \
> -		chown root $(DESTDIR)$(sbindir)/$$p$(EXEEXT); \
> -	done
> diff --git a/sbin/mkfs/Makefile.am b/sbin/mkfs/Makefile.am
> index bae054a..3fd1288 100644
> --- a/sbin/mkfs/Makefile.am
> +++ b/sbin/mkfs/Makefile.am
> @@ -10,9 +10,3 @@ mkfs_nilfs2_SOURCES = mkfs.c bitops.c ../../lib/crc32.c mkfs.h
>  mkfs_nilfs2_CFLAGS = -Wall
>  mkfs_nilfs2_CPPFLAGS = -I$(top_srcdir)/include
>  mkfs_nilfs2_LDADD = -luuid
> -
> -install-exec-hook:
> -	list='$(sbin_PROGRAMS)'; \
> -	for p in $$list; do \
> -		chown root $(DESTDIR)$(sbindir)/$$p$(EXEEXT); \
> -	done
> diff --git a/sbin/mount/Makefile.am b/sbin/mount/Makefile.am
> index 9aea415..0f8d55f 100644
> --- a/sbin/mount/Makefile.am
> +++ b/sbin/mount/Makefile.am
> @@ -20,9 +20,3 @@ mount_nilfs2_LDADD = $(top_builddir)/lib/libnilfsmisc.la
>  
>  umount_nilfs2_SOURCES = umount.nilfs2.c $(COMMONSOURCES) $(COMMONHEADERS)
>  umount_nilfs2_LDADD = $(top_builddir)/lib/libnilfsmisc.la
> -
> -install-exec-hook:
> -	list='$(sbin_PROGRAMS)'; \
> -	for p in $$list; do \
> -		chown root $(DESTDIR)$(sbindir)/$$p$(EXEEXT); \
> -	done
