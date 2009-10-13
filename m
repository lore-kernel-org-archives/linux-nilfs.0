From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cleanerd
Date: Tue, 13 Oct 2009 21:57:17 +0200
Message-ID: <ee5afd760910131257l2580fbebw64ff25d08899f2f@mail.gmail.com>
References: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
	<20091011.122911.131278678.ryusuke@osrg.net>
	<ee5afd760910102232o5f17c50cxb5024f6f76ecbcf5@mail.gmail.com>
	<20091011.154916.07997858.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0682738389=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091011.154916.07997858.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0682738389==
Content-Type: multipart/alternative; boundary=00c09ffb561c1295420475d67404

--00c09ffb561c1295420475d67404
Content-Type: text/plain; charset=ISO-8859-1

Hallo,
Have not done the patch yet. I was lost in EXT3, some data loss problem.

The HD media test ok with seatools.

I think I found the checkpoints and the segments written just before and one
after the disaster when I tried
to run the hd on another computer. At that time already the /var reported
full.
The system then made an emergency /var somewhere I do not know
Presumably in RAM.

But I cannot mount a snapshot on a loop mounted image and I cannot change a
cp to ss on a full drive.
Is this correct or am I confused?

From the log data on the broken partition I seem to think that nilfs does
not mount the latest checkpoint but I might be mistaken
that is why I wanted to mount the latest in the lscp list. and see if there
are differences.

Regards

Jan de Kruyf.



On Sun, Oct 11, 2009 at 8:49 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi,
> On Sun, 11 Oct 2009 07:32:50 +0200, Jan de Kruyf wrote:
> > Hallo,
> > Sorry the detail was a little bit scant last night.
> > The nilfs versions running on the machine at the time of the disaster
> were
> > the latest versions.
> > This is the maintenance hard-drive running, I will update today.
> >
> > The loop is (as far as I can see now from the logs)
> > -
> > -------kern.log-------------------------------------------
> > Oct 10 06:53:11 debianLenny kernel: [44514.982086] segctord starting.
> > Construction interval = 5 seconds, CP frequency < 30 seconds
> > Oct 10 06:53:11 debianLenny kernel: [44515.115227] NILFS warning:
> mounting
> > unchecked fs
> > Oct 10 06:53:11 debianLenny kernel: [44515.398152] NILFS: recovery
> complete.
> > Oct 10 06:53:28 debianLenny kernel: [44535.631729] NILFS warning (device
> > hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> > Oct 10 06:53:33 debianLenny kernel: [44542.849960] NILFS warning (device
> > hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> > Oct 10 06:53:38 debianLenny kernel: [44550.592403] NILFS warning (device
> > hdb9): nilfs_clean_segments: segment construction failed. (err=-28)
> > ---------------------------------------------------------------
> >
> > this is from the maintenance versions on /dev/hda (still to be updated),
> > with /dev/hdb not functional.
> > It will fill up the log until the partition is full.
>
> According to the log, the error was repeatedly detected in a retry
> loop in the nilfs_clean_segments kernel function which cleanerd calls
> via ioctl.  The err=-28 means ENOSPC (no space left on the device).
>
> Yeah, if cleanerd falls into this state, it cannot handle any signals.
> And, it doesn't return to userspace until the error is removed.
>
> As you are pointing out, I wonder why this error is generated on the
> device having enough free space.
>
> I'll attach a patch to identify which function returns ENOSPC.  Could
> you try the patch ?
>
> Thanks,
> Ryusuke Konishi
>
> > I will dd the partion into a loop-mountable file once I have updated, so
> > diagnostics
> > may continue.
> >
> > I was aware of this problem before: when you overfill a partition
> cleanerd
> > goes into this loop.
> >
> > The interesting part is: how did cleanerd get confused this time. since
> the
> > partition was only half full
> > and cleanerd was running more or less regularly. I am only aware that I
> > stopped cleanerd a few times that day with TERM
> > since it was in the way of other work. It made the /home partition so
> slow
> > that I could not write a dvd anymore.
> > But this is a separate issue.
> >
> > So I will do a low-level check on the sick disc to check for media format
> > failures
> > and I will try to do some log reading over the next few days to see if I
> can
> > find
> > the log of the first mount after the accident.
> >
> > Regards
> > Jan de Kruyf.
> >
> > "Let us sing, the Lord is on his Throne and the earth is full of his
> Glory."
> > enjoy the rest of your day.
>
>
> diff --git a/fs/alloc.c b/fs/alloc.c
> index 1c76c38..fdec249 100644
> --- a/fs/alloc.c
> +++ b/fs/alloc.c
> @@ -235,6 +235,8 @@ static int nilfs_palloc_find_available_slot(struct
> inode *inode,
>                                return pos;
>                }
>        }
> +       printk(KERN_ERR "%s: disk full\n", __func__);
> +       dump_stack();
>        return -ENOSPC;
>  }
>
> @@ -320,6 +322,8 @@ int nilfs_palloc_prepare_alloc_entry(struct inode
> *inode,
>        }
>
>        /* no entries left */
> +       printk(KERN_ERR "%s: disk full\n", __func__);
> +       dump_stack();
>        return -ENOSPC;
>
>  out_desc:
> diff --git a/fs/sufile.c b/fs/sufile.c
> index 47ad9a4..e109a7e 100644
> --- a/fs/sufile.c
> +++ b/fs/sufile.c
> @@ -322,6 +322,8 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64
> *segnump)
>        }
>
>        /* no segments left */
> +       printk(KERN_ERR "%s: disk full\n", __func__);
> +       dump_stack();
>        ret = -ENOSPC;
>
>  out_header:
>

