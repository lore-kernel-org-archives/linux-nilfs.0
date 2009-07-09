From: Quentin RAMEAU <quinq.ml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't start nilfs_cleanerd on root fs.
Date: Thu, 9 Jul 2009 15:06:28 +0200
Message-ID: <21e999b60907090606o2eba4972t80ef969594f300ff@mail.gmail.com>
References: <21e999b60907040743l3940f2a2y1a7b0e56dfe73d73@mail.gmail.com>
	<20090705.135657.105810904.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0315879329=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090705.135657.105810904.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0315879329==
Content-Type: multipart/alternative; boundary=0015174c18ea1a67bc046e4586c0

--0015174c18ea1a67bc046e4586c0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I am sorry for that delayed response. I applied this patch, nilfs is still
working, but it didin't solve my problem.
There is some news though, I found out that nilfs_cleanerd works when I use
an initrd, mounting my root fs in it, and doing a switch_root then.
(I can restart it etc, works fine)

Here is my /proc/mounts without initrd:
$ cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / nilfs2 rw,relatime 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
none /dev ramfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
/dev/hda2 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
/dev/hda4 /DATA nilfs2 rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0

and with initrd:
$ cat /proc/mounts
rootfs / rootfs rw 0 0
tmpfs /dev tmpfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
/dev/hda3 / nilfs2 rw,relatime 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
none /dev ramfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
/dev/hda2 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
/dev/hda4 /DATA nilfs2 rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0

2009/7/5 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

> Hi!
> On Sat, 4 Jul 2009 16:43:31 +0200, Quentin RAMEAU wrote:
> > Hello,
> >
> > I formated my root fs with nilfs a few days ago, but I can't start
> cleanerd
> > for that fs.
> > I have another nilfs on that system that seems to work correctly.
> >
> > Maybe I am doing something wrong, at least, there something that could be
> > done, here is some info about it:
> >
> > $ uname -r
> > 2.6.30-zen1
> >
> > $ mount -t nilfs2
> > /dev/hda3 on / type nilfs2 (rw,gcpid=1510)
> > /dev/hda4 on /DATA type nilfs2 (rw,gcpid=1675)
> >
> > $ ps -ef | grep nilfs
> > root      1675     1  0 12:56 ?        00:00:02 /sbin/nilfs_cleanerd -n
> > /dev/hda4 /DATA
> >
> > $ nilfs_cleanerd /dev/hda3 && tail /var/log/everything/current | grep
> nilfs
> > Jul 04 15:46:29 [nilfs_cleanerd] start
> > Jul 04 15:46:29 [nilfs_cleanerd] cannot open nilfs on /dev/hda3: Invalid
> > argument
> > Jul 04 15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3:
> > Invalid argument
> > Jul 04 15:46:29 [nilfs_cleanerd] shutdown
>
> I think this comes from a matching error in /proc/mounts. I found a
> symlink entry is used for the device of root filesystem in some
> environments.  The current nilfs library does not support such case.
>
> What's going on your /proc/mounts?
>
> Anyway, I wrote a patch to handle the above case.
>
> If this is the case, could you try the following patch?
>
> Thanks in advance,
> Ryusuke Konishi
>
> --
> diff --git a/lib/nilfs.c b/lib/nilfs.c
> index 75179e3..df8792b 100644
> --- a/lib/nilfs.c
> +++ b/lib/nilfs.c
> @@ -148,6 +148,7 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> char *dev, const char *dir,
>        int ret, n;
>        char canonical[PATH_MAX + 2];
>        char *cdev = NULL, *cdir = NULL;
> +       char *mdev, *mdir;
>
>        ret = -1;
>        if (dev && myrealpath(dev, canonical, sizeof(canonical))) {
> @@ -172,20 +173,36 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> char *dev, const char *dir,
>                n = tokenize(line, mntent, NMNTFLDS);
>                assert(n == NMNTFLDS);
>
> -               if ((dev == NULL || strcmp(mntent[MNTFLD_FS], dev) == 0) &&
> -                   (dir == NULL || strcmp(mntent[MNTFLD_DIR], dir) == 0)
> &&
> -                   strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) == 0 &&
> -                   has_mntopt(mntent[MNTFLD_OPTS], opt)) {
> +               if (strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) != 0)
> +                       continue;
> +
> +               if (dir != NULL) {
> +                       mdir = mntent[MNTFLD_DIR];
> +                       if (myrealpath(mdir, canonical, sizeof(canonical)))
> +                               mdir = canonical;
> +                       if (strcmp(mdir, dir) != 0)
> +                               continue;
> +               }
> +
> +               if (dev != NULL) {
> +                       mdev = mntent[MNTFLD_FS];
> +                       if (myrealpath(mdev, canonical, sizeof(canonical)))
> +                               mdev = canonical;
> +                       if (strcmp(mdev, dev) != 0)
> +                               continue;
> +               }
> +
> +               if (has_mntopt(mntent[MNTFLD_OPTS], opt)) {
>                        nilfs->n_dev = strdup(mntent[MNTFLD_FS]);
>                        if (nilfs->n_dev == NULL)
> -                               break;
> +                               goto failed_proc_mounts;
>                        len = strlen(mntent[MNTFLD_DIR]) +
>                                strlen(NILFS_IOC) + 2;
>                        nilfs->n_ioc = malloc(sizeof(char) * len);
>                        if (nilfs->n_ioc == NULL) {
>                                free(nilfs->n_dev);
>                                nilfs->n_dev = NULL;
> -                               break;
> +                               goto failed_proc_mounts;
>                        }
>                        snprintf(nilfs->n_ioc, len, "%s/%s",
>                                 mntent[MNTFLD_DIR], NILFS_IOC);
> @@ -193,6 +210,10 @@ static int nilfs_find_fs(struct nilfs *nilfs, const
> char *dev, const char *dir,
>                        break;
>                }
>        }
> +       if (ret < 0)
> +               errno = ENOENT;
> +
> + failed_proc_mounts:
>        fclose(fp);
>
>  failed_dir:
>

