From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Some code review findings for nilfs-utils
Date: Sat, 11 Jul 2009 02:29:56 +0900 (JST)
Message-ID: <20090711.022956.78023223.ryusuke@osrg.net>
References: <4A57688C.8080308@sandeen.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A57688C.8080308-+82itfer+wXR7s880joybQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sandeen-+82itfer+wXR7s880joybQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Fri, 10 Jul 2009 11:13:00 -0500, Eric Sandeen wrote:
> We ran an automated code checker over nilfs-utils-2.0.13, and it found
> just a few issues:
> 
>                      start < NILFS_CNO_MIN || end > NILFS_CNO_MAX) {
>  /BUILD/nilfs-utils-2.0.13/bin/rmcp.c  203  Warning 685:
>      Relational operator '>' always evaluates to 'false'
> 
> 
>                          oflags |= O_RDONLY;
>  /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  294  Info 835: A
>      zero has been given as right argument to operator '|'
> 
> 
>  /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  899  Warning 438:
>      Last value assigned to variable 'n' (defined at line 895) not used
> 
> 
>          pseg->p_maxblocks = nblocks_per_segment - blkoff;
>  /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  732  Info 712: Loss
>      of precision (assignment) (unsigned long to unsigned int)
> 
> 
> Sorry for not sending patches, but I assume the maintainers can do a
> proper fix more quickly than I can.  :)
> 
> Thanks,
> 
> -Eric

Thanks.  I picked up the first and the third warnings and have pushed
the fixes into the git repo.  ;)

The rest were ok.  The following patch is a digest of the two.

Cheers,
Ryusuke Konishi
--
diff --git a/bin/rmcp.c b/bin/rmcp.c
index 93e0511..2d7a2b9 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -199,8 +199,7 @@ int main(int argc, char *argv[])
 	for ( ; optind < argc; optind++) {
 		if (nilfs_parse_cno_range(argv[optind], &start, &end,
 					  RMCP_BASE) < 0 ||
-		    start > end ||
-		    start < NILFS_CNO_MIN || end > NILFS_CNO_MAX) {
+		    start > end || start < NILFS_CNO_MIN) {
 			fprintf(stderr,
 				"%s: invalid checkpoint range: %s\n",
 				progname, argv[optind]);
diff --git a/lib/nilfs.c b/lib/nilfs.c
index df8792b..63570f4 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -913,9 +913,7 @@ void nilfs_block_next(struct nilfs_block *blk)
 nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *nilfs)
 {
 	struct nilfs_cpinfo cpinfo[1];
-	ssize_t n;
 	
-	n = nilfs_get_cpinfo(nilfs, nilfs->n_mincno, NILFS_CHECKPOINT,
-			     cpinfo, 1);
+	nilfs_get_cpinfo(nilfs, nilfs->n_mincno, NILFS_CHECKPOINT, cpinfo, 1);
 	return nilfs->n_mincno;
 }
