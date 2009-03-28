From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Sat, 28 Mar 2009 21:52:57 +0900 (JST)
Message-ID: <20090328.215257.15833655.ryusuke@osrg.net>
References: <20090327.152005.04656990.ryusuke@osrg.net>
	<20090327.194735.32664212.ryusuke@osrg.net>
	<49CDDB37.9030603@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49CDDB37.9030603-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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

Hi,
On Sat, 28 Mar 2009 09:09:27 +0100, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
> 
> today I have tried the lssu on a dedicated server running nilfs and here 
> I had the following result:
> 
> fr ~ # lssu -a /dev/sda2 | grep -e "2009-" | grep -v -e "-d-"
>                 2558  2009-03-23 16:59:05  ---        2048
>                 4967  2009-03-28 09:07:10  ad-        1928
> 
> so I suppose corruption will soon occur here.

Oh, it would come.

> Is there something I can do to manually mark it as dirty or should I go 
> the backup/restore route ?

No, sorry.  You may as well go the backup/restore route.

BTW, I found a bug in sufile that may relate to this problem.  The
following patch fixes the bug. (I'm now testing this)

If I can confirm that the patch has effect on the dirty flag
evaporation, I will release an update ASAP.

Othewise, I'll continue debugging.
Please try the patch in the meantime.

Regards,
Ryusuke Konishi

diff --git a/fs/sufile.c b/fs/sufile.c
index e64a5de..0ea8558 100644
--- a/fs/sufile.c
+++ b/fs/sufile.c
@@ -553,7 +553,6 @@ int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 
 	nilfs_segment_usage_set_error(su);
 	kunmap_atomic(kaddr, KM_USER0);
-	brelse(su_bh);
 
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
-- 
1.5.6.5
