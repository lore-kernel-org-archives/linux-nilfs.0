From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: pp (protection period) mount option
Date: Wed, 02 Dec 2009 00:44:22 +0900 (JST)
Message-ID: <20091202.004422.69931110.ryusuke@osrg.net>
References: <4B0FE052.70307@unity-linux.org>
	<20091128.012303.54434171.ryusuke@osrg.net>
	<749598c60911281316i40b591b1hcb055b0867617f0e@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <749598c60911281316i40b591b1hcb055b0867617f0e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Sat, 28 Nov 2009 22:16:31 +0100, David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
wrote:
> Thanks you for your valuable comments.
> 
> You are right, of course. No kernel code changes are needed.
> Here is my take #2.
> 
> David

Thank you, David.  I reviewed the patch in detail, and no worrisome
point found.

During tests, I noticed that remount doesn't work for this option:

  For instance, after doing

  # mount -t nilfs2 -o pp=3D600 /dev/sdb1 /test

  and

  # mount -t nilfs2 -o remount,pp=3D400 /dev/sdb1 /test

  then, a cleanerd with "-p 600" was still working.

I think usually this doesn't make trouble, but I'd like to hear your
opinion before merging.  If you want to revise the issue to keep
semantics of remount option, I will wait for you.

If you don't care, I will merge the patch as is.

Thanks,
Ryusuke Konishi
