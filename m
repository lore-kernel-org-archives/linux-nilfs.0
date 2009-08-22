From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix ignored error code in
	__nilfs_read_inode()
Date: Sat, 22 Aug 2009 14:41:43 +0300
Message-ID: <200908221441.43584.yuri@itinteg.net>
References: <20090822.202157.120631059.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090822.202157.120631059.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

On Saturday 22 August 2009 14:21:57 Ryusuke Konishi wrote:
> If you apply this, you may see "NILFS: get root inode failed" error
> instead of "NILFS: corrupt root inode.".

 I still get the same error. I add some printk to super.c before line 847
 I get, that S_ISLNK(root->i_mode) is True 

Thank you.
Yuri. 
