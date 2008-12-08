From: "Paul L" <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (no subject)
Date: Mon, 8 Dec 2008 16:03:06 -0500
Message-ID: <856033f20812081303v12353110jf51704b81d2a760@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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

Hi, I'm a new user of NILFS2, and I'm using it for both my root and
home partition. Since none of the boot loaders support NILFS2, I had
to use a small ext2 partition to boot, and use initrd scripts to load
the nilfs2 kernel module.

So far everything seems to work fine. But I notice that only one
clearnerd is running, and that's for my home partition. This is
probably because the initrd I use didn't have the nifs_cleanerd binary
in it, so mounting the root partition will not start it. I wonder if
it's safe to start it later manually? Something like "nilfs_cleanerd
/" in the rc.local script?

BTW, thanks for the exellent work, the performance is great on my SSD
netbook, much better than ext2 and reiserfs.

-- 
Regards,
Paul Liu

Yale Haskell Group
http://www.haskell.org/yale
