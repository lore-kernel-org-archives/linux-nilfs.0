From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Fri, 30 Jan 2009 21:03:23 +0900 (JST)
Message-ID: <20090130.210323.88475416.ryusuke@osrg.net>
References: <55b53420901160316h2b1e70e3xc420321973ce99b4@mail.gmail.com>
	<20090116.222255.131926946.ryusuke@osrg.net>
	<3313c4ab0901231613g2d82ea3at13e524dfba28df4@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0901231613g2d82ea3at13e524dfba28df4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Sat, 24 Jan 2009 01:13:41 +0100, Milos Jana wrote:
> Hi again,
> 
> Looks like I'm unable to mount this drive again. It mounted successfully
> several times after following your previous posts, but yesterday the problem
> came back. I'm sure that I have been mounting/unmounting my pendrive
> properly.

Hmm, it's abnormal that this occurs so often.
The partition was cleanly unmounted, but the latest segment was not written.
The usb device seems to lack proper support of cache flushing if it
occurs just before power-off.

The usb stack of Linux is often problematic, but this looks terrific.
 
> This time fsck0.nilfs2 doesn't help - it hangs with "Searching the
> latest checkpoint." message (see below).

All right, I'll look into the hang problem.

Please note that the fsck0 is not a complete solution.
To make it better, we need a few changes on the disk format.

Regards,
Ryusuke

> user@laptop:~$ sudo mount /media/pendrive/
> mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> argument
> 
> user@laptop:~$ dmesg
> ...
> [22429.446924] NILFS warning: Segment magic number invalid
> [22429.446932] NILFS: error searching super root.
> 
> user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb #
> Nilfs-tools with first patch applied
> Super-block:
>   revision = 2.0, checksum = OK
>   blocksize = 4096
>   write time = 2009-01-22 23:40:19
>   indicated partial segment: blocknr = 1966080
>   segnum = 960, seq = 18266, cno=10169
> 
> Clean FS.
> 
> user@laptop:~/prog/sources/nilfs-utils-2.0.6$ sudo fsck0.nilfs2 /dev/sdb #
> Nilfs-tools with additional patch applied
> Super-block:
>   revision = 2.0, checksum = OK
>   blocksize = 4096
>   write time = 2009-01-22 23:40:19
>   indicated partial segment: blocknr = 1966080
>   segnum = 960, seq = 18266, cno=10169
> 
> empty or bad segment: segnum = 960, blocknr = 1966080
> The latest segment is lost. Trying rollback recovery..
> .
> Searching the latest checkpoint.    # here it hanged for like 10 minutes
> until I killed it
