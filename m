From: Jesse Campbell <hikeit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NILFS usage on NAND and NOR flash memory
Date: Tue, 23 Jun 2009 18:42:32 -0700
Message-ID: <585a0ef70906231842p31130fd5h54cd124c6751ec7b@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Good day everyone, I do hope this has not already been asked as I had
trouble searching the archive, and nothing meaningful came up in a
search.

My question is this:
I am using android on an ARM-based pda phone.
Android works by having a system partition and a data partition. In
our environment, everything is mounted loop, as we have everything
sitting on an SD card formatted FAT for windows mobile (our launcher
runs from windows mobile)

How well would NILFS function as the loop data partition? We're
looking at 128MB, and it is used extensively for cache and sqlite3
database reads/writes. Currently we're using ext2, but it has issues
with fault tolerance, and on a device that doesn't unmount on
shutdown, faults happen every time you turn it off (lots of data
corruption).
ext3 was tried, but there were so many writes that the location of the
journal on the SD card burned and the card became unusable.

Does NILFS handle this kind of thing better? Is there a log that is
constantly written and overwritten, or does it sort of log as it goes?
My understanding of log-centric filesystems is better than a few days
ago (but still have lots to learn), it treats the whole partition as a
sequential loop for writes, with random access reads (right?). I would
think this would work better than ext2 for load leveling too.

Any ideas or suggestions would be greatly appreciated, my co-developer
things it would be "doing unnecessary writes" and that ext2 "should
work fine"... but I don't want to burn my card, and I'd like some
better fault tolerance.

Thanks all,
Jesse Campbell
