From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Sun, 26 Jul 2009 12:35:15 -0700 (PDT)
Message-ID: <826723.64411.qm@web58808.mail.re1.yahoo.com>
References: <675178.67834.qm@web58804.mail.re1.yahoo.com>
	<debc30fc0907260905w76ccec51g421ab08ecf3f67bd@mail.gmail.com>
	<288232.83823.qm@web58801.mail.re1.yahoo.com>
	<20090727.035744.118657598.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0483341373=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090727.035744.118657598.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============0483341373==
Content-Type: multipart/alternative; boundary="0-1734587112-1248636915=:64411"

--0-1734587112-1248636915=:64411
Content-Type: text/plain; charset=us-ascii

/proc/mounts:
rootfs / rootfs rw 0 0                                                                                                        
/dev/root / nilfs2 rw,noatime 0 0

The only thing I see in syslog related to nilfs:
Jul 26 12:23:50 gentoo klogd: VFS: Mounted root (nilfs2 filesystem) readonly on device 8:2.
Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: start
Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: override protection period to 0

Note that the nilfs_cleanerd message is from when I started it manually (with -p0).

Using lscp, I see no snapshots, but several thousand checkpoints.  I tried deleting the checkpoints with rmcp, but that didn't free up any space.  The disk is still slowly filling.

Eric




________________________________
From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Sent: Sunday, July 26, 2009 2:57:44 PM
Subject: Re: [NILFS users] df reports used space gradually growing.

Hi,
On Sun, 26 Jul 2009 10:40:08 -0700 (PDT), Eric A wrote:
> You're right; nilfs_cleanered wasn't running.  I've tried rebooting
> and it still isn't automatically starting.  I'm running 2.6.31-rc4
> and nilfs-utils-2.0.14.  The following is the relevant fstab line:
> 
> /dev/sda2               /               nilfs2          rw,noatime              0 0

Oh, I thought the problem would be fixed with nilfs-utils-2.0.14.

How does the relevant line in /proc/mounts look like?

I think you can find the error which terminated cleanerd in
/var/log/syslog or /var/log/messages.

> I manually started nilfs_cleanered and have been running it for
>about an hour.  Conky shows disk read/writes of 1MiB every 2 seconds
>or so, but I don't see any space being freed up.  In fact, df still
>reports a gradual filling of the disk.  Eric

Is is the same thing if you shorten the protection period or release
snapshots ?

Thanks,
Ryusuke Konishi


      
--0-1734587112-1248636915=:64411
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt"><div>/proc/mounts:<br>rootfs / rootfs rw 0 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb
 sp;&nbsp;&nbsp;&nbsp; <br>/dev/root / nilfs2 rw,noatime 0 0<br><br>The only thing I see in syslog related to nilfs:<br>Jul 26 12:23:50 gentoo klogd: VFS: Mounted root
 (nilfs2 filesystem) readonly on device 8:2.<br>Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: start<br>Jul 26 12:31:44 gentoo nilfs_cleanerd[2690]: override protection period to 0<br><br>Note that the nilfs_cleanerd message is from when I started it manually (with -p0).<br><br>Using lscp, I see no snapshots, but several thousand checkpoints.&nbsp; I tried deleting the checkpoints with rmcp, but that didn't free up any space.&nbsp; The disk is still slowly filling.<br><br>Eric<br></div><div style="font-family: times new roman,new york,times,serif; font-size: 12pt;"><br><div style="font-family: arial,helvetica,sans-serif; font-size: 13px;"><font face="Tahoma" size="2"><hr size="1"><b><span style="font-weight: bold;">From:</span></b> Ryusuke Konishi &lt;ryusuke-sG5X7nlA6pw@public.gmane.org&gt;<br><b><span style="
 font-weight: bold;">To:</span></b> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org<br><b><span style="font-weight: bold;">Sent:</span></b> Sunday, July 26, 2009 2:57:44
 PM<br><b><span style="font-weight: bold;">Subject:</span></b> Re: [NILFS users] df reports used space gradually growing.<br></font><br>
Hi,<br>On Sun, 26 Jul 2009 10:40:08 -0700 (PDT), Eric A wrote:<br>&gt; You're right; nilfs_cleanered wasn't running.&nbsp; I've tried rebooting<br>&gt; and it still isn't automatically starting.&nbsp; I'm running 2.6.31-rc4<br>&gt; and nilfs-utils-2.0.14.&nbsp; The following is the relevant fstab line:<br>&gt; <br>&gt; /dev/sda2&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  /&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  nilfs2&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rw,noatime&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 0<br><br>Oh, I thought the problem would be fixed with nilfs-utils-2.0.14.<br><br>How does the relevant line in /proc/mounts look like?<br><br>I think you can find the error which terminated cleanerd in<br>/var/log/syslog or /var/log/messages.<br><br>&gt; I manually 
 started nilfs_cleanered and have been running it for<br>&gt;about an hour.&nbsp; Conky shows disk read/writes of 1MiB every 2 seconds<br>&gt;or so, but I don't see any
 space being freed up.&nbsp; In fact, df still<br>&gt;reports a gradual filling of the disk.&nbsp; Eric<br><br>Is is the same thing if you shorten the protection period or release<br>snapshots ?<br><br>Thanks,<br>Ryusuke Konishi<br><br></div></div></div><br>



      </body></html>
--0-1734587112-1248636915=:64411--


--===============0483341373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0483341373==--

