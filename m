From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [NILFS] NILFS filesystem stability
Date: Sun, 03 Jan 2010 16:39:27 +0900 (JST)
Message-ID: <20100103.163927.12303106.ryusuke@osrg.net>
References: <71d11f861001011335j459d29e8oddb7f4d49dd41126@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <71d11f861001011335j459d29e8oddb7f4d49dd41126-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: wielkiegie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Fri, 1 Jan 2010 22:35:42 +0100, Gustaw Smolarczyk wrote:
> Hello all,
> 
> I wanted to know if NILFS filesystem is ready to general purpose. I am
> going to make a backup partition (containing important files from
> general purpose FS on second HD) and I don't know what FS to use on
> it. Log-based filesystem is considered right there for me because of
> COW semantics and that no previous data would be loss in case of write
> susped/error. I thought about btrfs as well, but AFAIK it's even less
> stable than NILFS and is not COW to that extent that NILFS is (using
> NILFS I can mount exatly what would be mounted few days/writes ago
> with cp= mount option, in case no physical error occured).

I think NILFS can serve as general purpose filesystem except some
features like extended attributes/POSIX acls are not yet supported,
and except for a few known issues, for instance, GC daemon constantly
makes I/O load more than necessary.

I'm using NILFS as a root filesystem of my laptop, and it's stably
working without noticeable trouble for past several months.

At the end of the last year I mistakenly broke package dependencies of
Debian system.  Fortunately, I could revert the system state before
the corruption with NILFS snapshots and rsync.

It still needs backup since NILFS is not of help for hardware
malfunction.  However, I feel it's actually helpful for human errors
through experiences like that.
 
> There are many adventages for using NILFS for that purpose, but
> stability is the greatest factor (it's all about my data!). So I want
> to know what do you think about using this fresh filesystem - is it
> good idea or have I to use a more stable solution, like ext2/reiserfs
> or something else? Is log-structured filesystem more secure than
> regular one (which I think it is), or is more known and maintained one
> better?

Without snapshots, I think ext3 is still the best.  NILFS is now
pretty stable as the result of sustained effort and many feedbacks.

In general, log structured filesystems can achieve quick recovery like
journaling filesystems, whereas garbage collection often becomes cause
of trouble since it moves disk blocks.  As for nilfs, looks like it
overcame the latter barrier.

Note that NILFS still lacks fsck.  You may go back before filesystem
corruption, but this is not always possible since some types of
metadata are not redundant.

> Thanks for any answers :) I hope I'll get good respone in new year time :)

Cheers,
Ryusuke Konishi
