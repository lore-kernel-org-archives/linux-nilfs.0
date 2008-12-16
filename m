From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: Re: cleanerd stopping
Date: Wed, 17 Dec 2008 06:48:59 +1300
Message-ID: <4947EA0B.3040604@mib-infotech.co.nz>
References: <49162468.8020503@mib-infotech.co.nz>
	<20081217.001437.44157644.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0022080695=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081217.001437.44157644.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

This is a multi-part message in MIME format.
--===============0022080695==
Content-Type: multipart/alternative;
 boundary="------------010301050804040101080206"

This is a multi-part message in MIME format.
--------------010301050804040101080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ryusuke,

The machine is has 1Gb ram 5110 processor in 64 bit mode
nilfs is in a 4Gb partition. It is my IMAP spool.
The only time snapshots are taken is for backup, this is daily.

Traffic is low on the fs and the snapshot is deleted after the backup.

--john


Ryusuke Konishi wrote:
> On Sun, 09 Nov 2008 12:44:40 +1300, John Huttley wrote:
>   
>> Hi,
>> I've found that the cleaner will only run for a day or so, then it stops.
>>
>> The log is as follows.
>>     
> <snip>
>   
>> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: wake up
>> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
>> 2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
>> be cleaned
>> 2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: cannot clean segments: 
>> No such file or directory
>> 2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: shutdown
>>     
>
> I've found a bug of nilfs2 kernel module (in ioctl code) that may
> cause this error.
>
> If the bug was the cause, it should occur for volumes having numerous
> snapshots, or on the machine whose amount of memory is low.
>
> I would like to fix this early.
>
> Regards,
> Ryusuke
>
>
>   

--------------010301050804040101080206
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
The machine is has 1Gb ram 5110 processor in 64 bit mode<br>
nilfs is in a 4Gb partition. It is my IMAP spool.<br>
The only time snapshots are taken is for backup, this is daily.<br>
<br>
Traffic is low on the fs and the snapshot is deleted after the backup.<br>
<br>
--john<br>
<br>
<br>
Ryusuke Konishi wrote:
<blockquote cite="mid:20081217.001437.44157644.ryusuke-sG5X7nlA6pw@public.gmane.org"
 type="cite">
  <pre wrap="">On Sun, 09 Nov 2008 12:44:40 +1300, John Huttley wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi,
I've found that the cleaner will only run for a day or so, then it stops.

The log is as follows.
    </pre>
  </blockquote>
  <pre wrap=""><!---->&lt;snip&gt;
  </pre>
  <blockquote type="cite">
    <pre wrap="">2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: wake up
2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: ncleansegs = 285
2008-11-07T22:02:37+13:00 nilfs_cleanerd[7232]: 2 segments selected to 
be cleaned
2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: cannot clean segments: 
No such file or directory
2008-11-07T22:02:39+13:00 nilfs_cleanerd[7232]: shutdown
    </pre>
  </blockquote>
  <pre wrap=""><!---->
I've found a bug of nilfs2 kernel module (in ioctl code) that may
cause this error.

If the bug was the cause, it should occur for volumes having numerous
snapshots, or on the machine whose amount of memory is low.

I would like to fix this early.

Regards,
Ryusuke


  </pre>
</blockquote>
</body>
</html>

--------------010301050804040101080206--

--===============0022080695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0022080695==--
