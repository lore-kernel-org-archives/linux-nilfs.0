From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: Re: Snapshot and mount scripts
Date: Wed, 15 Oct 2008 20:41:04 +1300
Message-ID: <48F59E90.9060404@mib-infotech.co.nz>
References: <48F3C04B.7000300@mib-infotech.co.nz>
	<20081015.152427.73215105.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0541904083=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081015.152427.73215105.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

This is a multi-part message in MIME format.
--===============0541904083==
Content-Type: multipart/alternative;
 boundary="------------090708080509070409070606"

This is a multi-part message in MIME format.
--------------090708080509070409070606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ryusuke,

My point is that I don't actually care about cp's or snapshots.

They are a means to an end and not an end in themselves.

For the purpose of making a backup, if we can snapshot-and-mount, then 
they can be anonymous.
If they are anonymous, we don't have to worry about old snapshots 
filling up the system. Unmount and they are gone.
That covers the biggest use of snapshots-- making a consistent backup.

If you want to change a cp to a ss on mount, you still have to provide 
the cp number, which is hard to script.


The other use would be to do a roll back if required. Perhaps rollback 
to a checkpoint as well as a snapshot.
That's useful but it can wait.



Ryusuke Konishi wrote:
> Hi,
>
> On Tue, 14 Oct 2008 10:40:27 +1300, John Huttley wrote:
>   
>> Hi
>>
>> I've just discovered nilfs, which is great for its snapshot capability.
>>
>> Since the purpose of having a snapshot is to mount it, I was surprised 
>> that the utilities do not
>> have a snapshot-and-mount  and  unmount-and-delete   ability.
>>
>> Has anyone made a script to do this?
>>     
>
> Thank you for your interest in NILFS.
>
> How about making every checkpoint mountable ?
> Does it differ from what you want?
>
> It seems to be possible to enhance mount.nilfs2 and umount.nilfs2 to
> allow changing given checkpoint to snapshot just before mounting, and
> restoring the state on unmount. (This is not a polite way but
> seems enough for most cases)
>
> Regards,
> Ryusuke
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
>
>   

--------------090708080509070409070606
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Hi Ryusuke,<br>
<br>
My point is that I don't actually care about cp's or snapshots.<br>
<br>
They are a means to an end and not an end in themselves.<br>
<br>
For the purpose of making a backup, if we can snapshot-and-mount, then
they can be anonymous.<br>
If they are anonymous, we don't have to worry about old snapshots
filling up the system. Unmount and they are gone.<br>
That covers the biggest use of snapshots-- making a consistent backup.<br>
<br>
If you want to change a cp to a ss on mount, you still have to provide
the cp number, which is hard to script.<br>
<br>
<br>
The other use would be to do a roll back if required. Perhaps rollback
to a checkpoint as well as a snapshot.<br>
That's useful but it can wait. <br>
<br>
<br>
<br>
Ryusuke Konishi wrote:
<blockquote cite="mid:20081015.152427.73215105.ryusuke-sG5X7nlA6pw@public.gmane.org"
 type="cite">
  <pre wrap="">Hi,

On Tue, 14 Oct 2008 10:40:27 +1300, John Huttley wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi

I've just discovered nilfs, which is great for its snapshot capability.

Since the purpose of having a snapshot is to mount it, I was surprised 
that the utilities do not
have a snapshot-and-mount  and  unmount-and-delete   ability.

Has anyone made a script to do this?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Thank you for your interest in NILFS.

How about making every checkpoint mountable ?
Does it differ from what you want?

It seems to be possible to enhance mount.nilfs2 and umount.nilfs2 to
allow changing given checkpoint to snapshot just before mounting, and
restoring the state on unmount. (This is not a polite way but
seems enough for most cases)

Regards,
Ryusuke
_______________________________________________
users mailing list
<a class="moz-txt-link-abbreviated" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a>
<a class="moz-txt-link-freetext"
 href="https://www.nilfs.org/mailman/listinfo/users">https://www.nilfs.org/mailman/listinfo/users</a>


  </pre>
</blockquote>
</body>
</html>

--------------090708080509070409070606--

--===============0541904083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0541904083==--
