From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] NILFS2 does not support swap file
Date: Thu, 09 Apr 2009 02:20:59 +0900 (JST)
Message-ID: <20090409.022059.23552621.ryusuke@osrg.net>
References: <007701c9b84d$f165e830$d431b890$@iis.u-tokyo.ac.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <007701c9b84d$f165e830$d431b890$@iis.u-tokyo.ac.jp>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org

Hi!
On Wed, 8 Apr 2009 22:28:45 +0900, "Yongkun Wang" wrote:
> Hey guys,
>
> I am using NILFS2, the best log-structured file system I've ever used.
> 
> But currently the NILFS2 cannot support the swap file.
> 
> I formatted the partition with nilfs2, then I create a swap file on it, then
> mkswap swapfile, then swapon swapfile, it doesn't work.
> 
> It works well for ext2 file system.

Yes, it is not a bug but an unavoidable restriction since
supporting swapfile requires direct overwrites for the file.

Usually it is incompatible with copy-on-write based file system, and
NILFS is just such a FS.

We have to break COW nature partially if we support swapfile on the
filesystem.

OK, maybe we should describe this restriction in our FAQ page or so.

Thanks for pointed out.

Regards,
Ryusuke Konishi
