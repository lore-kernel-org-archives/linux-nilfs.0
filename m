From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 4/4] nilfs2: add norepair mount option
Date: Fri, 20 Nov 2009 03:10:15 +0900 (JST)
Message-ID: <20091120.031015.04647165.ryusuke@osrg.net>
References: <1258650553-10743-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1258650553-10743-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<4B05821C.4030901@redhat.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B05821C.4030901-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Thu, 19 Nov 2009 11:36:28 -0600, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ryusuke Konishi wrote:
> > This adds norepair mount option that allows users to avoid temporal
> > write access to a read-only mount or snapshots during mount/recovery.
> > Without this option, write access will be even performed for those
> > types of mounts; the temporal write access is needed to mount root
> > file system read-only after an unclean shutdown.
> > 
> > This option is useful for users to avoid any write access on the
> > device.
> 
> For what it's worth, ext3 & ext4 just added a "norecovery" option as
> an alias to "noload" which skips journal replay; xfs already has
> "norecovery" - so if you wish to be consistent with ext3/ext4/xfs,
> "norecovery" may be a good choice for the option?
> 
> Thanks,
> -Eric

Thank you! OK, I'll take your advice.

Ryusuke
