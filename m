From: <amagai-sG5X7nlA6pw@public.gmane.org>
Subject: Re: __udivdi3
Date: Fri,  4 Jan 2008 23:02:46 +0900 (JST)
Message-ID: <20080104140246.2A3D83E06C1@fs.osrg.net>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
	<20080104014721.3D7163E06C1@fs.osrg.net>
	<20080104041630.57fd0df6.elentirmo.gilgalad@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-reply-to: <20080104041630.57fd0df6.elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (message
	from Gergely =?UTF-8?B?R8OhYm9y?= on Fri, 4 Jan 2008 04:16:30 +0100)
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi, 
please try following patch, 

  cd nilfs-2.0.0-testing-8
  patch -p0 < patch_file
  cd fs
  make clean
  make
  make install

Thanks to Gergely, your dat.o.lst is very helpful!

Amagai Yoshiji
NTT
NILFS team.
================================================================

diff -u fs.save/dat.c fs/dat.c
--- fs.save/dat.c	2008-01-04 22:43:58.000000000 +0900
+++ fs/dat.c	2008-01-04 22:48:46.000000000 +0900
@@ -74,7 +74,7 @@
 inline static unsigned long
 nilfs_dat_group_offset(const struct inode *dat, nilfs_sector_t vblocknr)
 {
-	return sector_div(vblocknr, nilfs_dat_entries_per_group(dat));
+	return do_div(vblocknr, nilfs_dat_entries_per_group(dat));
 }
 
 inline static nilfs_gdno_t
@@ -1161,7 +1161,7 @@
 		kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
 		/* last virtual block number in this block */
 		first = vinfo[i].vi_vblocknr;
-		sector_div(first, entries_per_block);
+		do_div(first, entries_per_block);
 		first *= entries_per_block;
 		last = first + entries_per_block - 1;
 		for (j = i, n = 0;
