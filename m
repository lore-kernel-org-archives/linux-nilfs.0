From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: Re: Crash bug, was cleanerd stopping
Date: Mon, 29 Dec 2008 09:08:46 +1300
Message-ID: <4957DCCE.6000100@mib-infotech.co.nz>
References: <4956A4D6.2010004@mib-infotech.co.nz>
	<20081228.122201.64850929.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0955478584=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081228.122201.64850929.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

This is a multi-part message in MIME format.
--===============0955478584==
Content-Type: multipart/alternative;
 boundary="------------060804050007070406050607"

This is a multi-part message in MIME format.
--------------060804050007070406050607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ryusuke,
I'm using 2.6.27-gentoo-r7 kernel (64bit)

The fs is on a logical partition managed by  evms.

The imap software is cyrus.

Its wasn't heavily stressed. Three users.

Every night a script would take a snapshot, mount it and do a backup.
Then delete that snapshot.

Regards,

John


Ryusuke Konishi wrote:
> Hi John,
> On Sun, 28 Dec 2008 10:57:42 +1300, John Huttley wrote:
>   
>> Hi Ryusuke,
>>
>> I built from your git repo.
>>
>> It seemed to work for the first few days, then it crashed and now its 
>> hard crashed with the following
>> message
>>     
>
> Sorry for the inconvenience.
> The log shows that destruction of btree was occurred.
>
> I'm now doing a stress test against the latest nilfs of the git repo,
> but I feel my Debian environment is unsuited to reproduce your problem.
>
> You are using gentoo 2008.0 (2.6.26-gentoo), aren't you?
> I'd like to do the stress test on a similar environment.
>
> Could you tell me which IMAP daemon you were using on the nilfs
> partition? (courier-imap?)
>
> Regards,
> Ryusuke
>
>
>   

--------------060804050007070406050607
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
I'm using 2.6.27-gentoo-r7 kernel (64bit)<br>
<br>
The fs is on a logical partition managed by&nbsp; evms.<br>
<br>
The imap software is cyrus.<br>
<br>
Its wasn't heavily stressed. Three users.<br>
<br>
Every night a script would take a snapshot, mount it and do a backup.<br>
Then delete that snapshot.<br>
<br>
Regards,<br>
<br>
John<br>
<br>
<br>
Ryusuke Konishi wrote:
<blockquote cite="mid:20081228.122201.64850929.ryusuke-sG5X7nlA6pw@public.gmane.org"
 type="cite">
  <pre wrap="">Hi John,
On Sun, 28 Dec 2008 10:57:42 +1300, John Huttley wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi Ryusuke,

I built from your git repo.

It seemed to work for the first few days, then it crashed and now its 
hard crashed with the following
message
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Sorry for the inconvenience.
The log shows that destruction of btree was occurred.

I'm now doing a stress test against the latest nilfs of the git repo,
but I feel my Debian environment is unsuited to reproduce your problem.

You are using gentoo 2008.0 (2.6.26-gentoo), aren't you?
I'd like to do the stress test on a similar environment.

Could you tell me which IMAP daemon you were using on the nilfs
partition? (courier-imap?)

Regards,
Ryusuke


  </pre>
</blockquote>
</body>
</html>

--------------060804050007070406050607--

--===============0955478584==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0955478584==--
