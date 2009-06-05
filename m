From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Which patches for 2.6.30
Date: Sat, 06 Jun 2009 03:32:21 +0900 (JST)
Message-ID: <20090606.033221.18321078.ryusuke@osrg.net>
References: <mailman.1.1244170801.2227.users@nilfs.org>
	<20090605171027.176549f1@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090605171027.176549f1@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org

Hi!
On Fri, 5 Jun 2009 17:10:27 +0200, "Michael Niederle" wrote:
> Hi!
>
> I want to use nilfs as the root file system of the next version of
> SIMPLUX (a Gentoo-Linux based distribution for pen-drives). Shutdown
> by now works cleanly.  (I had some troubles in the past ...)
> 
> My question is: Which patches do I need to include the most current
> version of nilfs in the upcoming final release of kernel 2.6.30?
> nilfs will be directly included in the kernel (no module). Is it
> possible to have a single patch that does it all?

Basically, you should use the in-tree version without applying any
additional patches because known bugfixes are included in the kernel
2.6.30 and the remaining patches are experimental.

But, you can try the latest version available on the experimental
branch or for-next branch in nilfs2.git:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

(As you can see in

 http://git.kernel.org/?p=linux/kernel/git/ryusuke/nilfs2.git;a=shortlog;h=experimental

 the for-next branch is included in the experimental branch)


If you already have a git clone of linus' tree, you can add those
branches like:

 $ cd linux-2.6
 $ git remote add nilfs2 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
 $ git branch nilfs2-experimental nilfs2/experimental  (or nilfs2/for-next)
 $ git checkout nilfs2-experimental

Otherwise, you can get it directly by:

 $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
 $ cd nilfs2
 $ git checkout experimental

And, you can create the single patch by:

 $ cd nilfs2
 $ git diff master...experimental > ~/v2.6.30-nilfs2-experimental.diff


Note that the for-next branch and the experimental branch are
frequently "rebased" and this may confuse their existing branches.


Cheers,
Ryusuke Konishi