--0015174c18ea1a67bc046e4586c0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am sorry for that delayed response. I applied this patch, nilf=
s is still working, but it didin&#39;t solve my problem.<br>There is some n=
ews though, I found out that nilfs_cleanerd works when I
use an initrd, mounting my root fs in it, and doing a switch_root then.<br>
(I can restart it etc, works fine)<br><br>Here is my /proc/mounts without i=
nitrd:<br>$ cat /proc/mounts<br>rootfs / rootfs rw 0 0<br>/dev/root / nilfs=
2 rw,relatime 0 0<br>proc /proc proc rw,relatime 0 0<br>sysfs /sys sysfs rw=
,relatime 0 0<br>
none /dev ramfs rw,relatime 0 0<br>devpts /dev/pts devpts rw,relatime,mode=
=3D600 0 0<br>/dev/hda2 /boot ext3 rw,relatime,errors=3Dcontinue,data=3Dwri=
teback 0 0<br>/dev/hda4 /DATA nilfs2 rw,relatime 0 0<br>fusectl /sys/fs/fus=
e/connections fusectl rw,relatime 0 0<br>
<br>and with initrd:<br>$ cat /proc/mounts<br>rootfs / rootfs rw 0 0<br>tmp=
fs /dev tmpfs rw,relatime 0 0<br>devpts /dev/pts devpts rw,relatime,mode=3D=
600 0 0<br>/dev/hda3 / nilfs2 rw,relatime 0 0<br>proc /proc proc rw,relatim=
e 0 0<br>
sysfs /sys sysfs rw,relatime 0 0<br>none /dev ramfs rw,relatime 0 0<br>devp=
ts /dev/pts devpts rw,relatime,mode=3D600 0 0<br>/dev/hda2 /boot ext3 rw,re=
latime,errors=3Dcontinue,data=3Dwriteback 0 0<br>/dev/hda4 /DATA nilfs2 rw,=
relatime 0 0<br>
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0<br><br><div class=
=3D"gmail_quote">2009/7/5 Ryusuke Konishi <span dir=3D"ltr">&lt;<a href=3D"=
mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span><br><blockquote cla=
ss=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); marg=
in: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi!<br>
<div class=3D"im">On Sat, 4 Jul 2009 16:43:31 +0200, Quentin RAMEAU wrote:<=
br>
&gt; Hello,<br>
&gt;<br>
&gt; I formated my root fs with nilfs a few days ago, but I can&#39;t start=
 cleanerd<br>
&gt; for that fs.<br>
&gt; I have another nilfs on that system that seems to work correctly.<br>
&gt;<br>
&gt; Maybe I am doing something wrong, at least, there something that could=
 be<br>
&gt; done, here is some info about it:<br>
&gt;<br>
&gt; $ uname -r<br>
&gt; 2.6.30-zen1<br>
&gt;<br>
&gt; $ mount -t nilfs2<br>
&gt; /dev/hda3 on / type nilfs2 (rw,gcpid=3D1510)<br>
&gt; /dev/hda4 on /DATA type nilfs2 (rw,gcpid=3D1675)<br>
&gt;<br>
&gt; $ ps -ef | grep nilfs<br>
&gt; root =A0 =A0 =A01675 =A0 =A0 1 =A00 12:56 ? =A0 =A0 =A0 =A000:00:02 /s=
bin/nilfs_cleanerd -n<br>
&gt; /dev/hda4 /DATA<br>
&gt;<br>
&gt; $ nilfs_cleanerd /dev/hda3 &amp;&amp; tail /var/log/everything/current=
 | grep nilfs<br>
