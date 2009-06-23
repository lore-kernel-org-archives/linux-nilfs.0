From: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Subject: kernel source refers to non-existent CONFIG variables
Date: Tue, 23 Jun 2009 10:47:43 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906231046220.26060@localhost>
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


  from the output of a scanning script i have, there are a number of
CONFIG variables that are tested in the linux kernel source but are
not defined anywhere in a Kconfig file:

>>>>> NILFS_FS_POSIX_ACL
fs/nilfs2/inode.c:312:#ifdef CONFIG_NILFS_FS_POSIX_ACL
fs/nilfs2/inode.c:437:#ifdef CONFIG_NILFS_FS_POSIX_ACL
>>>>> NILFS_POSIX_ACL
fs/nilfs2/nilfs.h:61:#ifdef CONFIG_NILFS_POSIX_ACL
fs/nilfs2/nilfs.h:200:#ifdef CONFIG_NILFS_POSIX_ACL
fs/nilfs2/super.c:192:#ifdef CONFIG_NILFS_POSIX_ACL
>>>>> NILFS_XATTR
fs/nilfs2/nilfs.h:51:#ifdef CONFIG_NILFS_XATTR
fs/nilfs2/super.c:165:#ifdef CONFIG_NILFS_XATTR

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
