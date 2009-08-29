From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: segctord problem
Date: Sun, 30 Aug 2009 05:50:14 +0900 (JST)
Message-ID: <20090830.055014.88471834.ryusuke@osrg.net>
References: <debc30fc0908270825v747c1734xa59126623cfd5b05@mail.gmail.com>
	<debc30fc0908271439x63d16227mbf5589c8db455b1e@mail.gmail.com>
	<debc30fc0908290948g3ee60e81u1f024b3031e36f36@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0908290948g3ee60e81u1f024b3031e36f36-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

Hi!
On Sat, 29 Aug 2009 12:48:03 -0400, J=E9r=F4me Poulin wrote:
> I just found out there were 3 bad sectors on my hard drive, however
> I just changed it last night, it copied over with only a missing
> 4096 bytes. NILFS was the only filesystem who experienced problem
> with those bad sectors, thanks to it's log-like structure which
> seems to be able to discover to kind of errors. It woulnd't mount
> yesterday, I copied it over, then started it this morning thinking
> the segctord problem could have been caused by that, however it is
> not, I experienced it again this morning, it started then ended
> while I was eating, so I could capture the log from start to end
> this time, so this could give you a hint on what caused it, and it
> seems me and Eric are using a 64 bits kernel too.
>
> Summary of log:
> Aug 28 21:03: I started my computer and it wouldn't start X, looked at the
> log, it was showing I wasn't having a /home.
> Rebooted with init=3D3D/bin/bash and found out disk had bad sectors, copi=
ed o=3D
ver a new HD.
> Aug 29 10:41 Rebooted with new disk, everything's okay.
> Aud 29 12:08 WARNING: at kernel/sched.c:4890 sub_preempt_count+0x95/0xa0(=
),
start of errors.
> Aug 29 12:29 End of errors.

Thank you for sending me the log.

I've found a bug which seems like the cause of this problem.  The
following patch is the bugfix.

Could you test if the patch makes a difference ?

Thanks,
Ryusuke Konishi

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 7e0b61b..c668bca 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -209,6 +209,7 @@ int nilfs_btnode_prepare_change_key(struct address_spac=
e *btnc,
 		 * We cannot call radix_tree_preload for the kernels older
 		 * than 2.6.23, because it is not exported for modules.
 		 */
+retry:
 		err =3D radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
 		if (err)
 			goto failed_unlock;
@@ -219,7 +220,6 @@ int nilfs_btnode_prepare_change_key(struct address_spac=
e *btnc,
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
 =

-retry:
 		spin_lock_irq(&btnc->tree_lock);
 		err =3D radix_tree_insert(&btnc->page_tree, newkey, obh->b_page);
 		spin_unlock_irq(&btnc->tree_lock);