&gt; Jul 04 15:46:29 [nilfs_cleanerd] start<br>
&gt; Jul 04 15:46:29 [nilfs_cleanerd] cannot open nilfs on /dev/hda3: Inval=
id<br>
&gt; argument<br>
&gt; Jul 04 15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3:<=
br>
&gt; Invalid argument<br>
&gt; Jul 04 15:46:29 [nilfs_cleanerd] shutdown<br>
<br>
</div>I think this comes from a matching error in /proc/mounts. I found a<b=
r>
symlink entry is used for the device of root filesystem in some<br>
environments. =A0The current nilfs library does not support such case.<br>
<br>
What&#39;s going on your /proc/mounts?<br>
<br>
Anyway, I wrote a patch to handle the above case.<br>
<br>
If this is the case, could you try the following patch?<br>
<br>
Thanks in advance,<br>
Ryusuke Konishi<br>
<br>
--<br>
diff --git a/lib/nilfs.c b/lib/nilfs.c<br>
index 75179e3..df8792b 100644<br>
--- a/lib/nilfs.c<br>
+++ b/lib/nilfs.c<br>
@@ -148,6 +148,7 @@ static int nilfs_find_fs(struct nilfs *nilfs, const cha=
r *dev, const char *dir,<br>
 =A0 =A0 =A0 =A0int ret, n;<br>
 =A0 =A0 =A0 =A0char canonical[PATH_MAX + 2];<br>
 =A0 =A0 =A0 =A0char *cdev =3D NULL, *cdir =3D NULL;<br>
+ =A0 =A0 =A0 char *mdev, *mdir;<br>
<br>
 =A0 =A0 =A0 =A0ret =3D -1;<br>
 =A0 =A0 =A0 =A0if (dev &amp;&amp; myrealpath(dev, canonical, sizeof(canoni=
cal))) {<br>
@@ -172,20 +173,36 @@ static int nilfs_find_fs(struct nilfs *nilfs, const c=
har *dev, const char *dir,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0n =3D tokenize(line, mntent, NMNTFLDS);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0assert(n =3D=3D NMNTFLDS);<br>
<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((dev =3D=3D NULL || strcmp(mntent[MNTFLD_=
FS], dev) =3D=3D 0) &amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (dir =3D=3D NULL || strcmp(mntent[MNT=
FLD_DIR], dir) =3D=3D 0) &amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strcmp(mntent[MNTFLD_TYPE], NILFS_FST=
YPE) =3D=3D 0 &amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_mntopt(mntent[MNTFLD_OPTS], opt))=
 {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE)=
 !=3D 0)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dir !=3D NULL) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdir =3D mntent[MNTFLD_DIR];<=
br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (myrealpath(mdir, canonica=
l, sizeof(canonical)))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdir =3D cano=
nical;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strcmp(mdir, dir) !=3D 0)=
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev !=3D NULL) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdev =3D mntent[MNTFLD_FS];<b=
r>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (myrealpath(mdev, canonica=
l, sizeof(canonical)))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdev =3D cano=
nical;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strcmp(mdev, dev) !=3D 0)=
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_mntopt(mntent[MNTFLD_OPTS], opt)) {<b=
r>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nilfs-&gt;n_dev =3D strdup(=
mntent[MNTFLD_FS]);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nilfs-&gt;n_dev =3D=3D =
NULL)<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_p=
roc_mounts;<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D strlen(mntent[MNTFL=
D_DIR]) +<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strlen(NILF=
S_IOC) + 2;<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nilfs-&gt;n_ioc =3D malloc(=
sizeof(char) * len);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nilfs-&gt;n_ioc =3D=3D =
NULL) {<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free(nilfs-=
&gt;n_dev);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nilfs-&gt;n=
_dev =3D NULL;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_p=
roc_mounts;<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snprintf(nilfs-&gt;n_ioc, l=
en, &quot;%s/%s&quot;,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mntent[MNT=
FLD_DIR], NILFS_IOC);<br>
@@ -193,6 +210,10 @@ static int nilfs_find_fs(struct nilfs *nilfs, const ch=
ar *dev, const char *dir,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}<br>
 =A0 =A0 =A0 =A0}<br>
+ =A0 =A0 =A0 if (ret &lt; 0)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 errno =3D ENOENT;<br>
+<br>
+ failed_proc_mounts:<br>
 =A0 =A0 =A0 =A0fclose(fp);<br>
<br>
 =A0failed_dir:<br>
</blockquote></div><br>

--0015174c18ea1a67bc046e4586c0--

--===============0315879329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0315879329==--