--00c09ffb561c1295420475d67404
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hallo,<br>Have not done the patch yet. I was lost in EXT3, some data loss p=
roblem.<br><br>The HD media test ok with seatools. <br><br>I think I found =
the checkpoints and the segments written just before and one after the disa=
ster when I tried <br>
to run the hd on another computer. At that time already the /var reported=
=A0 full. <br>The system then made an emergency /var somewhere I do not kno=
w<br>Presumably in RAM.<br><br>But I cannot mount a snapshot on a loop moun=
ted image and I cannot change a cp to ss on a full drive.<br>
Is this correct or am I confused?<br><br>From the log data on the broken pa=
rtition I seem to think that nilfs does not mount the latest checkpoint but=
 I might be mistaken<br>that is why I wanted to mount the latest in the lsc=
p list. and see if there are differences.<br>
<br>Regards<br><br>Jan de Kruyf.<br><br><br><br><div class=3D"gmail_quote">=
On Sun, Oct 11, 2009 at 8:49 AM, Ryusuke Konishi <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:ryusuke-sG5X7nlA6pw@public.gmane.org">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 2=
04, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<div class=3D"im">On Sun, 11 Oct 2009 07:32:50 +0200, Jan de Kruyf wrote:<b=
r>
&gt; Hallo,<br>
</div><div class=3D"im">&gt; Sorry the detail was a little bit scant last n=
ight.<br>
&gt; The nilfs versions running on the machine at the time of the disaster =
were<br>
&gt; the latest versions.<br>
&gt; This is the maintenance hard-drive running, I will update today.<br>
&gt;<br>
&gt; The loop is (as far as I can see now from the logs)<br>
&gt; -<br>
&gt; -------kern.log-------------------------------------------<br>
&gt; Oct 10 06:53:11 debianLenny kernel: [44514.982086] segctord starting.<=
br>
&gt; Construction interval =3D 5 seconds, CP frequency &lt; 30 seconds<br>
&gt; Oct 10 06:53:11 debianLenny kernel: [44515.115227] NILFS warning: moun=
ting<br>
&gt; unchecked fs<br>
&gt; Oct 10 06:53:11 debianLenny kernel: [44515.398152] NILFS: recovery com=
plete.<br>
&gt; Oct 10 06:53:28 debianLenny kernel: [44535.631729] NILFS warning (devi=
ce<br>
&gt; hdb9): nilfs_clean_segments: segment construction failed. (err=3D-28)<=
br>
&gt; Oct 10 06:53:33 debianLenny kernel: [44542.849960] NILFS warning (devi=
ce<br>
&gt; hdb9): nilfs_clean_segments: segment construction failed. (err=3D-28)<=
br>
&gt; Oct 10 06:53:38 debianLenny kernel: [44550.592403] NILFS warning (devi=
ce<br>
&gt; hdb9): nilfs_clean_segments: segment construction failed. (err=3D-28)<=
br>
&gt; ---------------------------------------------------------------<br>
&gt;<br>
&gt; this is from the maintenance versions on /dev/hda (still to be updated=
),<br>
&gt; with /dev/hdb not functional.<br>
&gt; It will fill up the log until the partition is full.<br>
<br>
</div>According to the log, the error was repeatedly detected in a retry<br=
>
loop in the nilfs_clean_segments kernel function which cleanerd calls<br>
via ioctl. =A0The err=3D-28 means ENOSPC (no space left on the device).<br>
<br>
Yeah, if cleanerd falls into this state, it cannot handle any signals.<br>
And, it doesn&#39;t return to userspace until the error is removed.<br>
<br>
As you are pointing out, I wonder why this error is generated on the<br>
device having enough free space.<br>
<br>
I&#39;ll attach a patch to identify which function returns ENOSPC. =A0Could=
<br>
you try the patch ?<br>
<br>
Thanks,<br>
Ryusuke Konishi<br>
<div class=3D"im"><br>
&gt; I will dd the partion into a loop-mountable file once I have updated, =
so<br>
&gt; diagnostics<br>
&gt; may continue.<br>
&gt;<br>
&gt; I was aware of this problem before: when you overfill a partition clea=
nerd<br>
&gt; goes into this loop.<br>
&gt;<br>
&gt; The interesting part is: how did cleanerd get confused this time. sinc=
e the<br>
&gt; partition was only half full<br>
&gt; and cleanerd was running more or less regularly. I am only aware that =
I<br>
&gt; stopped cleanerd a few times that day with TERM<br>
&gt; since it was in the way of other work. It made the /home partition so =
slow<br>
&gt; that I could not write a dvd anymore.<br>
&gt; But this is a separate issue.<br>
&gt;<br>
&gt; So I will do a low-level check on the sick disc to check for media for=
mat<br>
&gt; failures<br>
&gt; and I will try to do some log reading over the next few days to see if=
 I can<br>
