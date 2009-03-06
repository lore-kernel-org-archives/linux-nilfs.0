From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.9 and NILFS 2.0.10 released
Date: Sat, 07 Mar 2009 03:01:08 +0900 (JST)
Message-ID: <20090307.030108.28244831.ryusuke@osrg.net>
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

Dear NILFS users,

We have released nilfs-2.0.9 and nilfs-2.0.10 with corresponding
utility packages.

Nilfs-2.0.9 fixed an endian bug in super block; the former versions
missed an endian conversion and turned out to have architecture
dependency in the disk format.  I fixed the problem in this release to
avoid future confusion, but this once breaks disk format compatibilty
on big endian machines.  Fortunately little endian machines (e.g. x86
archs) are not affected, and even for big endian machines the problem
can be fixed by once mounting with nilfs-2.0.9. That is why I released
this version.

Nilfs-utils-2.0.9 is the companion package of nilfs-2.0.9.  But, its
main change is not the above fix but that of cleanerd bug which has
caused incorrect removal of checkpoints within protection period.

Nilfs-2.0.10 and nilfs-utils-2.0.10 will add secondary super block in
tail of the nilfs partition, and this improves reliability of the
nilfs file system against corruption of the super block.  Former
versions didn't have extra super blocks, and had a possiblity to
become unmountable if the primary super block is destroyed.
Incidentally, this extension is achieved without losing disk format
compatibility.

The updated package can be found at:
http://www.nilfs.org/en/download.html

Thanks,
--
Ryusuke Konishi
NILFS team NTT
