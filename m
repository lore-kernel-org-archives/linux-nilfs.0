From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't start nilfs_cleanerd on root fs.
Date: Fri, 10 Jul 2009 00:09:21 +0900 (JST)
Message-ID: <20090710.000921.115219555.ryusuke@osrg.net>
References: <21e999b60907040743l3940f2a2y1a7b0e56dfe73d73@mail.gmail.com>
	<20090705.135657.105810904.ryusuke@osrg.net>
	<21e999b60907090606o2eba4972t80ef969594f300ff@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <21e999b60907090606o2eba4972t80ef969594f300ff-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: quinq.ml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Thu, 9 Jul 2009 15:06:28 +0200, Quentin RAMEAU wrote:
> Hi,
> 
> I am sorry for that delayed response. I applied this patch, nilfs is still
> working, but it didin't solve my problem.
> There is some news though, I found out that nilfs_cleanerd works when I use
> an initrd, mounting my root fs in it, and doing a switch_root then.
> (I can restart it etc, works fine)
>
> Here is my /proc/mounts without initrd:
> $ cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / nilfs2 rw,relatime 0 0
> proc /proc proc rw,relatime 0 0
> sysfs /sys sysfs rw,relatime 0 0
> none /dev ramfs rw,relatime 0 0
> devpts /dev/pts devpts rw,relatime,mode=600 0 0
> /dev/hda2 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
> /dev/hda4 /DATA nilfs2 rw,relatime 0 0
> fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0

Thank you for trying the patch.

In the first example, the root device (/dev/root) is a symbolic link
to the actual device (i.e. hda3). So the first hurdle seems to be
handled with the patch.  Unfortunately, another problem seems to be
there.

But it's OK, I think I can pursue the problem with the help of your
/proc/mounts information.

Thanks,
Ryusuke Konishi
 
> and with initrd:
> $ cat /proc/mounts
> rootfs / rootfs rw 0 0
> tmpfs /dev tmpfs rw,relatime 0 0
> devpts /dev/pts devpts rw,relatime,mode=600 0 0
> /dev/hda3 / nilfs2 rw,relatime 0 0
> proc /proc proc rw,relatime 0 0
> sysfs /sys sysfs rw,relatime 0 0
> none /dev ramfs rw,relatime 0 0
> devpts /dev/pts devpts rw,relatime,mode=600 0 0
> /dev/hda2 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
> /dev/hda4 /DATA nilfs2 rw,relatime 0 0
> fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
> 
> 2009/7/5 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> 
> > Hi!
> > On Sat, 4 Jul 2009 16:43:31 +0200, Quentin RAMEAU wrote:
> > > Hello,
> > >
> > > I formated my root fs with nilfs a few days ago, but I can't start
> > cleanerd
> > > for that fs.
> > > I have another nilfs on that system that seems to work correctly.
> > >
> > > Maybe I am doing something wrong, at least, there something that could be
> > > done, here is some info about it:
> > >
> > > $ uname -r
> > > 2.6.30-zen1
> > >
> > > $ mount -t nilfs2
> > > /dev/hda3 on / type nilfs2 (rw,gcpid=1510)
> > > /dev/hda4 on /DATA type nilfs2 (rw,gcpid=1675)
> > >
> > > $ ps -ef | grep nilfs
> > > root      1675     1  0 12:56 ?        00:00:02 /sbin/nilfs_cleanerd -n
> > > /dev/hda4 /DATA
> > >
> > > $ nilfs_cleanerd /dev/hda3 && tail /var/log/everything/current | grep
> > nilfs
> > > Jul 04 15:46:29 [nilfs_cleanerd] start
> > > Jul 04 15:46:29 [nilfs_cleanerd] cannot open nilfs on /dev/hda3: Invalid
> > > argument
> > > Jul 04 15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3:
> > > Invalid argument
> > > Jul 04 15:46:29 [nilfs_cleanerd] shutdown
> >
> > I think this comes from a matching error in /proc/mounts. I found a
> > symlink entry is used for the device of root filesystem in some
> > environments.  The current nilfs library does not support such case.
> >
> > What's going on your /proc/mounts?
> >
> > Anyway, I wrote a patch to handle the above case.
> >
> > If this is the case, could you try the following patch?
> >
> > Thanks in advance,
> > Ryusuke Konishi
> >
> > --
> > diff --git a/lib/nilfs.c b/lib/nilfs.c
> > index 75179e3..df8792b 100644
> > --- a/lib/nilfs.c
> > +++ b/lib/nilfs.c
> > @@ -148,6 +148,7 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> > char *dev, const char *dir,
> >        int ret, n;
> >        char canonical[PATH_MAX + 2];
> >        char *cdev = NULL, *cdir = NULL;
> > +       char *mdev, *mdir;
> >
> >        ret = -1;
> >        if (dev && myrealpath(dev, canonical, sizeof(canonical))) {
> > @@ -172,20 +173,36 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> > char *dev, const char *dir,
> >                n = tokenize(line, mntent, NMNTFLDS);
> >                assert(n == NMNTFLDS);
> >
> > -               if ((dev == NULL || strcmp(mntent[MNTFLD_FS], dev) == 0) &&
> > -                   (dir == NULL || strcmp(mntent[MNTFLD_DIR], dir) == 0)
> > &&
> > -                   strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) == 0 &&
> > -                   has_mntopt(mntent[MNTFLD_OPTS], opt)) {
> > +               if (strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) != 0)
> > +                       continue;
> > +
> > +               if (dir != NULL) {
> > +                       mdir = mntent[MNTFLD_DIR];
> > +                       if (myrealpath(mdir, canonical, sizeof(canonical)))
> > +                               mdir = canonical;
> > +                       if (strcmp(mdir, dir) != 0)
> > +                               continue;
> > +               }
> > +
> > +               if (dev != NULL) {
> > +                       mdev = mntent[MNTFLD_FS];
> > +                       if (myrealpath(mdev, canonical, sizeof(canonical)))
> > +                               mdev = canonical;
> > +                       if (strcmp(mdev, dev) != 0)
> > +                               continue;
> > +               }
> > +
> > +               if (has_mntopt(mntent[MNTFLD_OPTS], opt)) {
> >                        nilfs->n_dev = strdup(mntent[MNTFLD_FS]);
> >                        if (nilfs->n_dev == NULL)
> > -                               break;
> > +                               goto failed_proc_mounts;
> >                        len = strlen(mntent[MNTFLD_DIR]) +
> >                                strlen(NILFS_IOC) + 2;
> >                        nilfs->n_ioc = malloc(sizeof(char) * len);
> >                        if (nilfs->n_ioc == NULL) {
> >                                free(nilfs->n_dev);
> >                                nilfs->n_dev = NULL;
> > -                               break;
> > +                               goto failed_proc_mounts;
> >                        }
> >                        snprintf(nilfs->n_ioc, len, "%s/%s",
> >                                 mntent[MNTFLD_DIR], NILFS_IOC);
> > @@ -193,6 +210,10 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> > char *dev, const char *dir,
> >                        break;
> >                }
> >        }
> > +       if (ret < 0)
> > +               errno = ENOENT;
> > +
> > + failed_proc_mounts:
> >        fclose(fp);
> >
> >  failed_dir:
> >
