From: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Subject: Some code review findings for nilfs-utils
Date: Fri, 10 Jul 2009 11:13:00 -0500
Message-ID: <4A57688C.8080308@sandeen.net>
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

We ran an automated code checker over nilfs-utils-2.0.13, and it found
just a few issues:

                     start < NILFS_CNO_MIN || end > NILFS_CNO_MAX) {
 /BUILD/nilfs-utils-2.0.13/bin/rmcp.c  203  Warning 685:
     Relational operator '>' always evaluates to 'false'


                         oflags |= O_RDONLY;
 /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  294  Info 835: A
     zero has been given as right argument to operator '|'


 /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  899  Warning 438:
     Last value assigned to variable 'n' (defined at line 895) not used


         pseg->p_maxblocks = nblocks_per_segment - blkoff;
 /BUILD/nilfs-utils-2.0.13/lib/nilfs.c  732  Info 712: Loss
     of precision (assignment) (unsigned long to unsigned int)


Sorry for not sending patches, but I assume the maintainers can do a
proper fix more quickly than I can.  :)

Thanks,

-Eric
