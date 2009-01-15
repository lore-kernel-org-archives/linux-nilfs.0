From: "Milos Jana" <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Thu, 15 Jan 2009 19:10:19 +0100
Message-ID: <3313c4ab0901151010u67983034vd1b8b75e0672d400@mail.gmail.com>
References: <3313c4ab0901150703o5f86dc67y9261156a5519e1d5@mail.gmail.com>
	<20090116.020115.07539201.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1242605701=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090116.020115.07539201.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1242605701==
Content-Type: multipart/alternative; 
	boundary="----=_Part_14612_3353279.1232043019803"

------=_Part_14612_3353279.1232043019803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Nilfs-utils compiled properly with patch after following instructions from
your previous post. Here is what came out:

user@laptop:~$ sudo fsck0.nilfs2 /dev/sdb
Super-block:
  revision = 2.0, checksum = OK
  blocksize = 4096
  write time = 2008-12-28 09:48:42
  indicated partial segment: blocknr = 4263936
  segnum = 2082, seq = 11746, cno=6661

Clean FS.

user@laptop:~$ sudo mount /media/pendrive/
mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
argument

On Thu, Jan 15, 2009 at 6:01 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi!
> On Thu, 15 Jan 2009 16:03:07 +0100, "Milos Jana" wrote:
> > I managed to apply the patch (the file fsck0.nilfs2.c was created) but
> > after building nilfs-utils I can't find fsck0.nilfs2 command, it looks
> > like it was not compiled.
> >
> > Here is build log: http://wklej.org/id/39551/
>
> Okay. In some environment, Makefiles are not regenerated automatically.
> You may have to run automake and autoconf before running the
> ./configure script.  The full build procedures are as follows:
>
>  $ tar jxf nilfs-utils-2.0.6.tar.bz2
>  $ cd nilfs-utils-2.0.6
>  $ patch -p1 < path-to-fsck0.patch
> [ usually omissible
>  $ aclocal
>  $ autoheader
>  $ libtoolize -c --force
>  $ automake -a -c
>  $ autoconf
> ]
>  $ ./configure
>  $ make
>
>  $ sudo make install
>  $ sudo fsck0.nilfs2 <device>
>
> If your machine doesn't have autoconf, automake, or libtool package,
> these may be required in advance.
>
> How did it come out?
>
> Ryusuke
>

------=_Part_14612_3353279.1232043019803
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<p>Nilfs-utils compiled properly with patch after following instructions from your previous post. Here is what came out: &nbsp;</p><p>user@laptop:~$ sudo fsck0.nilfs2 /dev/sdb<br>Super-block:<br>&nbsp;   revision = 2.0, checksum = OK<br>
&nbsp;   blocksize = 4096<br>&nbsp;   write time = 2008-12-28 09:48:42<br>&nbsp;   indicated partial segment: blocknr = 4263936<br>&nbsp;       segnum = 2082, seq = 11746, cno=6661<br><br>Clean FS.</p><p>user@laptop:~$ sudo mount /media/pendrive/<br>
mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid argument<br></p><br><div class="gmail_quote">On Thu, Jan 15, 2009 at 6:01 PM, Ryusuke Konishi <span dir="ltr">&lt;<a href="mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">Hi!<br>
<div><div class="Wj3C7c">On Thu, 15 Jan 2009 16:03:07 +0100, &quot;Milos Jana&quot; wrote:<br>
&gt; I managed to apply the patch (the file fsck0.nilfs2.c was created) but<br>
&gt; after building nilfs-utils I can&#39;t find fsck0.nilfs2 command, it looks<br>
&gt; like it was not compiled.<br>
&gt;<br>
&gt; Here is build log: <a href="http://wklej.org/id/39551/" target="_blank">http://wklej.org/id/39551/</a><br>
<br>
</div></div>Okay. In some environment, Makefiles are not regenerated automatically.<br>
You may have to run automake and autoconf before running the<br>
./configure script. &nbsp;The full build procedures are as follows:<br>
<br>
&nbsp;$ tar jxf nilfs-utils-2.0.6.tar.bz2<br>
<div class="Ih2E3d">&nbsp;$ cd nilfs-utils-2.0.6<br>
&nbsp;$ patch -p1 &lt; path-to-fsck0.patch<br>
</div>[ usually omissible<br>
&nbsp;$ aclocal<br>
&nbsp;$ autoheader<br>
&nbsp;$ libtoolize -c --force<br>
&nbsp;$ automake -a -c<br>
&nbsp;$ autoconf<br>
]<br>
<div class="Ih2E3d">&nbsp;$ ./configure<br>
&nbsp;$ make<br>
<br>
&nbsp;$ sudo make install<br>
&nbsp;$ sudo fsck0.nilfs2 &lt;device&gt;<br>
<br>
</div>If your machine doesn&#39;t have autoconf, automake, or libtool package,<br>
these may be required in advance.<br>
<br>
How did it come out?<br>
<font color="#888888"><br>
Ryusuke<br>
</font></blockquote></div><br>

------=_Part_14612_3353279.1232043019803--

--===============1242605701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1242605701==--
