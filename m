From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs 2.0.3 bugreport
Date: Fri, 15 Aug 2008 02:32:14 +0900 (JST)
Message-ID: <20080815.023214.44808582.ryusuke@osrg.net>
References: <20080808110915.GA26963@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080808110915.GA26963-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-86GPchAH74ar8sBWe4kruQ@public.gmane.org

Dear Reinoud Zandijk,

On Fri, 8 Aug 2008 13:09:16 +0200, Reinoud Zandijk wrote:
> i've noticed that the DAT file is not always recording its length 
> correctly; at times it jumps to zero blocks recorded and is then increased 
> again when files are touched. Has anyone seen this before?

Sorry for my late reply,
I was almost offline for the last week (and still) on vacation.

The strange behaviour of DAT block count is caused by a bug of 
shadow DAT, a temporary inode used for GC writes;  the shadow DAT
swaps the btree state for the original DAT, but the block count was
not handed over.

Please try the following patch.
it would fix the causal bug, though it doesn't correct the value.
Actually this value is not used for DAT and other meta data files,
but it should be fixed early...

> How do i know the size of the DAT file then? just only insert/append
> unused blocks when needed?

Block count or size?
FYI, in case of size, you can know it in block unit by getting the last
key of bmap.  (nilfs_bmap_last_key() would be of some help).

Best regards,
Ryusuke
---

diff --git a/fs/gcdat.c b/fs/gcdat.c
index 18f16c3..ac7dea9 100644
--- a/fs/gcdat.c
+++ b/fs/gcdat.c
@@ -184,6 +184,7 @@ int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
 	int err;
 
 	gcdat->i_state = 0;
+	gcdat->i_blocks = dat->i_blocks;
 	gii->i_flags = dii->i_flags;
 	gii->i_state = dii->i_state | (1 << NILFS_I_GCDAT);
 	gii->i_cno = 0;
@@ -205,6 +206,7 @@ void nilfs_commit_gcdat_inode(struct the_nilfs *nilfs)
 	struct address_space *gmapping = gcdat->i_mapping;
 
 	down_write(&NILFS_MDT(dat)->mi_sem);
+	dat->i_blocks = gcdat->i_blocks;
 	dii->i_flags = gii->i_flags;
 	dii->i_state = gii->i_state & ~(1 << NILFS_I_GCDAT);
