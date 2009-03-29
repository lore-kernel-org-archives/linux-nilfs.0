From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Mon, 30 Mar 2009 01:38:18 +0900 (JST)
Message-ID: <20090330.013818.63821655.ryusuke@osrg.net>
References: <49CDDB37.9030603@prnet.org>
	<20090328.215257.15833655.ryusuke@osrg.net>
	<49CF92EC.2020803@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49CF92EC.2020803-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi David,
On Sun, 29 Mar 2009 17:25:32 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
> 
> Many thanks for the patch.
> I have seen that you already have included the latest patch in git so I 
> used the git version. I have done a backup/restore on my nilfs2 
> partitions in order to be sure to start with a clean state. So far no 
> corruption did occur and and all used segments have been marked dirty. 
> As generally the corruption only occurred after several times of 
> cleaning, I can only say in a few days, if the patch really solved the 
> problem.

I found another bug which seems the true cause of this problem.
I've just pushed the bugfix to the git repo, so please apply it, too.

After it's verified, I'd like to release the next version.

> I have however had the following result on a fresh restored 1tb 
> partition where the cleaner has not been  run yet:
> 
> server ~ # lssu -a /dev/sda10 | grep -e "2009-" | grep -v -e "-d-"
>                14335  2009-03-29 01:44:28  ad-        2048
>                14589  2009-03-29 01:46:23  ad-         941
> 
> For all other partitions I have only one segment marked as active. Can 
> it be a normal case for nilfs2 that 2 segments are marked as active or 
> is there something weird going on here ? dmesg returns nothing special 
> about this volume. There has also been no system crash so this volume 
> should have been mounted/unmounted correctly.

Nilfs keeps the current segment and next segment as active, so usually
it has two active segments.  But we may see the above case if the
current segment is fully empty.

Othewise, the above bugfix may relate to this; the bugfix corrects the
phenomenon that the active flag appears on wrong segments.

Anyway, it's early to make a toast ;)
I hope the latest bugfix will settle the mess.

Regards,
Ryusuke Konishi
