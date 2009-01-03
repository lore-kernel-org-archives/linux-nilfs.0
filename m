From: robinx99-hi6Y0CQ0nG0@public.gmane.org
Subject: Re: Kernel Bug after corrupted filesystem
Date: Sat, 03 Jan 2009 08:54:38 +0100
Message-ID: <20090103075438.264510@gmx.net>
References: <20081231111707.25420@gmx.net>
	<20081231.233620.76970897.ryusuke@osrg.net>	<20090101093121.302730@gmx.net>
	<20090102.002735.88475791.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="========GMX264511230969278828605"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090102.002735.88475791.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--========GMX264511230969278828605
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Oops didn't send the mail to the mailinglist, so I will resend.
Hi
> 
> Thanks for your help.
> I have another request:
> 
>  # dumpseg /dev/loop1 12

root@robin-laptop:/tmp# dumpseg /dev/loop1 12
segment: segnum = 12
  partial segment
    creation time = 2008-12-26 11:45:06
    nfinfo = 0



> 
>  - This will dump the summary of the segment in question
> 
>  # dd if=/dev/loop1 bs=4k skip=24576 count=2 | hd
> 
>  - This will dump the (broken) root block of the file system
> 
Ok I atached it to the email bzip2 compressed
> According to your log, the btree root of DAT file (i.e. a table file
> to translate disk addresses) seems inconsistent.  It might not be
> updated properly when GC moved its blocks.  I suspect that it was
> caused by some sort of GC problem.
> 
> And, your nilfs partition seems to have shut down uncleanly before
> this mount error repeatedly happened.  Do you remember what the first
> trouble was like?
> 
Actualy I have no real idea. Didn't start the computer for some days over christmas, befor christmas I could use the filesystem withoul any trouble, and on december 26 I was unable to mount it.
I actualy quite often moved files of the nilfs filesystem to an USB stick. Using comands like 
"mv /mnt/nilfs/directory/*.avi /mnt/usb && poweroff". So there were some shutdowns I didn't watch, and I was thinking that the normal shutdown scripts should unmount every mounted filesystem. Well the computer was definitv off, but I have no idea if it could be possible that something importend was stoped to soon when it came to the point "sending all procecess the term signal"

> Regards,
> Ryusuke
> 
robinx99

--========GMX264511230969278828605
Content-Type: application/octet-stream; name="hd.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hd.bz2"

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
--========GMX264511230969278828605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--========GMX264511230969278828605--
