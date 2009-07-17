From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Is www.nilfs.org/git the development tree?
Date: Sat, 18 Jul 2009 01:47:46 +0900 (JST)
Message-ID: <20090718.014746.73272641.ryusuke@osrg.net>
References: <977a2be20907170900u3c5e64e8ne9373ea100e8b16c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <977a2be20907170900u3c5e64e8ne9373ea100e8b16c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi!
On Sat, 18 Jul 2009 00:00:02 +0800, Zhu Yanhai wrote:
> Hi,
> Is www.nilfs.org/git the development tree? It seems really old, and
> can't compile against v2.6.30 kernel.

The nilfs2-module.git in the site is the tree to maintain standalone
module for kernels prior to 2.6.30.

> If it's not, where is the development git repo for nilfs2?
> 

please see 

http://git.kernel.org/?p=linux/kernel/git/ryusuke/nilfs2.git;a=summary

for the development tree.

Note that the nilfs2.git is a tree to manage patchsets for the
mainline.  I mean its branches are frequently rebased; I recommend you
to use "git remote" if you follow the tree.

Here I address use of branches in the tree:

 o master - mainline

 o fixes - pending bugfixes

 o for-next - branch exported to linux-next
              (used for bonding test and compilation tests)

 o for-linus - this holds patches to be sent to Linus

 o experimental - branch to hold every patch including experimental
                  patches, or patches queued for next merge window.

> Thanks,
> Zhu Yanhai

Cheers,
Ryusuke Konishi
