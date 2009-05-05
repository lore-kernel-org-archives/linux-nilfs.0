From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Wed, 06 May 2009 00:46:48 +0900 (JST)
Message-ID: <20090506.004648.105122016.ryusuke@osrg.net>
References: <D6LvKjCkn1gF.D60GTY3Z@mail.prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <D6LvKjCkn1gF.D60GTY3Z-GG6YVgmNXeLOQU1ULcgDhA@public.gmane.org>
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

Hi!
On Tue,  5 May 2009 17:26:48 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> Thank you.
> I will try this patch in a few hours.  If I see it correctly the
> patch will prevent this error in future and will not correct the
> current error, so I suppose that after applying the patch I will
> need to reformat the volume.

I expect the patch will even fix the current error on the next GC, but
you had better reformat the volume for safety.

Ryusuke Konishi