&gt; find<br>
&gt; the log of the first mount after the accident.<br>
&gt;<br>
&gt; Regards<br>
&gt; Jan de Kruyf.<br>
&gt;<br>
&gt; &quot;Let us sing, the Lord is on his Throne and the earth is full of =
his Glory.&quot;<br>
&gt; enjoy the rest of your day.<br>
<br>
<br>
</div>diff --git a/fs/alloc.c b/fs/alloc.c<br>
index 1c76c38..fdec249 100644<br>
--- a/fs/alloc.c<br>
+++ b/fs/alloc.c<br>
@@ -235,6 +235,8 @@ static int nilfs_palloc_find_available_slot(struct inod=
e *inode,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return pos;=
<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}<br>
 =A0 =A0 =A0 =A0}<br>
+ =A0 =A0 =A0 printk(KERN_ERR &quot;%s: disk full\n&quot;, __func__);<br>
+ =A0 =A0 =A0 dump_stack();<br>
 =A0 =A0 =A0 =A0return -ENOSPC;<br>
=A0}<br>
<br>
@@ -320,6 +322,8 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inod=
e,<br>
 =A0 =A0 =A0 =A0}<br>
<br>
 =A0 =A0 =A0 =A0/* no entries left */<br>
+ =A0 =A0 =A0 printk(KERN_ERR &quot;%s: disk full\n&quot;, __func__);<br>
+ =A0 =A0 =A0 dump_stack();<br>
 =A0 =A0 =A0 =A0return -ENOSPC;<br>
<br>
 =A0out_desc:<br>
diff --git a/fs/sufile.c b/fs/sufile.c<br>
index 47ad9a4..e109a7e 100644<br>
--- a/fs/sufile.c<br>
+++ b/fs/sufile.c<br>
@@ -322,6 +322,8 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *seg=
nump)<br>
 =A0 =A0 =A0 =A0}<br>
<br>
 =A0 =A0 =A0 =A0/* no segments left */<br>
+ =A0 =A0 =A0 printk(KERN_ERR &quot;%s: disk full\n&quot;, __func__);<br>
+ =A0 =A0 =A0 dump_stack();<br>
 =A0 =A0 =A0 =A0ret =3D -ENOSPC;<br>
<br>
 =A0out_header:<br>
</blockquote></div><br>

--00c09ffb561c1295420475d67404--

--===============0682738389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0682738389==--
