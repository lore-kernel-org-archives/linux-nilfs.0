From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Fri, 18 Jan 2008 19:11:11 +0900
Message-ID: <1200651072.2931.112.camel@localhost.localdomain>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
	<1200561294.3085.131.camel@localhost.localdomain>
	<20080117183302.275d051d@vosztok>
	<1200628693.2931.54.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1200628693.2931.54.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
Content-Type: text/plain; charset="iso-8859-1"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi G=E1bor,

On Fri, 2008-01-18 at 12:58 +0900, Ryusuke Konishi wrote:
> > > Could you get information through the following way
> >=20
> > I attach the kernel log. Sorry for the long delay, but the machine
> frooze
> > during kernel recompilation, as i didn't use sysrq before. It
> worked.
> > Hope the information will be useful.
> Great!
>=20
> I will look into both logs.
>=20
> Anyway, thanks a lot for your effort.

Your log actually gave me a great hint!

The following part of the log indicates that=20
the device mapper faced starvation of a memory pool,
and was waiting for someone to make room for it.

 Call Trace:
  [mempool_alloc+28/228] mempool_alloc+0x1c/0xe4
  [<c013dd7f>] mempool_alloc+0x1c/0xe4
  [wait_for_completion+125/205] wait_for_completion+0x7d/0xcd
  [<c036c31f>] wait_for_completion+0x7d/0xcd
  [default_wake_function+0/12] default_wake_function+0x0/0xc
  [<c0114c20>] default_wake_function+0x0/0xc
  [<e08c711a>] nilfs_segbuf_wait+0x79/0x1d7 [nilfs2]
  [<e08c7268>] nilfs_segbuf_wait+0x1c7/0x1d7 [nilfs2]
  [<e08c75de>] nilfs_segbuf_write+0x48/0x83 [nilfs2]
  [<e08ca035>] nilfs_segctor_add_dirty+0x1ca3/0x259f [nilfs2]
  [update_curr+267/309] update_curr+0x10b/0x135
  [<c0113b07>] update_curr+0x10b/0x135
  [<e08ca8e0>] nilfs_segctor_add_dirty+0x254e/0x259f [nilfs2]
  [<e08cbd47>] nilfs_clean_segments+0x3e0/0x9ac [nilfs2]
  [<e08cab33>] nilfs_segctor_add_segments_to_be_freed+0x202/0x33b
[nilfs2]
  [<e08cbbcc>] nilfs_clean_segments+0x265/0x9ac [nilfs2]
  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
  [<c0104917>] kernel_thread_helper+0x7/0x10


This seems to arise partly from the current NILFS implementation.
I'll advance analysis, and would like to find a possible
solution to manage this.

In the meantime, you may be able to suppress the problem
by avoiding use of the DM (if possible).

Thanks,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
