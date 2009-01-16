From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Fri, 16 Jan 2009 19:02:00 +0900 (JST)
Message-ID: <20090116.190200.71915952.ryusuke@osrg.net>
References: <3313c4ab0901151010u67983034vd1b8b75e0672d400@mail.gmail.com>
	<20090116.165503.64733535.ryusuke@osrg.net>
	<3313c4ab0901160138u39baa485u56c5f285fb553449@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0901160138u39baa485u56c5f285fb553449-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Fri, 16 Jan 2009 10:38:16 +0100, Milos Jana wrote:
> user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb
> [sudo] password for user:
> Super-block:
>   revision = 2.0, checksum = OK
<snip>
> Searching the latest checkpoint.
> Selected segment: blocknr = 4261888
>   segnum = 2081, seq = 11745, cno=6660
>   creation time = 2008-12-28 09:48:34
> Do you wish to overwrite super block (y/N)? Y

Oops, use 'y' instead of 'Y'.

Sorry for the unfriendly interface.
I'll fix it in a next time.

Ryusuke

> Recovery will complete on mount.
> user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo mount /media/pendrive/
> mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> argument
> 
> dmesg returns the same errors:
> [ 553.003240] NILFS warning: Segment magic number invalid
> [ 553.003248] NILFS: error searching super root.
> 
> On Fri, Jan 16, 2009 at 8:55 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> 
> > On Thu, 15 Jan 2009 19:10:19 +0100, "Milos Jana" wrote:
> > > Nilfs-utils compiled properly with patch after following instructions
> > from
> > > your previous post. Here is what came out:
> > >
> > > user@laptop:~$ sudo fsck0.nilfs2 /dev/sdb
> > > Super-block:
> > >   revision = 2.0, checksum = OK
> > >   blocksize = 4096
> > >   write time = 2008-12-28 09:48:42
> > >   indicated partial segment: blocknr = 4263936
> > >   segnum = 2082, seq = 11746, cno=6661
> > >
> > > Clean FS.
> > >
> > > user@laptop:~$ sudo mount /media/pendrive/
> > > mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> > > argument
> >
> > Hmm, that's weird.
> >
> > The partition was cleanly unmounted, but the final segment seems not
> > to be written to the disk.
> >
> > Maybe, we need 'force' option to treat such situation.
> >
> > In the meatime, could you try the following (additional) patch?
> >
> > Regards,
> > Ryusuke
> > --
> >
> > diff --git a/sbin/mkfs/fsck0.nilfs2.c b/sbin/mkfs/fsck0.nilfs2.c
> > index d3d335f..0d51e54 100644
> > --- a/sbin/mkfs/fsck0.nilfs2.c
> > +++ b/sbin/mkfs/fsck0.nilfs2.c
> > @@ -905,10 +905,12 @@ static void nilfs_fsck(const char *device)
> >        print_pseg_message(&pseg_ref, "    indicated partial segment");
> >        fputc('\n', stderr);
> >
> > +#if 0
> >        if (le16_to_cpu(sb.s_state) & NILFS_VALID_FS) {
> >                fprintf(stderr, "Clean FS.\n");
> >                goto out_clean;
> >        }
> > +#endif
> >
> >        if (nilfs_do_recovery(devfd, &pseg_ref) == 0)
> >                goto out;
> >
